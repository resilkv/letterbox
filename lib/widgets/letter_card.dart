import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/letter.dart';
import 'envelope_animation.dart';

class LetterCard extends StatelessWidget {
  final Letter letter;

  const LetterCard({
    super.key,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.mail_outline),
        title: Text(letter.senderName),
        subtitle: Text(
          letter.message.length > 120
              ? '${letter.message.substring(0, 120)}...'
              : letter.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateFormat('dd MMM').format(letter.sentAt)),
            const SizedBox(height: 4),
            Text(letter.status),
          ],
        ),
        onTap: () => showDialog(
          context: context,
          builder: (_) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EnvelopeAnimation(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From: ${letter.senderName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(letter.message),
                        const SizedBox(height: 12),
                        Text(
                          'Sent: ${DateFormat('dd MMM yyyy HH:mm').format(letter.sentAt)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
