import 'package:flutter/material.dart';
import 'package:klinik_app/ui/poli_sidebar.dart';

class PoliHomepage extends StatelessWidget {
  const PoliHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PoliSidebar(),
      appBar: AppBar(title: const Text("Home")),
      body: const Center(child: Text("Beranda")),
    );
  }
}
