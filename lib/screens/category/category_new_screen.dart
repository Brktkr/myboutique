import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../viewmodels/category_viewmodel.dart';

class CategoryNewScreen extends StatefulWidget {
  const CategoryNewScreen({super.key});

  @override
  State<CategoryNewScreen> createState() => _CategoryNewScreenState();
}

class _CategoryNewScreenState extends State<CategoryNewScreen> {
  final CategoryViewModel _viewModel = CategoryViewModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isActive = true;
  List<Map<String, dynamic>> _subs = [];
  List<TextEditingController> _subNameControllers = [];
  List<TextEditingController> _subDescControllers = [];
  List<bool> _subActive = [];

  void _addSub() {
    setState(() {
      _subs.add({'name': '', 'desc': '', 'isActive': true});
      _subNameControllers.add(TextEditingController());
      _subDescControllers.add(TextEditingController());
      _subActive.add(true);
    });
  }

  void _removeSub(int i) {
    setState(() {
      _subs.removeAt(i);
      _subNameControllers[i].dispose();
      _subDescControllers[i].dispose();
      _subNameControllers.removeAt(i);
      _subDescControllers.removeAt(i);
      _subActive.removeAt(i);
    });
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

  Future<void> _save() async {
    final userId = Provider.of<UserProvider>(context, listen: false).user?.id ?? '';
    // Kategori ekle
    final catId = await _viewModel.categoryService.catRef.add({
      'name': _nameController.text,
      'description': _descController.text,
      'isActive': _isActive,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'createdBy': userId,
      'updatedBy': userId,
      'isDeleted': false,
    });
    // Alt kategorileri ekle
    for (int i = 0; i < _subs.length; i++) {
      await _viewModel.subCategoryService.subCatRef.add({
        'parentCatId': catId.id,
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
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Kategori Oluştur')),
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
