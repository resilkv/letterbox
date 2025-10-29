import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
  }
  class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () async {
    final auth = Provider.of<AuthService>(context, listen: false);
    if (auth.isAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Center(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      Icon(Icons.mark_email_unread, size: 80, color: Color(0xFFDA291C)),
      SizedBox(height: 12),
      Text('LetterBox', style: TextStyle(fontSize: 28, color: Color(0xFFDA291C))),
      ],
      ),
    ),
  );
  }
}
