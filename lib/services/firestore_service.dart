// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // إرسال جهة اتصال جديدة
  Future<void> addTrustedContact(String name, String phone) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await _db
          .collection('users')
          .doc(user.uid)
          .collection('trusted_contacts')
          .add({
        'name': name,
        'phone': phone,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding contact: $e");
    }
  }

  // جلب جهات الاتصال
  Stream<QuerySnapshot> getTrustedContacts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('trusted_contacts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // حذف جهة اتصال
  Future<void> deleteContact(String id) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await _db
          .collection('users')
          .doc(user.uid)
          .collection('trusted_contacts')
          .doc(id)
          .delete();
    } catch (e) {
      print("Error deleting contact: $e");
    }
  }

  // حفظ رسالة في الشات
  Future<void> saveChatMessage(String text, int senderIndex) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await _db
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .add({
        'text': text,
        'sender': senderIndex,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving message: $e");
    }
  }

  // جلب رسائل الشات
  Stream<QuerySnapshot> getChatMessages() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> clearChatMessages() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final querySnapshot = await _db
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .get();

      final batch = _db.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print("Error clearing chat messages: $e");
    }
  }
}
