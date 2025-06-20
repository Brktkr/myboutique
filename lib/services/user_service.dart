import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final _userRef = FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final doc = await _userRef.doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    data['id'] = doc.id;
    return data;
  }
}
