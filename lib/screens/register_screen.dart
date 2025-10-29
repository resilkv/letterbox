
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
  }


  class _RegisterScreenState extends State<RegisterScreen> {
    final _email = TextEditingController();
    final _password = TextEditingController();
    final _username = TextEditingController();
    bool _loading = false;
    String? _error;


    @override
    Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
    appBar: AppBar(title: const Text('Register')),
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username')),
    TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
    TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
    const SizedBox(height: 12),
    if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
      ElevatedButton(
      onPressed: _loading
      ? null
      : () async {
      setState(() => _loading = true);
    final res = await auth.signUp(_email.text.trim(), _password.text.trim());
    setState(() => _loading = false);
    if (res != null && res.length > 20) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
      setState(() => _error = res);
      }
    },
    child: _loading ? const CircularProgressIndicator() : const Text('Register'),
      ),
      ],
      ),
    ),
  );
  }
}
