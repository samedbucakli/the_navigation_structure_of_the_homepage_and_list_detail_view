import 'package:flutter/material.dart';
import 'home_page.dart'; // Ana sayfamızı içe aktarıyoruz

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskControl',
      debugShowCheckedModeBanner:
          false, // Sağ üstteki 'DEBUG' yazısını kaldırır
      theme: ThemeData(
        // Uygulamanızın ana tema rengi (Teal/Turkuaz)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF136E80)),
        useMaterial3: true, // Modern Material 3 tasarımını kullan
      ),
      home: const HomePage(), // Uygulama açıldığında ilk burası çalışır
    );
  }
}
