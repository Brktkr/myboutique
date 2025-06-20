import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';
import 'subcategory.dart';

class Category extends BaseModel {
  final String name;
  final String description;
  final List<SubCategory> subCategories;

  Category({
    required super.id,
    required this.name,
    required this.description,
    this.subCategories = const [],
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    super.isActive,
    super.isDeleted,
  });

  factory Category.fromMap(Map<String, dynamic> map, String id, {List<SubCategory> subCategories = const []}) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      subCategories: subCategories,
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      isActive: map['isActive'] ?? true,
      isDeleted: map['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      'isDeleted': isDeleted,
      // subCategories Firestore'da ayrı koleksiyon olduğu için burada tutulmaz
    };
  }
}
