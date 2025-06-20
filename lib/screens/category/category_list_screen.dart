import 'package:flutter/material.dart';
import 'package:myboutique/services/user_service.dart';
import '../../viewmodels/category_viewmodel.dart';
import 'category_edit_screen.dart';

class CategoryListScreen extends StatefulWidget {
  CategoryListScreen({super.key});
  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final CategoryViewModel _viewModel = CategoryViewModel();
  final UserService _userService = UserService();
  Map<String, String> _userNames = {};

  Future<String> _getUserName(String? userId) async {
    if (userId == null || userId.isEmpty) return '-';
    if (_userNames.containsKey(userId)) return _userNames[userId]!;
    final user = await _userService.getUserById(userId);
    final name = user != null ? (user['name'] ?? '') + ' ' + (user['surname'] ?? '') : '-';
    _userNames[userId] = name;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategoriler ve Alt Kategoriler')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _viewModel.getCategoryGridViewModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
            return const Center(child: Text('Kategori bilgisi bulunamadı.'));
          }
          final items = snapshot.data!;
          final categories = items.where((e) => e['parentCatId'] == null).toList();
          final subCategories = items.where((e) => e['parentCatId'] != null).toList();
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final cat = categories[i];
              final catSubs = subCategories.where((s) => s['parentCatId'] == cat['id']).toList();
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(cat['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          if ((cat['description'] ?? '').toString().isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text('(${cat['description']})', style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black54)),
                          ],
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.deepPurple),
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CategoryEditScreen(
                                    category: cat,
                                    subCategories: catSubs,
                                  ),
                                ),
                              );
                              if (result == true) setState(() {});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Silmek istediğinize emin misiniz?'),
                                  content: const Text('Bu kategori ve alt kategorileri kalıcı olarak silinecek.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Vazgeç')),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sil', style: TextStyle(color: Colors.red))),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _viewModel.deleteCategoryAndSubs(cat['id']);
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                      if (catSubs.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...catSubs.map((sub) => FutureBuilder<String>(
                              future: _getUserName(sub['createdBy']),
                              builder: (context, userSnap) {
                                dynamic createdAtRaw = sub['createdAt'];
                                DateTime? createdAt;
                                if (createdAtRaw is String) {
                                  createdAt = DateTime.tryParse(createdAtRaw);
                                } else if (createdAtRaw is DateTime) {
                                  createdAt = createdAtRaw;
                                } else if (createdAtRaw != null && createdAtRaw.toString().contains('Timestamp')) {
                                  try {
                                    createdAt = createdAtRaw.toDate();
                                  } catch (_) {
                                    createdAt = null;
                                  }
                                }
                                final formattedDate = createdAt != null
                                    ? '${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}'
                                    : '-';
                                return Container(
                                  margin: const EdgeInsets.only(left: 8, bottom: 6),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sub['name'] != null && (sub['desc'] ?? '').toString().trim().isNotEmpty
                                            ? '${sub['name']} (${sub['desc']})'
                                            : (sub['name'] ?? ''),
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.blueGrey),
                                      ),
                                      Row(
                                        children: [
                                          const Text('Oluşturma tarihi: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                                          Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text('Oluşturan: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                                          Text(userSnap.data ?? '-', style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.teal)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text('Durum: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                                          sub['isActive'] == true
                                              ? const Icon(Icons.check_circle, color: Colors.green, size: 16)
                                              : const Icon(Icons.cancel, color: Colors.red, size: 16),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ))
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
