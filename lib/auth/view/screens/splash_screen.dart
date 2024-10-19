import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../widgets/logo_show.dart';
import '../../../home/screens/main_dashboard_screen.dart';

import '../../../main.dart';

/// Initial loading route of the app.
///
/// Used to load required information before starting the app (auth).
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkUserSession();
    });
  }

  void _checkUserSession() async{
    await Future.delayed(const Duration(seconds: 1));
    final session = supabase.auth.currentSession;
    if (session == null) {
      if(!mounted)return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    } else {
      if(!mounted)return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoShow(),
            ],
          ),
        ),
      ),
    );
  }
}
