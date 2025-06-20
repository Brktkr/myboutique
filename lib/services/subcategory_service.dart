import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoryService {
  final _subCatRef = FirebaseFirestore.instance.collection('subcategories');

  Stream<List<Map<String, dynamic>>> getSubCategories(String parentCatId) {
    return _subCatRef
      .where('parentCatId', isEqualTo: parentCatId)
      .snapshots()
      .map((snap) => snap.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList());
  }

  CollectionReference get subCatRef => _subCatRef;
}
