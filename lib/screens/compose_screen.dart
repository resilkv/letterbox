import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../services/auth_service.dart';
import '../services/letter_service.dart';
import '../models/letter.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final _to = TextEditingController();
  final _message = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final letterService = Provider.of<LetterService>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _to,
            decoration: const InputDecoration(labelText: 'Recipient Email'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _message,
              decoration: const InputDecoration(labelText: 'Write your letter...'),
              maxLines: null,
              expands: true,
            ),
          ),
          if (_error != null)
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loading
                ? null
                : () async {
                    setState(() {
                      _loading = true;
                      _error = null;
                    });

                    final sender = auth.user;
                    if (sender == null) {
                      setState(() {
                        _error = 'You must be logged in';
                        _loading = false;
                      });
                      return;
                    }

                    try {
                      final id = const Uuid().v4();
                      final l = Letter(
                        id: id,
                        senderId: sender.uid,
                        senderName: sender.email ?? '',
                        receiverId: _to.text.trim(), // demo: using receiver email as ID
                        receiverName: _to.text.trim(),
                        message: _message.text.trim(),
                        sentAt: DateTime.now(),
                        status: 'sent',
                      );

                      await letterService.sendLetter(l);

                      _message.clear();
                      _to.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Letter sent successfully!')),
                      );
                    } catch (e) {
                      setState(() => _error = 'Failed to send letter: $e');
                    } finally {
                      setState(() => _loading = false);
                    }
                  },
            child: _loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Send Letter'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _to.dispose();
    _message.dispose();
    super.dispose();
  }
}
