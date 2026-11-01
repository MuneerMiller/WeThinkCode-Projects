import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  void _open(BuildContext context, [Note? n]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FeatureTheme(
          feature: Feature.notes,
          child: NoteEditScreen(note: n),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.store.sortedNotes;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _open(context),
        icon: const Icon(Icons.edit_note_rounded, size: 28),
        label: const Text('New note'),
      ),
      body: notes.isEmpty
          ? const Center(
              child: SingleChildScrollView(
                child: EmptyState(
                  icon: Icons.sticky_note_2_rounded,
                  title: 'No notes yet',
                  message:
                      'Write down things to remember, questions for the doctor, or anything else.',
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              children: [
                for (final n in notes)
                  ContentWidth(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: InkWell(
                          onTap: () => _open(context, n),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (n.priority == NotePriority.high) ...[
                                      Icon(
                                        Icons.priority_high_rounded,
                                        color: theme.colorScheme.error,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                    Expanded(
                                      child: Text(
                                        n.title,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                if (n.body.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    n.body,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Text(
                                  '${n.priority == NotePriority.high ? 'Important · ' : ''}'
                                  'Updated ${formatDay(n.updatedAt).toLowerCase()}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class NoteEditScreen extends StatefulWidget {
  const NoteEditScreen({super.key, this.note});
  final Note? note;

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.note?.title);
  late final _body = TextEditingController(text: widget.note?.body);
  late NotePriority _priority = widget.note?.priority ?? NotePriority.normal;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final store = context.store;
    final now = DateTime.now();
    final n =
        widget.note ??
        Note(
          id: store.newId(),
          title: '',
          body: '',
          priority: _priority,
          createdAt: now,
          updatedAt: now,
        );
    n
      ..title = _title.text.trim()
      ..body = _body.text.trim()
      ..priority = _priority
      ..updatedAt = now;
    await store.saveNote(n);
    if (mounted) {
      showMessage(context, 'Note saved');
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final n = widget.note!;
    final ok = await confirm(
      context,
      title: 'Delete this note?',
      message: '"${n.title}" will be removed.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !mounted) return;
    await context.store.deleteNote(n.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.note != null;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Save note'),
        ),
      ),
      appBar: AppBar(
        title: Text(editing ? 'Edit note' : 'New note'),
        actions: [
          if (editing)
            IconButton(
              tooltip: 'Delete note',
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: Form(
        key: _form,
        // Clear an error as soon as the user fixes it.
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) => requiredField(v, 'a title'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _body,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      alignLabelWithHint: true,
                    ),
                    minLines: 6,
                    maxLines: 14,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SectionHeader('How important is it?'),
                  SegmentedButton<NotePriority>(
                    segments: const [
                      ButtonSegment(
                        value: NotePriority.high,
                        icon: Icon(Icons.priority_high_rounded),
                        label: Text('Important'),
                      ),
                      ButtonSegment(
                        value: NotePriority.normal,
                        label: Text('Normal'),
                      ),
                    ],
                    selected: {_priority},
                    onSelectionChanged: (s) =>
                        setState(() => _priority = s.first),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
