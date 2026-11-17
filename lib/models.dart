import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Project {
final String id;
String title;
final String type; // স্ক্রিপ্ট, গল্প, সোশ্যাল, পোস্টার
String content;
DateTime updatedAt;

Project({
required this.id,
required this.title,
required this.type,
required this.content,
required this.updatedAt,
});

Map<String, dynamic> toJson() => {
'id': id,
'title': title,
'type': type,
'content': content,
'updatedAt': updatedAt.toIso8601String(),
};

factory Project.fromJson(Map<String, dynamic> j) => Project(
id: j['id'] as String,
title: j['title'] as String,
type: j['type'] as String,
content: j['content'] as String,
updatedAt: DateTime.parse(j['updatedAt'] as String),
);
}

class StorageService {
static late SharedPreferences _prefs;
static const _key = 'projects_v1';

static Future<void> init(SharedPreferences prefs) async {
_prefs = prefs;
if (!_prefs.containsKey(_key)) {
await _prefs.setString(
_key,
jsonEncode(_seed.map((e) => e.toJson()).toList()),
);
}
}

static List<Project> load() {
final raw = _prefs.getString(_key);
if (raw == null || raw.isEmpty) return [];
final list = (jsonDecode(raw) as List)
.map((e) => Project.fromJson(e as Map<String, dynamic>))
.toList();
list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
return list;
}

static Future<void> _save(List<Project> projects) async {
await _prefs.setString(
_key,
jsonEncode(projects.map((e) => e.toJson()).toList()),
);
}

static Future<void> add(Project p) async {
final list = load();
list.insert(0, p);
await _save(list);
}

static Future<void> update(Project p) async {
final list = load();
final i = list.indexWhere((e) => e.id == p.id);
if (i >= 0) list[i] = p;
await _save(list);
}

static Future<void> remove(String id) async {
final list = load()..removeWhere((e) => e.id == id);
await _save(list);
}

static String newId() => DateTime.now().millisecondsSinceEpoch.toString();

static List<Project> get _seed => [
Project(
id: 'seed-1',
title: 'গ্রামের সকাল — ভিডিও স্ক্রিপ্ট',
type: 'স্ক্রিপ্ট',
content: '''ইউটিউব ভিডিও স্ক্রিপ্ট: গ্রামের সকাল
সময়কাল: ৩ মিনিট | দর্শক: সাধারণ দর্শক | টোন: বন্ধুসুলভ

হুক — প্রথম ৫ সেকেন্ড:
বন্ধুরা, ভোরের আলোয় জেগে ওঠা গ্রামের সকালটা কেমন জানেন? আজকের ভিডিওতে সেই গল্পই বলব!

ভূমিকা:
আসসালামু আলাইকুম, প্রিয় দর্শক। আজ আমরা ঘুরে দেখব বাংলাদেশের একটি সুন্দর গ্রামের সকাল।

মূল অংশ:
১. ভোরের পাখির ডাক আর কুয়াশা ঢাকা মাঠ।
২. কৃষকের কাজ, জেলের নৌকা আর চায়ের দোকানের আড্ডা।
৩. গ্রামের মানুষের সহজ-সরল জীবনের গল্প।

উপসংহার:
ভালো লাগলে লাইক করুন, শেয়ার করুন আর চ্যানেলটি সাবস্ক্রাইব করুন।''',
updatedAt: DateTime.now().subtract(const Duration(days: 1)),
),
Project(
id: 'seed-2',
title: 'টমেটো আর আলুর বন্ধুত্ব — গল্প',
type: 'গল্প',
content: '''গল্প: টমেটো আর আলুর বন্ধুত্ব
চরিত্র: টমেটো ও আলু | শিক্ষা: বন্ধুত্ব ও সহযোগিতা

দৃশ্য ১: সবজি গ্রামে সকাল। টমেটো আর আলু মিলে সোনালি বীজ খুঁজে পায়।
দৃশ্য ২: ঝড় আসে, চারাগাছটি বিপদে পড়ে। দুই বন্ধু মিলে গাছটিকে বাঁচায়।
দৃশ্য ৩: গাছে সোনালি ফল ধরে, গ্রামে উৎসব হয়।

শিক্ষা: একতাই শক্তি, বন্ধুর বিপদে পাশে দাঁড়াতে হয়।''',
updatedAt: DateTime.now().subtract(const Duration(days: 2)),
),
Project(
id: 'seed-3',
title: 'শীতের পিঠা উৎসব — ফেসবুক পোস্ট',
type: 'সোশ্যাল',
content: '''ক্যাপশন:
শীত মানেই পিঠা! ভাপা পিঠা, চিতই পিঠা আর খেজুরের রস — আপনার প্রিয় পিঠা কোনটি? কমেন্টে জানান!

হ্যাশট্যাগ:
#শীতেরপিঠা #বাংলাদেশ #পিঠাউৎসব #BanglaFood #শীতকাল''',
updatedAt: DateTime.now().subtract(const Duration(days: 3)),
),
];
}
