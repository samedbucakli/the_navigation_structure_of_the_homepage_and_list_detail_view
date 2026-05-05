import 'package:flutter/material.dart';

class EditListPage extends StatefulWidget {
  final String listTitle;
  final List<Map<String, dynamic>> initialItems;

  const EditListPage({
    super.key,
    required this.listTitle,
    required this.initialItems,
  });

  @override
  State<EditListPage> createState() => _EditListPageState();
}

class _EditListPageState extends State<EditListPage> {
  late List<Map<String, dynamic>> _items;
  final TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Gelen listeyi (deep copy) kopyalayarak alıyoruz.
    _items = widget.initialItems
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int get _totalItems => _items.length;
  int get _completedItems =>
      _items.where((item) => item['isCompleted'] == true).length;
  int get _activeItems =>
      _items.where((item) => item['isCompleted'] == false).length;

  double get _progress =>
      _totalItems == 0 ? 0.0 : _completedItems / _totalItems;

  void _toggleItem(int originalIndex) {
    setState(() {
      _items[originalIndex]['isCompleted'] =
          !_items[originalIndex]['isCompleted'];
    });
  }

  // --- YENİLENEN SİLME FONKSİYONU (GERİ AL EKLENDİ) ---
  void _deleteItem(int originalIndex) {
    // 1. Silinen öğeyi ve sırasını hafızaya al
    final deletedItem = _items[originalIndex];
    final deletedIndex = originalIndex;

    // 2. Öğeyi listeden sil
    setState(() {
      _items.removeAt(originalIndex);
    });

    // Peş peşe silmelerde mesajların üst üste binmemesi için önceki mesajı gizle
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // 3. Bilgi mesajı ve Geri Al butonu göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("'${deletedItem['title']}' silindi."),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'GERİ AL',
          textColor: const Color(0xFFFDCB2C),
          onPressed: () {
            // Geri Al butonuna tıklandığında silinen öğeyi eski sırasına tekrar yerleştiriyoruz
            setState(() {
              _items.insert(deletedIndex, deletedItem);
            });
          },
        ),
      ),
    );
  }

  void _addItem() {
    if (_itemController.text.trim().isNotEmpty) {
      setState(() {
        _items.add({
          'title': _itemController.text.trim(),
          'isCompleted': false,
        });
        _itemController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _showEditBottomSheet(int index, String currentTitle) {
    TextEditingController editController = TextEditingController(
      text: currentTitle,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ögeyi Düzenle',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Öge Adı',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: editController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: Icon(
                        Icons.edit_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (editController.text.trim().isNotEmpty) {
                        setState(() {
                          _items[index]['title'] = editController.text.trim();
                        });
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Kaydet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  final Color primaryColor = const Color(0xFF136E80);
  final Color backgroundColor = const Color(0xFFF7F9FB);
  final Color textColor = const Color(0xFF1F3A4B);
  final Color completedCardColor = const Color(0xFFF2F6FA);

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, {
          'itemCount': _totalItems,
          'progress': _progress,
          'updatedItems': _items,
        });
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () {
              Navigator.pop(context, {
                'itemCount': _totalItems,
                'progress': _progress,
                'updatedItems': _items,
              });
            },
          ),
          title: Text(
            widget.listTitle,
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: Colors.grey[200], height: 1.0),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Aktif Öğeler',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5F3F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$_activeItems Kalan',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._items
                        .asMap()
                        .entries
                        .where((e) => !e.value['isCompleted'])
                        .map((entry) {
                          return _buildActiveItemCard(
                            entry.key,
                            entry.value['title'],
                          );
                        }),
                    const SizedBox(height: 32),
                    if (_completedItems > 0) ...[
                      Text(
                        'Tamamlananlar',
                        style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 12),
                      ..._items
                          .asMap()
                          .entries
                          .where((e) => e.value['isCompleted'])
                          .map((entry) {
                            return _buildCompletedItemCard(
                              entry.key,
                              entry.value['title'],
                            );
                          }),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.listTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_totalItems öğeden $_completedItems\'i tamamlandı',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  strokeWidth: 6,
                ),
                Center(
                  child: Text(
                    '${(_progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveItemCard(int index, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: () => _toggleItem(index),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
            ),
          ),
        ),
        title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () => _showEditBottomSheet(index, title),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () => _deleteItem(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedItemCard(int index, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: completedCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: () => _toggleItem(index),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF67B0A4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
          onPressed: () => _deleteItem(index),
        ),
      ),
    );
  }

  Widget _buildBottomInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(
                        hintText: 'Yeni öğe ekle...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: (_) => _addItem(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Ekle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
