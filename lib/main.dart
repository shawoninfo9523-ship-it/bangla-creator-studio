import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'theme.dart';
import 'screens/splash_onboarding.dart';
import 'screens/home.dart';
import 'screens/script_writer.dart';
import 'screens/poster_studio.dart';
import 'screens/story_studio.dart';
import 'screens/social.dart';
import 'screens/projects.dart';
import 'screens/subscription.dart';
import 'screens/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await StorageService.init(prefs);
  runApp(BanglaCreatorApp(prefs: prefs));
}

class BanglaCreatorApp extends StatefulWidget {
  final SharedPreferences prefs;

  const BanglaCreatorApp({super.key, required this.prefs});

  @override
  State<BanglaCreatorApp> createState() => _BanglaCreatorAppState();
}

class _BanglaCreatorAppState extends State<BanglaCreatorApp> {
  ThemeMode _mode = ThemeMode.system;
  bool _showSplash = true;
  bool _onboarded = false;

  @override
  void initState() {
    super.initState();
    final saved = widget.prefs.getInt('theme_mode') ?? 0;
    _mode = ThemeMode.values[saved.clamp(0, ThemeMode.values.length - 1)];
    _onboarded = widget.prefs.getBool('onboarded') ?? false;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  void _setTheme(ThemeMode m) {
    setState(() => _mode = m);
    widget.prefs.setInt('theme_mode', m.index);
  }

  void _finishOnboarding() {
    widget.prefs.setBool('onboarded', true);
    setState(() => _onboarded = true);
  }

  @override
  Widget build(BuildContext context) {
    final Widget home;
    if (_showSplash) {
      home = const SplashScreen();
    } else if (!_onboarded) {
      home = OnboardingScreen(onDone: _finishOnboarding);
    } else {
      home = const HomeShell();
    }
    return MaterialApp(
      title: 'Bangla Creator Studio AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _mode,
      home: home,
      routes: {
        '/script': (_) => const ScriptWriterScreen(),
        '/poster': (_) => const PosterStudioScreen(),
        '/story': (_) => const StoryStudioScreen(),
        '/social': (_) => const SocialAssistantScreen(),
        '/projects': (_) => const ProjectsScreen(),
        '/subscription': (_) => const SubscriptionScreen(),
        '/settings': (_) =>
            SettingsScreen(mode: _mode, onThemeChanged: _setTheme),
      },
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(onNavigateTab: (i) => setState(() => _index = i)),
      const ScriptWriterScreen(),
      const PosterStudioScreen(),
      const StoryStudioScreen(),
      const ProjectsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'হোম',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'স্ক্রিপ্ট',
          ),
          NavigationDestination(
            icon: Icon(Icons.image_outlined),
            selectedIcon: Icon(Icons.image),
            label: 'পোস্টার',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'গল্প',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'প্রজেক্ট',
          ),
        ],
      ),
    );
  }
}
