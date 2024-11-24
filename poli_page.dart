import 'package:flutter/material.dart';
import '../model/poli.dart';
import '../service/poli_service.dart';
import 'poli_form.dart';
import 'poli_detail.dart';

class PoliPage extends StatefulWidget {
  const PoliPage({Key? key}) : super(key: key);

  @override
  _PoliPageState createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
  Future<List<Poli>> fetchData() async {
    return await PoliService().listData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Poli"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Navigasi ke halaman tambah data
              final shouldRefresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PoliForm()),
              );
              if (shouldRefresh == true) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Poli>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data Kosong'));
          }

          final List<Poli> poliList = snapshot.data!;

          return ListView.builder(
            itemCount: poliList.length,
            itemBuilder: (context, index) {
              final poli = poliList[index];
              return ListTile(
                title: Text(poli.namaPoli),
                onTap: () async {
                  // Navigasi ke halaman detail poli
                  final shouldRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoliDetail(poli: poli),
                    ),
                  );
                  if (shouldRefresh == true) {
                    setState(() {}); // Refresh data jika ada perubahan
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
