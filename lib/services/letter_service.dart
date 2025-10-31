import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LetterService extends ChangeNotifier {
  // 🟡 Change this to your actual Django backend base URL
  final String baseUrl = 'https://your-backend-domain.com/api/letters/';

  /// Fetch letters received by the user (Inbox)
  Future<List<dynamic>> fetchInbox(String userId) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}inbox/?user_id=$userId'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] ?? [];
      } else {
        throw Exception('Failed to load inbox: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching inbox: $e');
      rethrow;
    }
  }

  /// Fetch letters sent by the user (Outbox)
  Future<List<dynamic>> fetchOutbox(String userId) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}outbox/?user_id=$userId'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] ?? [];
      } else {
        throw Exception('Failed to load outbox: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching outbox: $e');
      rethrow;
    }
  }

  /// Optional: send a new letter
  Future<void> sendLetter(Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}send/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to send letter: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending letter: $e');
      rethrow;
    }
  }
}
