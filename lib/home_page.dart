import 'package:flutter/material.dart';
import 'create_list_page.dart';
import 'edit_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color navBackgroundColor = Colors.white;
  final Color pageBackgroundColor = const Color(0xFFF7F9FB);
  final Color primaryColor = const Color(0xFF136E80);
  final Color textColor = const Color(0xFF1F3A4B);
  final Color subtitleColor = const Color(0xFF6B7280);
  final Color bannerBackgroundColor = const Color(0xFFDCF3FB);

  final List<Map<String, dynamic>> _myLists = [
    {
      'title': 'Market Alışverişi',
      'icon': Icons.shopping_cart_outlined,
      'iconColor': const Color(0xFF136E80),
      'itemCount': 5,
      'progress': 0.4,
      'progressColor': const Color(0xFF136E80),
      'items': [
        {'title': 'Tam Yağlı Süt (2L)', 'isCompleted': false},
        {'title': 'Organik Yumurta (10\'lu)', 'isCompleted': false},
        {'title': 'Taze Ekmek', 'isCompleted': false},
        {'title': 'Meyve Suyu', 'isCompleted': true},
        {'title': 'Maden Suyu (6\'lı)', 'isCompleted': true},
      ],
    },
    {
      'title': 'Seyahat Planı',
      'icon': Icons.flight_takeoff_outlined,
      'iconColor': const Color(0xFFC9A284),
      'itemCount': 0,
      'progress': 0.0,
      'progressColor': const Color(0xFF8B5E3C),
      'items': <Map<String, dynamic>>[],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: navBackgroundColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TaskControl',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/32.jpg',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Listelerim',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Düzenli bir gün için listelerini yönet.',
                        style: TextStyle(fontSize: 16, color: subtitleColor),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateListPage(),
                              ),
                            );

                            if (result != null &&
                                result is Map<String, dynamic>) {
                              setState(() {
                                _myLists.insert(0, result);
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Yeni Liste Oluştur',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Dinamik Liste Kartları (Dismissible ile)
                      ..._myLists.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> listData = entry.value;

                        return _buildListCard(
                          cardKey: ObjectKey(listData),
                          index: index,
                          icon: listData['icon'],
                          iconColor: listData['iconColor'],
                          title: listData['title'],
                          itemCount: listData['itemCount'],
                          progress: listData['progress'],
                          progressColor: listData['progressColor'],
                          items: listData['items'],
                        );
                      }),

                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: bannerBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verimliliğini Artır',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Yeni bir kategori ekleyerek işlerini organize etmeye devam et.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: textColor.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.check_circle_outline,
                                size: 70,
                                color: Color(0xFFA7D8F0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard({
    required Key cardKey,
    required int index,
    required IconData icon,
    required Color iconColor,
    required String title,
    required int itemCount,
    required double progress,
    required Color progressColor,
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: cardKey,
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        onDismissed: (direction) {
          // 1. ADIM: Silinecek öğeyi ve sırasını geçici hafızaya alıyoruz
          final deletedItem = _myLists[index];
          final deletedIndex = index;

          // 2. ADIM: Öğeyi listeden siliyoruz
          setState(() {
            _myLists.removeAt(index);
          });

          // Eski SnackBar'ları temizliyoruz (peş peşe hızlı sildiğinde üst üste binmesin diye)
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // 3. ADIM: Kullanıcıya bilgi verip GERİ AL butonunu ekliyoruz
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title listesi silindi.'),
              duration: const Duration(
                seconds: 4,
              ), // Geri almak için süreyi biraz uzattık (4 saniye)
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              action: SnackBarAction(
                label: 'GERİ AL',
                textColor: const Color(
                  0xFFFDCB2C,
                ), // Geri al yazısı için dikkat çekici bir sarı renk
                onPressed: () {
                  // Geri Al butonuna tıklandığında silinen öğeyi eski sırasına tekrar yerleştiriyoruz
                  setState(() {
                    _myLists.insert(deletedIndex, deletedItem);
                  });
                },
              ),
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditListPage(listTitle: title, initialItems: items),
                ),
              );

              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _myLists[index]['itemCount'] = result['itemCount'];
                  _myLists[index]['progress'] = result['progress'];
                  _myLists[index]['items'] = result['updatedItems'];
                });
              }
            },
            child: Ink(
              padding: const EdgeInsets.all(16),
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F3A4B),
                          ),
                        ),
                        Text(
                          '$itemCount öge',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                        minHeight: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.chevron_right, color: Colors.grey[300]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
