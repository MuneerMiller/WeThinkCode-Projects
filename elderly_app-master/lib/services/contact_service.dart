import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hands calls, texts, maps and video calls off to the phone's own apps.
class ContactService {
  const ContactService();

  Future<bool> call(String number) =>
      _open(Uri(scheme: 'tel', path: _clean(number)));

  /// Opens the messaging app with [body] filled in for every recipient.
  Future<bool> sms(List<String> numbers, String body) {
    final to = numbers.map(_clean).join(',');
    // `Uri(queryParameters:)` encodes spaces as "+", which some SMS apps show
    // literally, so encode the body by hand.
    return _open(Uri.parse('sms:$to?body=${Uri.encodeComponent(body)}'));
  }

  Future<bool> openUrl(String url) => _open(Uri.parse(url));

  Future<bool> _open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Don't log the number or message: they are personal.
      debugPrint('Could not open a ${uri.scheme} link (${e.runtimeType})');
      return false;
    }
  }

  static String _clean(String number) =>
      number.replaceAll(RegExp(r'[^0-9+*#]'), '');
}

String mapsLink(double lat, double lon) =>
    'https://www.google.com/maps/search/?api=1&query=${lat.toStringAsFixed(6)},${lon.toStringAsFixed(6)}';

String directionsLink(double lat, double lon) =>
    'https://www.google.com/maps/dir/?api=1&destination=${lat.toStringAsFixed(6)},${lon.toStringAsFixed(6)}';
