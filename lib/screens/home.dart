import 'package:flutter/material.dart';

import '../models.dart';
import '../widgets.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int tab) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Project> _projects = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _projects = StorageService.load());

  Future<void> _go(String route) async {
    await Navigator.pushNamed(context, route);
    if (mounted) _load();
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_note_outlined),
                title: const Text('নতুন স্ক্রিপ্ট'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onNavigateTab(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text('নতুন পোস্টার'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onNavigateTab(2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.auto_stories_outlined),
                title: const Text('নতুন গল্প'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onNavigateTab(3);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('সোশ্যাল পোস্ট'),
                onTap: () {
                  Navigator.pop(ctx);
                  _go('/social');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final recent = _projects.take(3).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('বাংলা ক্রিয়েটর স্টুডিও'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'সেটিংস',
            onPressed: () => _go('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Welcome card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F766E), Color(0xFF134E4A)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'আসসালামু আলাইকুম, ক্রিয়েটর!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'আজ কী তৈরি করবেন? স্ক্রিপ্ট, পোস্টার, গল্প — সবকিছু এখানেই।',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Chip(
                      label: Text('${toBnDigits(_projects.length.toString())}টি প্রজেক্ট'),
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      side: BorderSide.none,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: const Icon(
                        Icons.science_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text('ডেমো মোড'),
                      backgroundColor: Colors.amber.withValues(alpha: 0.35),
                      side: BorderSide.none,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Usage card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insights_outlined, color: color.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'আপনার ব্যবহার',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _go('/subscription'),
                        child: const Text('প্রো দেখুন'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ফ্রি প্ল্যানে আছেন। ডেমো মোডে সীমাহীন নমুনা কনটেন্ট তৈরি করা যাবে। লাইভ এআই যুক্ত হলে দৈনিক সীমা এখানে দেখাবে।',
                    style: TextStyle(
                      color: color.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 0.25,
                      minHeight: 8,
                      backgroundColor: color.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'ডেমো ব্যবহার: ২৫%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'ফিচারসমূহ'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.05,
            children: [
              FeatureCard(
                icon: Icons.edit_note_outlined,
                title: 'এআই স্ক্রিপ্ট লেখক',
                subtitle: 'বাংলা স্ক্রিপ্ট তৈরি করুন',
                color: Colors.teal,
                onTap: () => widget.onNavigateTab(1),
              ),
              FeatureCard(
                icon: Icons.image_outlined,
                title: 'পোস্টার স্টুডিও',
                subtitle: 'নিউজ কার্ড ও থাম্বনেইল',
                color: Colors.deepOrange,
                onTap: () => widget.onNavigateTab(2),
              ),
              FeatureCard(
                icon: Icons.auto_stories_outlined,
                title: 'এআই গল্প স্টুডিও',
                subtitle: 'দৃশ্য-দৃশ্যে গল্প ও প্রম্পট',
                color: Colors.indigo,
                onTap: () => widget.onNavigateTab(3),
              ),
              FeatureCard(
                icon: Icons.share_outlined,
                title: 'সোশ্যাল সহকারী',
                subtitle: 'ক্যাপশন ও হ্যাশট্যাগ',
                color: Colors.pink,
                onTap: () => _go('/social'),
              ),
              FeatureCard(
                icon: Icons.folder_outlined,
                title: 'আমার প্রজেক্ট',
                subtitle: 'সংরক্ষিত কাজ দেখুন',
                color: Colors.amber.shade800,
                onTap: () => widget.onNavigateTab(4),
              ),
              FeatureCard(
                icon: Icons.workspace_premium_outlined,
                title: 'সাবস্ক্রিপশন',
                subtitle: 'ফ্রি, প্রো ও ক্রিয়েটর প্লাস',
                color: Colors.purple,
                onTap: () => _go('/subscription'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionTitle(
            title: 'সাম্প্রতিক প্রজেক্ট',
            actionLabel: 'সব দেখুন',
            onAction: () => widget.onNavigateTab(4),
          ),
          const SizedBox(height: 12),
          if (recent.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('এখনো কোনো প্রজেক্ট নেই। নিচের বোতামে নতুন কিছু তৈরি করুন!'),
              ),
            )
          else
            ...recent.map(
              (p) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.primary.withValues(alpha: 0.12),
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
                  subtitle: Text('${p.type} • ${bnDate(p.updatedAt)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => widget.onNavigateTab(4),
                ),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _showCreateSheet,
              icon: const Icon(Icons.add),
              label: const Text('নতুন তৈরি করুন'),
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
