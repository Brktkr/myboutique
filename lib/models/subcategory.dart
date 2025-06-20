import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class SubCategory extends BaseModel {
  final String parentCatId;
  final String name;
  final String desc;

  SubCategory({
    required super.id,
    required this.parentCatId,
    required this.name,
    required this.desc,
    super.createdAt,
    super.updatedAt,
    super.isActive,
    super.isDeleted,
  });

  factory SubCategory.fromMap(Map<String, dynamic> map, String id) {
    return SubCategory(
      id: id,
      parentCatId: map['parentCatId'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      createdAt:
          map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt:
          map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      isActive: map['isActive'] ?? true,
      isDeleted: map['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentCatId': parentCatId,
      'name': name,
      'desc': desc,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      'isDeleted': isDeleted,
    };
  }
}
