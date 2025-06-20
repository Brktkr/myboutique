import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final _catRef = FirebaseFirestore.instance.collection('categories');

  CollectionReference get catRef => _catRef;

  Future<String> addCategory(String name, String description, String createdBy) async {
    final doc = await _catRef.add({
      'name': name,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'updatedBy': createdBy,
      'isActive': true,
      'isDeleted': false,
    });
    return doc.id;
  }

  Future<void> updateCategory(String id, String name, String description, String updatedBy) async {
    await _catRef.doc(id).update({
      'name': name,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  Future<void> deleteCategory(String id) async {
    await _catRef.doc(id).update({'isDeleted': true, 'isActive': false, 'updatedAt': FieldValue.serverTimestamp()});
  }

  Stream<List<Map<String, dynamic>>> getCategories() {
    return _catRef.snapshots().map((snap) =>
      snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList()
    );
  }

  // Artık subcategory içermiyor, sadece entity döner
  Stream<List<Map<String, dynamic>>> getSubCategories(String parentCatId) {
    return FirebaseFirestore.instance
      .collection('subcategories')
      .where('parentCatId', isEqualTo: parentCatId)
      .snapshots()
      .map((snap) => snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList());
  }
}
