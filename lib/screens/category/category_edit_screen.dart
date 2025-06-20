import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../viewmodels/category_viewmodel.dart';

class CategoryEditScreen extends StatefulWidget {
  final Map<String, dynamic> category;
  final List<Map<String, dynamic>> subCategories;
  const CategoryEditScreen({super.key, required this.category, required this.subCategories});

  @override
  State<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  final CategoryViewModel _viewModel = CategoryViewModel();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  bool _isActive = true;
  List<Map<String, dynamic>> _subs = [];
  List<TextEditingController> _subNameControllers = [];
  List<TextEditingController> _subDescControllers = [];
  List<bool> _subActive = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category['name'] ?? '');
    _descController = TextEditingController(text: widget.category['description'] ?? '');
    _isActive = widget.category['isActive'] ?? true;
    _subs = widget.subCategories.map((sub) => Map<String, dynamic>.from(sub)).toList();
    _subNameControllers = _subs.map((sub) => TextEditingController(text: sub['name'] ?? '')).toList();
    _subDescControllers = _subs.map((sub) => TextEditingController(text: sub['desc'] ?? '')).toList();
    _subActive = _subs.map((sub) => (sub['isActive'] ?? true) as bool).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    for (final c in _subNameControllers) {
      c.dispose();
    }
    for (final c in _subDescControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addSub() {
    setState(() {
      _subs.add({'name': '', 'desc': '', 'isActive': true});
      _subNameControllers.add(TextEditingController());
      _subDescControllers.add(TextEditingController());
      _subActive.add(true);
    });
  }

  void _removeSub(int i) async {
    final sub = _subs[i];
    if (sub['id'] != null) {
      await _viewModel.deleteSubCategory(sub['id']);
    }
    setState(() {
      _subs.removeAt(i);
      _subNameControllers[i].dispose();
      _subDescControllers[i].dispose();
      _subNameControllers.removeAt(i);
      _subDescControllers.removeAt(i);
      _subActive.removeAt(i);
    });
  }

  Future<void> _save() async {
    final userId = Provider.of<UserProvider>(context, listen: false).user?.id ?? '';
    await _viewModel.updateCategory(widget.category['id'], {
      'name': _nameController.text,
      'description': _descController.text,
      'isActive': _isActive,
      'updatedBy': userId,
      'updatedAt': DateTime.now(),
    });
    for (int i = 0; i < _subs.length; i++) {
      final sub = _subs[i];
      if (sub['id'] != null && sub['id'].toString().isNotEmpty) {
        await _viewModel.updateSubCategory(sub['id'], {
          'name': _subNameControllers[i].text,
          'desc': _subDescControllers[i].text,
          'isActive': _subActive[i],
          'updatedBy': userId,
          'updatedAt': DateTime.now(),
        });
      } else {
        await _viewModel.subCategoryService.subCatRef.add({
          'parentCatId': widget.category['id'],
          'name': _subNameControllers[i].text,
          'desc': _subDescControllers[i].text,
          'isActive': _subActive[i],
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'createdBy': userId,
          'updatedBy': userId,
          'isDeleted': false,
        });
      }
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Düzenle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ana Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Kategori Adı', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(labelText: 'Açıklama', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Switch(
                          value: _isActive,
                          activeColor: Colors.deepPurple,
                          onChanged: (val) => setState(() => _isActive = val),
                        ),
                        const Text('Aktif', style: TextStyle(color: Colors.deepPurple)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alt Kategoriler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
                  onPressed: _addSub,
                  tooltip: 'Alt Kategori Ekle',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_subs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Alt kategori eklemeden de kaydedebilirsiniz.', style: TextStyle(color: Colors.black54)),
              ),
            ..._subs.asMap().entries.map((entry) {
              final i = entry.key;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                color: Colors.blueGrey.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _subNameControllers[i],
                        decoration: const InputDecoration(labelText: 'Alt Kategori Adı', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _subDescControllers[i],
                        decoration: const InputDecoration(labelText: 'Açıklama', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Switch(
                            value: _subActive[i],
                            activeColor: Colors.teal,
                            onChanged: (val) => setState(() => _subActive[i] = val),
                          ),
                          const Text('Aktif', style: TextStyle(color: Colors.teal)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeSub(i),
                            tooltip: 'Alt Kategoriyi Sil',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Kaydet', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
