import 'dart:async';

import 'package:flutter/material.dart';

import '../../../onboarding/presentation/pages/onboarding_gate.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _handoffTimer;
  var _isComplete = false;

  @override
  void initState() {
    super.initState();
    _handoffTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isComplete = true);
      }
    });
  }

  @override
  void dispose() {
    _handoffTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      return const OnboardingGate();
    }

    return Scaffold(
      body: Center(
        child: Semantics(
          label: 'Logo Serenity',
          image: true,
          child: Image(
            image: AssetImage('assets/images/serenity_logo.png'),
            width: 160,
            height: 160,
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}
