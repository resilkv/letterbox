import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/letter_service.dart';
import '../widgets/letter_card.dart';

class OutboxScreen extends StatelessWidget {
  const OutboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final letterService = Provider.of<LetterService>(context);

    if (auth.user == null) {
      return const Center(
        child: Text('Not logged in'),
      );
    }

    return StreamBuilder(
      stream: letterService.streamOutbox(auth.user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No letters yet'));
        }

        final letters = snapshot.data as List;

        if (letters.isEmpty) {
          return const Center(child: Text('No letters'));
        }

        return ListView.builder(
          itemCount: letters.length,
          itemBuilder: (context, i) => LetterCard(letter: letters[i]),
        );
      },
    );
  }
}
