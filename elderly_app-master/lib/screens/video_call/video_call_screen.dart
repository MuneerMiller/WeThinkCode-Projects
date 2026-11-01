import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../widgets/common.dart';

/// Starts a Jitsi Meet video call in the user's own room and texts the link
/// to their family so they can join.
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _audioOnly = false;
  bool _startMuted = false;
  bool _textFamily = true;

  /// The same room every time so family can bookmark it. It is named only
  /// by 16 random characters: no personal details, and too long to guess.
  String _room(BuildContext context) =>
      'ElderlyCare-${context.store.callRoomSalt}';

  Future<void> _start() async {
    final services = context.services;
    final store = context.store;
    final base = '${services.jitsiServer}/${_room(context)}';
    final config = [
      if (_audioOnly) 'config.startAudioOnly=true',
      if (_startMuted) 'config.startWithAudioMuted=true',
      'userInfo.displayName=%22${Uri.encodeComponent(store.profile!.name)}%22',
    ].join('&');
    if (_textFamily && store.relatives.isNotEmpty) {
      await services.contacts.sms(
        [for (final r in store.relatives) r.phone],
        '${store.profile!.firstName} would like a video call. Join here: $base',
      );
    }
    final opened = await services.contacts.openUrl('$base#$config');
    if (!opened && mounted) {
      showMessage(context, 'Could not open the video call.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = context.store;
    final hasFamily = store.relatives.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Video call')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.videocam_rounded,
                    size: 60,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'See and talk to your family',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'The call opens in your browser or the Jitsi Meet app. It is free and needs no account.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.sms_rounded),
                        title: const Text('Text my family the link'),
                        subtitle: Text(
                          hasFamily
                              ? store.relatives.map((r) => r.name).join(', ')
                              : 'Add family first',
                        ),
                        value: _textFamily && hasFamily,
                        onChanged: hasFamily
                            ? (v) => setState(() => _textFamily = v)
                            : null,
                      ),
                      const Divider(indent: 20, endIndent: 20),
                      SwitchListTile(
                        secondary: const Icon(Icons.headset_mic_rounded),
                        title: const Text('Voice only (no camera)'),
                        value: _audioOnly,
                        onChanged: (v) => setState(() => _audioOnly = v),
                      ),
                      const Divider(indent: 20, endIndent: 20),
                      SwitchListTile(
                        secondary: const Icon(Icons.mic_off_rounded),
                        title: const Text('Start with microphone off'),
                        value: _startMuted,
                        onChanged: (v) => setState(() => _startMuted = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 68,
                  child: FilledButton.icon(
                    onPressed: _start,
                    icon: const Icon(Icons.video_call_rounded, size: 30),
                    label: const Text('Start video call'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
