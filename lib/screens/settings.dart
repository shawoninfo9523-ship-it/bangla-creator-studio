import 'package:flutter/material.dart';

import '../widgets.dart';
import 'splash_onboarding.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode mode;
  final void Function(ThemeMode) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.mode,
    required this.onThemeChanged,
  });

  void _showInfoDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সেটিংস')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const SectionTitle(title: 'থিম'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('সিস্টেম অনুযায়ী'),
                  value: ThemeMode.system,
                  groupValue: mode,
                  onChanged: (v) => onThemeChanged(v!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('লাইট'),
                  value: ThemeMode.light,
                  groupValue: mode,
                  onChanged: (v) => onThemeChanged(v!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('ডার্ক'),
                  value: ThemeMode.dark,
                  groupValue: mode,
                  onChanged: (v) => onThemeChanged(v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle(title: 'সাধারণ'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('ভাষা'),
                  subtitle: const Text('বাংলা (আরও ভাষা শীঘ্রই আসছে)'),
                  onTap: () => showSnack(context, 'বর্তমানে শুধু বাংলা ভাষা চালু আছে'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('গোপনীয়তা'),
                  subtitle: const Text('আপনার তথ্য কীভাবে সুরক্ষিত থাকে'),
                  onTap: () => _showInfoDialog(
                    context,
                    'গোপনীয়তা',
                    '• আপনার প্রজেক্ট শুধু আপনার ফোনেই সংরক্ষিত থাকে।\n'
                    '• অ্যাপটি কোনো অ্যাকাউন্ট চায় না এবং অপ্রয়োজনীয় ব্যক্তিগত তথ্য সংগ্রহ করে না।\n'
                    '• ডেমো মোডে কোনো তথ্য ইন্টারনেটে পাঠানো হয় না।\n'
                    '• লাইভ এআই যুক্ত হলে, শুধু আপনার লেখা টপিক/টেক্সট নিরাপদ সার্ভারে যাবে — কোনো গোপন কী (API key) অ্যাপের ভেতরে থাকে না।',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outlined),
                  title: const Text('সাহায্য ও প্রশ্নোত্তর'),
                  subtitle: const Text('সাধারণ প্রশ্নের উত্তর'),
                  onTap: () => _showInfoDialog(
                    context,
                    'সাহায্য',
                    'প্রশ্ন: স্ক্রিপ্ট কি আসল এআই দিয়ে তৈরি?\n'
                    'উত্তর: এখন ডেমো মোডে নমুনা স্ক্রিপ্ট তৈরি হয়। লাইভ এআই যুক্ত হলে আসল এআই কনটেন্ট পাবেন।\n\n'
                    'প্রশ্ন: আমার প্রজেক্ট কি হারিয়ে যাবে?\n'
                    'উত্তর: না, প্রজেক্ট আপনার ফোনেই সংরক্ষিত থাকে। অ্যাপ আনইনস্টল করলে মুছে যাবে।\n\n'
                    'প্রশ্ন: পোস্টার কোথায় সংরক্ষিত হয়?\n'
                    'উত্তর: এক্সপোর্ট করলে ছবিটি ফোনের স্টোরেজে PNG ফাইল হিসেবে সংরক্ষিত হয় এবং পাথ দেখানো হয়।',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.play_circle_outlined),
                  title: const Text('অনবোর্ডিং আবার দেখুন'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OnboardingScreen(
                          onDone: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle(title: 'অ্যাপ সম্পর্কে'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bangla Creator Studio AI',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text('সংস্করণ ১.০.০ (ডেমো মোড)'),
                        SizedBox(height: 2),
                        Text('বাংলাদেশি ক্রিয়েটরদের জন্য তৈরি'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
