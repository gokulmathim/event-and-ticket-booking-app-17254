import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../src/providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'home/home_shell.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final isAuth = context.read<AuthProvider>().isAuthenticated;
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(isAuth ? HomeShell.routeName : LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
