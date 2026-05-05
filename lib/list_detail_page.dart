import 'package:flutter/material.dart';

class ListDetailPage extends StatefulWidget {
  final String listName;
  final IconData selectedIcon;
  final Color selectedColor;

  const ListDetailPage({
    super.key,
    required this.listName,
    required this.selectedIcon,
    required this.selectedColor,
  });

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  final List<String> _items = [];
  final TextEditingController _itemController = TextEditingController();

  final Color primaryColor = const Color(0xFF136E80);
  final Color backgroundColor = const Color(0xFFF7F9FB);
  final Color textColor = const Color(0xFF1F3A4B);

  void _addItem() {
    if (_itemController.text.trim().isNotEmpty) {
      setState(() {
        _items.add(_itemController.text.trim());
        _itemController.clear();
      });
    }
  }

  // --- YENİLENEN SİLME FONKSİYONU ---
  void _removeItem(int index) {
    // 1. Silinen öğeyi ve indeksini hafızaya alıyoruz
    final deletedItem = _items[index];
    final deletedIndex = index;

    // 2. Öğeyi listeden siliyoruz
    setState(() {
      _items.removeAt(index);
    });

    // Peş peşe silmelerde mesajların üst üste binmemesi için önceki mesajı gizle
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // 3. Bilgi mesajını (SnackBar) ve Geri Al butonunu göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("'$deletedItem' silindi."),
        duration: const Duration(seconds: 4), // 4 saniye ekranda kalsın
        behavior: SnackBarBehavior.floating, // Havada duran tasarım
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'GERİ AL',
          textColor: const Color(0xFFFDCB2C), // Dikkat çekici sarı renk
          onPressed: () {
            // Geri al butonuna basıldığında öğeyi eski yerine ekle
            setState(() {
              _items.insert(deletedIndex, deletedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.listName,
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text(
              'LİSTELER',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return _buildListItem(index);
                    },
                  ),
          ),
          _buildBottomInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F2F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_basket_outlined,
              size: 48,
              color: primaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Listeniz şu an boş. Başka bir şey\neklemek ister misiniz?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(Icons.circle_outlined, color: Colors.grey[400]),
        title: Text(
          _items[index],
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.redAccent),
          onPressed: () => _removeItem(index),
        ),
      ),
    );
  }

  Widget _buildBottomInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(Icons.add_circle_outline, color: primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      hintText: 'Yeni öge ekle...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onSubmitted: (value) => _addItem(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ekle',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, {
                  'title': widget.listName,
                  'icon': widget.selectedIcon,
                  'iconColor': widget.selectedColor,
                  'itemCount': _items.length,
                  'progress': 0.0,
                  'progressColor': widget.selectedColor,
                  'items': _items
                      .map((e) => {'title': e, 'isCompleted': false})
                      .toList(),
                });
              },
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text(
                'Listeyi Tamamla',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
