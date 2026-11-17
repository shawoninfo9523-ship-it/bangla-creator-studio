import 'package:flutter/material.dart';

import '../models.dart';
import '../widgets.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _filter = 'সব';
  List<Project> _projects = [];

  static const _filters = ['সব', 'স্ক্রিপ্ট', 'গল্প', 'সোশ্যাল', 'পোস্টার'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _projects = StorageService.load());

  List<Project> get _visible =>
      _filter == 'সব' ? _projects : _projects.where((p) => p.type == _filter).toList();

  Future<void> _open(Project p) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProjectEditorScreen(project: p)),
    );
    if (changed == true && mounted) _load();
  }

  Future<void> _rename(Project p) async {
    final controller = TextEditingController(text: p.title);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('প্রজেক্টের নাম বদলান'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'নতুন নাম'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('বাতিল'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('সংরক্ষণ'),
          ),
        ],
      ),
    );
    if (ok == true && controller.text.trim().isNotEmpty) {
      p.title = controller.text.trim();
      p.updatedAt = DateTime.now();
      await StorageService.update(p);
      if (mounted) {
        _load();
        showSnack(context, 'নাম বদলে গেছে');
      }
    }
    controller.dispose();
  }

  Future<void> _delete(Project p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('প্রজেক্ট মুছে ফেলবেন?'),
        content: Text('"${p.title}" মুছে ফেলা হবে। এই কাজটি আর ফেরানো যাবে না।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('বাতিল'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('মুছে ফেলুন'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await StorageService.remove(p.id);
      if (mounted) {
        _load();
        showSnack(context, 'প্রজেক্ট মুছে ফেলা হয়েছে');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('আমার প্রজেক্ট')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: _filters.map((f) {
                final selected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _visible.isEmpty
                ? EmptyState(
                    icon: Icons.folder_outlined,
                    title: 'কোনো প্রজেক্ট পাওয়া যায়নি',
                    subtitle: _filter == 'সব'
                        ? 'স্ক্রিপ্ট, গল্প বা পোস্টার তৈরি করে সংরক্ষণ করুন — সেগুলো এখানে দেখাবে।'
                        : '"$_filter" ধরনের কোনো প্রজেক্ট নেই।',
                    buttonLabel: 'নতুন তৈরি করুন',
                    onButton: () =>
                        Navigator.pushNamed(context, '/script'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _visible.length,
                    itemBuilder: (context, i) {
                      final p = _visible[i];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                color.primary.withValues(alpha: 0.12),
                            child: Icon(
                              _typeIcon(p.type),
                              color: color.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            p.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${p.type} • ${bnDate(p.updatedAt)}',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'rename') _rename(p);
                              if (v == 'delete') _delete(p);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'rename',
                                child: Text('নাম বদলান'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('মুছে ফেলুন'),
                              ),
                            ],
                          ),
                          onTap: () => _open(p),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'স্ক্রিপ্ট':
        return Icons.edit_note_outlined;
      case 'গল্প':
        return Icons.auto_stories_outlined;
      case 'সোশ্যাল':
        return Icons.share_outlined;
      case 'পোস্টার':
        return Icons.image_outlined;
      default:
        return Icons.description_outlined;
    }
  }
}

class ProjectEditorScreen extends StatefulWidget {
  final Project project;

  const ProjectEditorScreen({super.key, required this.project});

  @override
  State<ProjectEditorScreen> createState() => _ProjectEditorScreenState();
}

class _ProjectEditorScreenState extends State<ProjectEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _contentController = TextEditingController(text: widget.project.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      showSnack(context, 'প্রজেক্টের একটি নাম দিন');
      return;
    }
    widget.project.title = _titleController.text.trim();
    widget.project.content = _contentController.text;
    widget.project.updatedAt = DateTime.now();
    await StorageService.update(widget.project);
    if (mounted) {
      showSnack(context, 'সংরক্ষিত হয়েছে');
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.type),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: 'কপি করুন',
            onPressed: () => copyText(context, _contentController.text),
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'সংরক্ষণ করুন',
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'প্রজেক্টের নাম'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentController,
            maxLines: 20,
            decoration: const InputDecoration(
              labelText: 'কনটেন্ট',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('সংরক্ষণ করুন'),
            ),
          ),
        ],
      ),
    );
  }
}
