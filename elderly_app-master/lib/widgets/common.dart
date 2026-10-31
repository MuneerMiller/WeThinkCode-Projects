import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_scope.dart';

/// Keeps content readable on tablets and in desktop browsers.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 640});
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
    child: Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium),
        ),
        ?trailing,
      ],
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.image,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null)
            Image.asset(image!, height: 160, excludeFromSemantics: true)
          else
            CircleAvatar(
              radius: 48,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                icon,
                size: 48,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Square-cornered coloured icon used at the start of list rows.
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key, this.color, this.size = 52});
  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = color ?? scheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: c, size: size * 0.55),
    );
  }
}

Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  )
                : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String? requiredField(String? value, String what) =>
    (value == null || value.trim().isEmpty) ? 'Please enter $what' : null;

String formatTime(BuildContext context, DateTime t) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(t),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

String formatDay(DateTime d, {DateTime? now}) {
  now ??= DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = day.difference(today).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff == -1) return 'Yesterday';
  return DateFormat(d.year == now.year ? 'EEE d MMM' : 'EEE d MMM y').format(d);
}

String greeting(DateTime now) {
  if (now.hour < 12) return 'Good morning';
  if (now.hour < 17) return 'Good afternoon';
  return 'Good evening';
}

/// Lets a user pick a date then a time.
Future<DateTime?> pickDateTime(BuildContext context, DateTime initial) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(now.year - 5),
    lastDate: DateTime(now.year + 5),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// A form's main button, pinned to the bottom of the screen so it is always
/// visible and never hidden behind the keyboard or a message.
class BottomAction extends StatelessWidget {
  const BottomAction({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: ContentWidth(
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reads [text] aloud; tap again to stop. Works without a Navigator, so it
/// can also be used on the lock screen.
class ReadAloudButton extends StatelessWidget {
  const ReadAloudButton({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final speech = context.services.speech;
    return ValueListenableBuilder<String?>(
      valueListenable: speech.speaking,
      builder: (context, speaking, _) {
        final active = speaking == text;
        return OutlinedButton.icon(
          onPressed: () => active ? speech.stop() : speech.speak(text),
          icon: Icon(
            active ? Icons.stop_circle_outlined : Icons.volume_up_rounded,
          ),
          label: Text(active ? 'Stop reading' : 'Read aloud'),
        );
      },
    );
  }
}
