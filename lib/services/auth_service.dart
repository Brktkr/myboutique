import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<User?> login(String username, String password) async {
    final query = await _usersRef
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return User.fromMap(query.docs.first.data());
    }
    return null;
  }

  
Future<void> seedUsers() async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final now = DateTime.now().toIso8601String();

  final doc1 = await usersRef.add({
    'username': 'atoker',
    'password': '123456',
    'name': 'Azra',
    'surname': 'Toker',
    'createdBy': 'system',
    'updatedBy': 'system',
    'createdAt': now,
    'updatedAt': now,
    'isActive': true,
    'isDeleted': false,
  });
  await doc1.update({'id': doc1.id});

  final doc2 = await usersRef.add({
    'username': 'gkurtaraner',
    'password': '123456',
    'name': 'Gülçin',
    'surname': 'Kurtaraner',
    'createdBy': 'system',
    'updatedBy': 'system',
    'createdAt': now,
    'updatedAt': now,
    'isActive': true,
    'isDeleted': false,
  });
  await doc2.update({'id': doc2.id});
}
}
