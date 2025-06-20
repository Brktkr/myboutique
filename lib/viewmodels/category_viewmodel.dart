import '../services/category_service.dart';
import '../services/subcategory_service.dart';

class CategoryViewModel {
  final CategoryService _categoryService = CategoryService();
  final SubCategoryService _subCategoryService = SubCategoryService();

  Stream<List<Map<String, dynamic>>> getCategories() {
    return _categoryService.getCategories();
  }

  Stream<List<Map<String, dynamic>>> getSubCategories(String parentCatId) {
    return _categoryService.getSubCategories(parentCatId);
  }

  Future<List<Map<String, dynamic>>> getCategoryGridViewModel() async {
    final catSnap = await _categoryService.catRef.get();
    final subSnap = await _subCategoryService.subCatRef.get();
    final categories = catSnap.docs.map((doc) {
      final raw = doc.data();
      if (raw is! Map<String, dynamic>) return <String, dynamic>{};
      final data = Map<String, dynamic>.from(raw);
      data['id'] = doc.id;
      return data;
    }).where((e) => e.isNotEmpty).toList();
    final subCategories = subSnap.docs.map((doc) {
      final raw = doc.data();
      if (raw is! Map<String, dynamic>) return <String, dynamic>{};
      final data = Map<String, dynamic>.from(raw);
      data['id'] = doc.id;
      return data;
    }).where((e) => e.isNotEmpty).toList();
    return [...categories, ...subCategories];
  }

  Future<void> deleteCategoryAndSubs(String categoryId) async {
    // Kategoriyi sil
    await _categoryService.catRef.doc(categoryId).delete();
    // Bağlı alt kategorileri sil
    final subSnap = await _subCategoryService.subCatRef.where('parentCatId', isEqualTo: categoryId).get();
    for (final doc in subSnap.docs) {
      await _subCategoryService.subCatRef.doc(doc.id).delete();
    }
  }

  Future<void> updateCategory(String categoryId, Map<String, dynamic> data) async {
    await _categoryService.catRef.doc(categoryId).update(data);
  }

  Future<void> updateSubCategory(String subCategoryId, Map<String, dynamic> data) async {
    await _subCategoryService.subCatRef.doc(subCategoryId).update(data);
  }

  Future<void> deleteSubCategory(String subCategoryId) async {
    await _subCategoryService.subCatRef.doc(subCategoryId).delete();
  }

  CategoryService get categoryService => _categoryService;
  SubCategoryService get subCategoryService => _subCategoryService;
}
