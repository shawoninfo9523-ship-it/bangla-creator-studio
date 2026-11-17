import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  void _showDemoBillingDialog(BuildContext context, String planName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$planName — ডেমো মোড'),
        content: const Text(
          'পেমেন্ট এখনো চালু হয়নি। Google Play Billing ও নিরাপদ ব্যাকএন্ড যুক্ত হলে এখান থেকে সাবস্ক্রিপশন কেনা যাবে। ডেমো মোডে কোনো পেমেন্ট নেওয়া হয় না এবং কোনো ফিচার আনলক হয় না।',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('বুঝেছি'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('সাবস্ক্রিপশন')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outlined, color: Colors.amber),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'ডেমো মোড — লাইভ বিলিং এখনো চালু হয়নি। দামগুলো প্রাথমিক উদাহরণ।',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PlanCard(
            name: 'ফ্রি',
            price: AppPrices.freeMonthly,
            period: 'সবসময় ফ্রি',
            features: const [
              'ডেমো মোডে নমুনা কনটেন্ট',
              'পোস্টার স্টুডিও',
              'প্রজেক্ট সংরক্ষণ (ডিভাইসে)',
              'লাইট ও ডার্ক থিম',
            ],
            highlighted: false,
            buttonLabel: 'বর্তমান প্ল্যান',
            enabled: false,
            onPressed: () {},
          ),
          _PlanCard(
            name: 'প্রো',
            price: AppPrices.proMonthly,
            period: 'প্রতি মাসে',
            badge: 'জনপ্রিয়',
            features: const [
              'ফ্রি প্ল্যানের সবকিছু',
              'লাইভ এআই স্ক্রিপ্ট ও গল্প (শীঘ্রই)',
              'উচ্চমানের পোস্টার এক্সপোর্ট',
              'অগ্রাধিকার সাপোর্ট',
            ],
            highlighted: true,
            buttonLabel: 'প্রো নিন',
            enabled: true,
            onPressed: () => _showDemoBillingDialog(context, 'প্রো'),
          ),
          _PlanCard(
            name: 'ক্রিয়েটর প্লাস',
            price: AppPrices.plusMonthly,
            period: 'প্রতি মাসে',
            features: const [
              'প্রো প্ল্যানের সবকিছু',
              'টিমের জন্য ৩টি সিট (শীঘ্রই)',
              'ব্র্যান্ড কিট ও টেমপ্লেট',
              'নতুন ফিচারে আগাম অ্যাক্সেস',
            ],
            highlighted: false,
            buttonLabel: 'ক্রিয়েটর প্লাস নিন',
            enabled: true,
            onPressed: () => _showDemoBillingDialog(context, 'ক্রিয়েটর প্লাস'),
          ),
          const SizedBox(height: 8),
          Text(
            'লাইভ বিলিং চালু হলে সব কেনাকাটা নিরাপদ ব্যাকএন্ডে যাচাই করা হবে। দাম পরিবর্তন হতে পারে।',
            textAlign: TextAlign.center,
            style: TextStyle(color: color.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final int price;
  final String period;
  final String? badge;
  final List<String> features;
  final bool highlighted;
  final String buttonLabel;
  final bool enabled;
  final VoidCallback onPressed;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.period,
    this.badge,
    required this.features,
    required this.highlighted,
    required this.buttonLabel,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: highlighted
            ? BorderSide(color: color.primary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (badge != null)
                  Chip(
                    label: Text(badge!),
                    backgroundColor: color.primary,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${AppPrices.currencySymbol}${toBnDigits(price.toString())}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: color.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    period,
                    style: TextStyle(color: color.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: enabled ? onPressed : null,
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
