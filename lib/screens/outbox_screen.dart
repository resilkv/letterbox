import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/letter_service.dart';
import '../widgets/letter_card.dart';

class OutboxScreen extends StatefulWidget {
  const OutboxScreen({super.key});

  @override
  State<OutboxScreen> createState() => _OutboxScreenState();
}

class _OutboxScreenState extends State<OutboxScreen> {
  late Future<List<dynamic>> _outboxFuture;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    final letterService = Provider.of<LetterService>(context, listen: false);

    if (auth.user != null) {
      _outboxFuture = letterService.fetchOutbox(auth.user!['id']);
    }
  }

  Future<void> _refresh() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final letterService = Provider.of<LetterService>(context, listen: false);

    if (auth.user != null) {
      final data = await letterService.fetchOutbox(auth.user!['id']);
      setState(() {
        _outboxFuture = Future.value(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    if (auth.user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'You are not logged in',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Outbox'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDA291C), Color(0xFFFFCC00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFDF6F0),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<dynamic>>(
          future: _outboxFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFDA291C)),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              );
            }

            final letters = snapshot.data ?? [];

            if (letters.isEmpty) {
              return const Center(
                child: Text(
                  'No letters in your outbox 📤',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: letters.length,
              itemBuilder: (context, i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: LetterCard(letter: letters[i]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
