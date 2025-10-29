import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/letter.dart';


class LetterService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Stream<List<Letter>> streamInbox(String userId) {
    return _db
      .collection('letters')
      .where('receiverId', isEqualTo: userId)
      .orderBy('sentAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => Letter.fromJson(d.data())).toList());
      }


      Stream<List<Letter>> streamOutbox(String userId) {
      return _db
      .collection('letters')
      .where('senderId', isEqualTo: userId)
      .orderBy('sentAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => Letter.fromJson(d.data())).toList());
      }


    Future<void> sendLetter(Letter letter) async {
    final doc = _db.collection('letters').doc(letter.id);
    await doc.set(letter.toJson());


  // Simulate delivery delay by updating status after a short period.
  // In production, use Cloud Functions or scheduled jobs to update delivery.
  Future.delayed(const Duration(seconds: 5), () async {
  await doc.update({'status': 'delivered', 'deliveredAt': DateTime.now().toIso8601String()});
  });
  }
}
