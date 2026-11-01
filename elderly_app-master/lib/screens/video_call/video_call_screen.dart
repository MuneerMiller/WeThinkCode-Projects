import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/l10n.dart';
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
    final l = context.l10n;
    final services = context.services;
    final store = context.store;
    final base = '${services.jitsiServer}/${_room(context)}';
    final config = [
      if (_audioOnly) 'config.startAudioOnly=true',
      if (_startMuted) 'config.startWithAudioMuted=true',
      'userInfo.displayName=%22${Uri.encodeComponent(store.profile!.name)}%22',
    ].join('&');
    if (_textFamily && store.relatives.isNotEmpty) {
      await services.contacts.sms([
        for (final r in store.relatives) r.phone,
      ], l.videoInviteSms(store.profile!.firstName, base));
    }
    final opened = await services.contacts.openUrl('$base#$config');
    if (!opened && mounted) {
      showMessage(context, l.videoOpenFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final store = context.store;
    final hasFamily = store.relatives.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: Text(l.featureVideoCall)),
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
                  l.videoHeading,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l.videoExplanation,
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
                        title: Text(l.videoTextFamily),
                        subtitle: Text(
                          hasFamily
                              ? store.relatives.map((r) => r.name).join(', ')
                              : l.videoAddFamilyFirst,
                        ),
                        value: _textFamily && hasFamily,
                        onChanged: hasFamily
                            ? (v) => setState(() => _textFamily = v)
                            : null,
                      ),
                      const Divider(indent: 20, endIndent: 20),
                      SwitchListTile(
                        secondary: const Icon(Icons.headset_mic_rounded),
                        title: Text(l.videoVoiceOnly),
                        value: _audioOnly,
                        onChanged: (v) => setState(() => _audioOnly = v),
                      ),
                      const Divider(indent: 20, endIndent: 20),
                      SwitchListTile(
                        secondary: const Icon(Icons.mic_off_rounded),
                        title: Text(l.videoStartMuted),
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
                    label: Text(l.videoStart),
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
