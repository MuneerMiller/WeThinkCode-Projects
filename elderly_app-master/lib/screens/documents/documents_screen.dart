import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../widgets/common.dart';

/// Photos of prescriptions, reports and other paperwork, searchable by name.
class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _query = '';

  Future<void> _add() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded, size: 30),
                title: const Text('Take a photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, size: 30),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null || !mounted) return;
    final XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 80,
      );
    } catch (e) {
      if (mounted) {
        showMessage(context, 'Could not open the camera or gallery.');
      }
      return;
    }
    if (file == null || !mounted) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddDocumentScreen(bytes: bytes, suggestedName: file!.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final theme = Theme.of(context);
    final docs =
        store.documents
            .where((d) => d.name.toLowerCase().contains(_query.toLowerCase()))
            .toList()
          ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add_a_photo_rounded, size: 28),
        label: const Text('Add document'),
      ),
      body: store.documents.isEmpty
          ? const Center(
              child: SingleChildScrollView(
                child: EmptyState(
                  icon: Icons.folder_copy_rounded,
                  title: 'No documents yet',
                  message:
                      'Take photos of prescriptions, test results and medical aid cards to keep them handy.',
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              children: [
                ContentWidth(
                  maxWidth: 900,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          hintText: 'Search documents',
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                      const SizedBox(height: 16),
                      if (docs.isEmpty)
                        // Own node so it isn't read as the search box's
                        // label, and announced when it appears.
                        Semantics(
                          container: true,
                          liveRegion: true,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Nothing matches "$_query".',
                              style: theme.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      LayoutBuilder(
                        builder: (context, c) {
                          final cols = c.maxWidth > 600 ? 3 : 2;
                          return GridView.count(
                            crossAxisCount: cols,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.78,
                            children: [for (final d in docs) _DocumentTile(d)],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile(this.doc);
  final HealthDocument doc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => DocumentViewScreen(doc: doc))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.memory(
                doc.bytes,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                semanticLabel: doc.name,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.broken_image_rounded, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formatDay(doc.addedAt),
                    style: theme.textTheme.bodySmall,
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

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({
    super.key,
    required this.bytes,
    required this.suggestedName,
  });
  final Uint8List bytes;
  final String suggestedName;

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final store = context.store;
    await store.saveDocument(
      HealthDocument(
        id: store.newId(),
        name: _name.text.trim(),
        imageBase64: base64Encode(widget.bytes),
        addedAt: DateTime.now(),
      ),
    );
    if (mounted) {
      showMessage(context, 'Document saved');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Save document'),
        ),
      ),
      appBar: AppBar(title: const Text('Save document')),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      widget.bytes,
                      height: 320,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _name,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g. Blood test March',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) =>
                        requiredField(v, 'a name so you can find it later'),
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

class DocumentViewScreen extends StatelessWidget {
  const DocumentViewScreen({super.key, required this.doc});
  final HealthDocument doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(doc.name),
        titleTextStyle: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Delete document',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              final ok = await confirm(
                context,
                title: 'Delete ${doc.name}?',
                message: 'This photo will be removed from the app.',
                confirmLabel: 'Delete',
                destructive: true,
              );
              if (!ok || !context.mounted) return;
              await context.store.deleteDocument(doc.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        maxScale: 6,
        child: Center(child: Image.memory(doc.bytes)),
      ),
    );
  }
}
