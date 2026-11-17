// Demo-mode content generators.
//
// These are template-based generators used while no live AI backend is
// connected. They are clearly labelled as demo output in the UI.
// A real AI service can replace this file later without changing the UI.

class StoryScene {
final String title;
final String imagePrompt;
final String voiceover;
final String sfx;

const StoryScene({
required this.title,
required this.imagePrompt,
required this.voiceover,
required this.sfx,
});
}

class SocialPack {
final String caption;
final String title;
final String description;
final String hashtags;
final List<String> ideas;

const SocialPack({
required this.caption,
required this.title,
required this.description,
required this.hashtags,
required this.ideas,
});
}

class DemoGenerator {
static const scriptTypes = [
'ইউটিউব ভিডিও',
'ফেসবুক রিল',
'নাটক / শর্ট ফিল্ম',
'বিজ্ঞাপন',
'সংবাদ প্রতিবেদন',
];
static const tones = [
'বন্ধুসুলভ',
'তথ্যভিত্তিক',
'মজার',
'আবেগি',
'পেশাদার',
];
static const durations = [
'৩০ সেকেন্ড',
'১ মিনিট',
'৩ মিনিট',
'৫ মিনিট',
'১০ মিনিট',
];
static const audiences = [
'শিশু',
'তরুণ',
'সাধারণ দর্শক',
'ব্যবসায়ী',
'গ্রামীণ দর্শক',
];
static const platforms = ['ফেসবুক', 'ইউটিউব', 'ইনস্টাগ্রাম', 'টিকটক'];

static const _hooks = {
'বন্ধুসুলভ': 'বন্ধুরা, আজকের গল্পটা শুনলে মন ভালো হয়ে যাবে!',
'তথ্যভিত্তিক': 'আজ আমরা জানব এমন কিছু তথ্য, যা আপনার কাজে আসবে।',
'মজার': 'হাসতে হাসতে পেটে খিল ধরে যাবে — কথা দিলাম!',
'আবেগি': 'এই গল্পটা শুনে আপনার চোখে পানি চলে আসতে পারে।',
'পেশাদার': 'আজকের আলোচনায় আমরা বিষয়টি গভীরভাবে বিশ্লেষণ করব।',
};

static String script({
required String topic,
required String type,
required String tone,
required String duration,
required String audience,
}) {
final hook = _hooks[tone]?? _hooks['বন্ধুসুলভ']!;
return '''$type স্ক্রিপ্ট: $topic
সময়কাল: $duration | দর্শক: $audience | টোন: $tone

হুক — প্রথম ৫ সেকেন্ড:
$hook "$topic" নিয়ে আজকের ভিডিওতে এমন কিছু জানবেন, যা আপনি আগে কখনো শোনেননি!

ভূমিকা:
আসসালামু আলাইকুম, প্রিয় দর্শক। আজ আমরা কথা বলব "$topic" নিয়ে। যারা $audience, তাদের জন্য এই ভিডিওটি বিশেষভাবে তৈরি।

মূল অংশ:
১. "$topic"-এর পেছনের গল্প — কীভাবে এর শুরু হলো এবং কেন এটি গুরুত্বপূর্ণ।
২. বাস্তব উদাহরণ — দৈনন্দিন জীবনে এর প্রভাব এবং মানুষের অভিজ্ঞতা।
৩. করণীয় — আপনি আজ থেকেই যা করতে পারেন, সহজ তিনটি ধাপে।

উপসংহার ও কল-টু-অ্যাকশন:
আশা করি ভিডিওটি ভালো লেগেছে। ভালো লাগলে লাইক করুন, বন্ধুদের সঙ্গে শেয়ার করুন এবং চ্যানেলটি সাবস্ক্রাইব করতে ভুলবেন না। পরের ভিডিওতে আবার দেখা হবে — আল্লাহ হাফেজ!''';
}

static List<StoryScene> story({
required String idea,
required String character,
required String moral,
}) {
return [
StoryScene(
title: 'দৃশ্য ১: গল্পের শুরু',
imagePrompt:
'High-quality 3D animated children\'s movie scene, $character in a colorful Bangladeshi village at sunrise, expressive face, detailed environment, cinematic lighting, vibrant colors, 16:9 widescreen',
voiceover:
'এক ছিল $character। $idea নিয়ে তার দিনটি শুরু হলো এক নতুন সকালে।',
sfx: 'পাখির ডাক, হালকা বাঁশির সুর',
),
StoryScene(
title: 'দৃশ্য ২: সমস্যা দেখা দেয়',
imagePrompt:
'High-quality 3D animated children\'s movie scene, $character looking worried as dark clouds gather over the village, dramatic lighting, expressive face, vibrant colors, 16:9 widescreen',
voiceover:
'হঠাৎ করেই সবকিছু বদলে গেল। $character বুঝতে পারল, সামনে একটা বড় চ্যালেঞ্জ অপেক্ষা করছে।',
sfx: 'বজ্রপাতের শব্দ, বাতাসের শোঁ শোঁ আওয়াজ',
),
StoryScene(
title: 'দৃশ্য ৩: বন্ধুর সাহায্য',
imagePrompt:
'High-quality 3D animated children\'s movie scene, $character and friends working together, teamwork, warm golden light, joyful expressions, detailed environment, 16:9 widescreen',
voiceover:
'বন্ধুরা এগিয়ে এলো। সবাই মিলে চেষ্টা করলে কোনো সমস্যাই বড় নয় — $character এই সত্যটা বুঝল।',
sfx: 'আনন্দের সুর, বন্ধুদের হাসি',
),
StoryScene(
title: 'দৃশ্য ৪: সমাধান',
imagePrompt:
'High-quality 3D animated children\'s movie scene, $character celebrating success, rainbow in the sky, colorful village festival, cinematic lighting, vibrant colors, 16:9 widescreen',
voiceover:
'অবশেষে সব ঠিক হয়ে গেল! $idea সফল হলো, আর পুরো গ্রামে ছড়িয়ে পড়ল আনন্দ।',
sfx: 'উৎসবের ঢাক, শিশুদের উল্লাস',
),
StoryScene(
title: 'দৃশ্য ৫: শিক্ষা',
imagePrompt:
'High-quality 3D animated children\'s movie scene, $character smiling at sunset with friends, peaceful warm light, gentle closing shot, children\'s movie style, 16:9 widescreen',
voiceover: 'এই গল্প থেকে আমরা শিখলাম: $moral।',
sfx: 'নরম পিয়ানোর সুর, শান্ত পরিবেশ',
),
];
}

static SocialPack social({
required String topic,
required String platform,
}) {
return SocialPack(
caption: '''$topic নিয়ে আজকের পোস্ট!

আপনার মতামত কমেন্টে জানান — আপনার একটি মন্তব্য আমাদের অনুপ্রাণিত করে। পোস্টটি ভালো লাগলে শেয়ার করুন!''',
title: '$topic — যা আপনার জানা দরকার!',
description:
'''এই ভিডিও/পোস্টে আমরা "$topic" নিয়ে বিস্তারিত আলোচনা করেছি।

মূল বিষয়গুলো:
• "$topic"-এর গুরুত্ব
• বাস্তব উদাহরণ
• আপনার জন্য করণীয়

আরও এমন কনটেন্ট পেতে আমাদের $platform পেজটি ফলো করুন।''',
hashtags:
'#বাংলাদেশ #BanglaCreator #$platform #বাংলা_কনটেন্ট #ভাইরাল #নতুন_ভিডিও',
ideas: [
'$topic নিয়ে ৩০ সেকেন্ডের রিল বানান — হুক দিয়ে শুরু করুন।',
'দর্শকদের প্রশ্ন করুন: "$topic" সম্পর্কে আপনার অভিজ্ঞতা কী?',
'আগে-পরের তুলনা দিয়ে একটি ক্যারোসেল পোস্ট তৈরি করুন।',
],
);
}
}
