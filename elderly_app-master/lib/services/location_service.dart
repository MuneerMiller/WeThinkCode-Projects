import 'dart:convert';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GeoPoint {
  const GeoPoint(this.lat, this.lon);
  final double lat;
  final double lon;

  /// Straight-line distance in kilometres (haversine).
  double distanceTo(GeoPoint other) {
    const r = 6371.0;
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(other.lat - lat);
    final dLon = rad(other.lon - lon);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(lat)) *
            math.cos(rad(other.lat)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * r * math.asin(math.sqrt(a));
  }
}

class LocationException implements Exception {
  const LocationException(this.message);
  final String message;
  @override
  String toString() => message;
}

class LocationService {
  const LocationService();

  /// The device's position, asking for permission when needed.
  Future<GeoPoint> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(
        'Location is switched off. Please turn it on in your phone settings.',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Elderly Care needs permission to see your location.',
      );
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return GeoPoint(pos.latitude, pos.longitude);
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return GeoPoint(last.latitude, last.longitude);
      throw const LocationException('We could not find your location.');
    }
  }
}

class Hospital {
  const Hospital({
    required this.name,
    required this.location,
    required this.distanceKm,
    this.phone,
    this.address,
  });

  final String name;
  final GeoPoint location;
  final double distanceKm;
  final String? phone;
  final String? address;
}

/// Finds hospitals and clinics near a point using OpenStreetMap's free
/// Overpass API (no key required).
class HospitalService {
  HospitalService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const endpoint = 'https://overpass-api.de/api/interpreter';

  Future<List<Hospital>> near(GeoPoint here, {int radiusMeters = 10000}) async {
    final around = 'around:$radiusMeters,${here.lat},${here.lon}';
    final query =
        '[out:json][timeout:25];'
        '(nwr["amenity"="hospital"]($around);nwr["amenity"="clinic"]($around););'
        'out center tags 40;';
    final res = await _client.post(Uri.parse(endpoint), body: {'data': query});
    if (res.statusCode != 200) {
      throw Exception('Hospital search failed (${res.statusCode})');
    }
    return parse(jsonDecode(res.body), here);
  }

  static List<Hospital> parse(Map<String, dynamic> json, GeoPoint here) {
    final out = <Hospital>[];
    for (final el in (json['elements'] as List? ?? const [])) {
      final tags = (el['tags'] as Map?)?.cast<String, dynamic>() ?? const {};
      final name = tags['name'] as String?;
      final lat = (el['lat'] ?? el['center']?['lat']) as num?;
      final lon = (el['lon'] ?? el['center']?['lon']) as num?;
      if (name == null || lat == null || lon == null) continue;
      final point = GeoPoint(lat.toDouble(), lon.toDouble());
      final street = [
        tags['addr:housenumber'],
        tags['addr:street'],
      ].whereType<String>().join(' ');
      final address = [
        street,
        tags['addr:suburb'] ?? tags['addr:city'],
      ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
      out.add(
        Hospital(
          name: name,
          location: point,
          distanceKm: here.distanceTo(point),
          phone: (tags['phone'] ?? tags['contact:phone']) as String?,
          address: address.isEmpty ? null : address,
        ),
      );
    }
    out.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return out;
  }
}
