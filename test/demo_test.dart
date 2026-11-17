import 'package:bangla_creator_studio/demo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('script generator includes topic, type and sections', () {
    final result = DemoGenerator.script(
      topic: 'গ্রামের সকাল',
      type: 'ইউটিউব ভিডিও',
      tone: 'বন্ধুসুলভ',
      duration: '৩ মিনিট',
      audience: 'সাধারণ দর্শক',
    );
    expect(result, contains('গ্রামের সকাল'));
    expect(result, contains('ইউটিউব ভিডিও'));
    expect(result, contains('হুক'));
    expect(result, contains('উপসংহার'));
  });

  test('story generator returns five scenes with prompts', () {
    final scenes = DemoGenerator.story(
      idea: 'সোনালি বীজ',
      character: 'টমেটো',
      moral: 'একতাই শক্তি',
    );
    expect(scenes.length, 5);
    expect(scenes.first.imagePrompt, isNotEmpty);
    expect(scenes.first.voiceover, contains('টমেটো'));
    expect(scenes.last.voiceover, contains('একতাই শক্তি'));
  });

  test('social generator returns caption, hashtags and ideas', () {
    final pack = DemoGenerator.social(topic: 'শীতের পিঠা', platform: 'ফেসবুক');
    expect(pack.caption, contains('শীতের পিঠা'));
    expect(pack.hashtags, contains('#'));
    expect(pack.ideas.length, 3);
  });
}
