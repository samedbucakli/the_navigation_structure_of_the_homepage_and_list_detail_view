import 'package:flutter/material.dart';
import 'list_detail_page.dart';

class CreateListPage extends StatefulWidget {
  const CreateListPage({super.key});

  @override
  State<CreateListPage> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  // Durum Yönetimi Değişkenleri
  final TextEditingController _nameController = TextEditingController();
  int _selectedIconIndex = 0;
  int _selectedColorIndex = 0;

  // Görseldeki İkonlar
  final List<IconData> _icons = [
    Icons.shopping_cart_outlined,
    Icons.favorite_border,
    Icons.business_center_outlined,
    Icons.flight_takeoff_outlined,
    Icons.menu_book_outlined,
  ];

  // Görseldeki Renkler
  final List<Color> _colors = [
    const Color(0xFF1CD4D4), // Turkuaz/Mavi
    const Color(0xFFFF6B81), // Pembe/Kırmızı
    const Color(0xFFFDCB2C), // Sarı/Turuncu
    const Color(0xFF2ED573), // Yeşil
    const Color(0xFF706FD3), // Mor
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF136E80); // Ana Teal Rengi
    const Color pageBackgroundColor = Color(0xFFF7F9FB);

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Yeni Liste Oluştur',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[200], // İnce alt çizgi
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. LİSTE ADI ALANI
              _buildSectionTitle('Liste Adı'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Liste adı girin...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color(
                      0xFFF4F6F9,
                    ), // Hafif gri input arka planı
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none, // Kenarlık yok
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. SİMGE SEÇİN ALANI
              _buildSectionTitle('Simge Seçin'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_icons.length, (index) {
                    bool isSelected = _selectedIconIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIconIndex = index;
                        });
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor
                              : const Color(0xFFF4F6F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _icons[index],
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 28,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // 3. RENK TEMASI ALANI
              _buildSectionTitle('Renk Teması'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_colors.length, (index) {
                    bool isSelected = _selectedColorIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? _colors[index].withValues(alpha: 0.3)
                                : Colors.transparent,
                            width: 4, // Seçili rengin etrafındaki soluk halka
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _colors[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),

              // 4. BİLGİLENDİRME BANNER'I
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF19869B), Color(0xFF105B6A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.format_list_bulleted,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Yeni Listenizi Hazırlayın',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verimliliğinizi artırmak için kategorize edin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ), // Butonun arkasında boşluk bırakmak için
            ],
          ),
        ),
      ),

      // ALT KISIMDA SABİT BUTON
      bottomSheet: Container(
        color: pageBackgroundColor,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            // DÜZELTME: async eklendi, sayfalar zincirlendi!
            onPressed: () async {
              String listName = _nameController.text.trim();
              if (listName.isEmpty) listName = "Yeni Liste";

              // Detay sayfasına git ve oradan dönecek olan sonucu (result) bekle
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListDetailPage(
                    listName: listName,
                    selectedIcon: _icons[_selectedIconIndex],
                    selectedColor: _colors[_selectedColorIndex],
                  ),
                ),
              );

              // Detay sayfasından "Tamamla" denip veri gönderildiyse
              if (result != null) {
                // Bu sayfayı da kapat ve o veriyi ana sayfaya (home_page) aktar
                if (context.mounted) {
                  Navigator.pop(context, result);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Tam yuvarlak köşeler
              ),
              elevation: 0,
            ),
            child: const Text(
              'Listeyi Oluştur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bölüm başlıklarını oluşturan yardımcı widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4A5568), // Koyu Gri
        ),
      ),
    );
  }
}
