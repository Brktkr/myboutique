import 'package:flutter/material.dart';
import '../../screens/category/category_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final Color background = const Color(0xFFF6F6F2);
    final Color tileBlue = const Color(0xFF6CA0DC); // pastel mavi
    final Color tileTurquoise = const Color(0xFFB2DFDB); // pastel turkuaz
    final Color tileRed = const Color(0xFFFFB4A2); // pastel kırmızı
    final Color tileDark = const Color(0xFF8D99AE); // pastel koyu


    final List<_MenuItem> menuItems = [
      _MenuItem(icon: Icons.category, label: 'Kategoriler', color: tileBlue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryMenuScreen()))),
      _MenuItem(icon: Icons.shopping_bag, label: 'Ürünler', color: tileTurquoise, onTap: () {}),
      _MenuItem(icon: Icons.point_of_sale, label: 'Satışlar', color: tileRed, onTap: () {}),
      _MenuItem(icon: Icons.people, label: 'Müşteriler', color: tileDark, onTap: () {}),
      _MenuItem(icon: Icons.bar_chart, label: 'Raporlar', color: tileBlue, onTap: () {}),
      _MenuItem(icon: Icons.settings, label: 'Ayarlar', color: tileTurquoise, onTap: () {}),
    ];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: tileBlue,
        title: const Text('Ana Menü', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: menuItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                  child: _MenuTile(item: item),
                )).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  _MenuItem({required this.icon, required this.label, required this.color, required this.onTap});
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap,
        child: Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: item.color, width: 2.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 18),
              Icon(item.icon, size: 28, color: item.color),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: item.color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
