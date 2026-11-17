import 'package:flutter/material.dart';

import '../demo.dart';
import '../models.dart';
import '../widgets.dart';

class ScriptWriterScreen extends StatefulWidget {
  const ScriptWriterScreen({super.key});

  @override
  State<ScriptWriterScreen> createState() => _ScriptWriterScreenState();
}

class _ScriptWriterScreenState extends State<ScriptWriterScreen> {
  final _topicController = TextEditingController();
  final _outputController = TextEditingController();
  String _type = DemoGenerator.scriptTypes.first;
  String _tone = DemoGenerator.tones.first;
  String _duration = DemoGenerator.durations[2];
  String _audience = DemoGenerator.audiences[2];
  bool _loading = false;
  bool _hasOutput = false;

  @override
  void dispose() {
    _topicController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      showSnack(context, 'অনুগ্রহ করে একটি টপিক লিখুন');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    final result = DemoGenerator.script(
      topic: topic,
      type: _type,
      tone: _tone,
      duration: _duration,
      audience: _audience,
    );
    if (!mounted) return;
    setState(() {
      _outputController.text = result;
      _loading = false;
      _hasOutput = true;
    });
  }

  Future<void> _save() async {
    final text = _outputController.text.trim();
    if (text.isEmpty) {
      showSnack(context, 'সংরক্ষণ করার মতো কিছু নেই');
      return;
    }
    await StorageService.add(
      Project(
        id: StorageService.newId(),
        title: _topicController.text.trim().isEmpty
            ? 'নতুন স্ক্রিপ্ট'
            : _topicController.text.trim(),
        type: 'স্ক্রিপ্ট',
        content: text,
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) showSnack(context, 'প্রজেক্ট সংরক্ষিত হয়েছে');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('এআই স্ক্রিপ্ট লেখক'),
        actions: const [DemoChip(), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          TextField(
            controller: _topicController,
            decoration: const InputDecoration(
              labelText: 'টপিক *',
              hintText: 'যেমন: গ্রামের সকাল, শীতের পিঠা...',
              prefixIcon: Icon(Icons.topic_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'কনটেন্টের ধরন'),
                  items: DemoGenerator.scriptTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _type = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _tone,
                  decoration: const InputDecoration(labelText: 'টোন'),
                  items: DemoGenerator.tones
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _tone = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _duration,
                  decoration: const InputDecoration(labelText: 'সময়কাল'),
                  items: DemoGenerator.durations
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _duration = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _audience,
                  decoration: const InputDecoration(labelText: 'দর্শক'),
                  items: DemoGenerator.audiences
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _audience = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_loading ? 'তৈরি হচ্ছে...' : 'স্ক্রিপ্ট তৈরি করুন'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ডেমো মোডে নমুনা স্ক্রিপ্ট তৈরি হয়। লাইভ এআই যুক্ত হলে আসল এআই স্ক্রিপ্ট পাবেন।',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          if (_hasOutput) ...[
            const SectionTitle(title: 'আপনার স্ক্রিপ্ট'),
            const SizedBox(height: 8),
            TextField(
              controller: _outputController,
              maxLines: 14,
              decoration: const InputDecoration(
                hintText: 'স্ক্রিপ্ট এখানে দেখাবে...',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => copyText(context, _outputController.text),
                    icon: const Icon(Icons.copy_outlined),
                    label: const Text('কপি করুন'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('সংরক্ষণ করুন'),
                  ),
                ),
              ],
            ),
          ] else
            const EmptyState(
              icon: Icons.edit_note_outlined,
              title: 'এখনো কোনো স্ক্রিপ্ট তৈরি হয়নি',
              subtitle: 'উপরে টপিক লিখে "স্ক্রিপ্ট তৈরি করুন" বোতামে চাপ দিন।',
            ),
        ],
      ),
    );
  }
}
