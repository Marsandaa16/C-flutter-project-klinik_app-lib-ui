import 'package:flutter/material.dart';
import '../model/poli.dart';
import '../service/poli_service.dart';
import 'poli_update_form.dart';
import 'poli_form.dart'; // Form tambah data

class PoliDetail extends StatefulWidget {
  final Poli poli;

  const PoliDetail({Key? key, required this.poli}) : super(key: key);

  @override
  _PoliDetailState createState() => _PoliDetailState();
}

class _PoliDetailState extends State<PoliDetail> {
  late Future<Poli> _futurePoli;

  @override
  void initState() {
    super.initState();
    _futurePoli = _fetchPoli();
  }

  Future<Poli> _fetchPoli() async {
    return await PoliService().getById(widget.poli.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Poli"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Mengembalikan true untuk refresh halaman sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _tambahData, // Fungsi tambah data
          ),
        ],
      ),
      body: FutureBuilder<Poli>(
        future: _futurePoli,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Data Tidak Ditemukan'));
          }

          final poliData = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Nama Poli: ${poliData.namaPoli}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_tombolUbah(poliData), _tombolHapus(poliData)],
              ),
            ],
          );
        },
      ),
    );
  }

  void _tambahData() async {
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PoliForm()),
    );
    if (shouldRefresh == true) {
      setState(() {
        _futurePoli = _fetchPoli(); // Refresh data setelah penambahan
      });
    }
  }

  Widget _tombolUbah(Poli poli) {
    return ElevatedButton(
      onPressed: () async {
        final shouldRefresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PoliUpdateForm(poli: poli),
          ),
        );
        if (shouldRefresh == true) {
          setState(() {
            _futurePoli = _fetchPoli(); // Refresh data setelah pengubahan
          });
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text("Ubah"),
    );
  }

  Widget _tombolHapus(Poli poli) {
    return ElevatedButton(
      onPressed: () {
        _showHapusDialog(poli);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text("Hapus"),
    );
  }

  void _showHapusDialog(Poli poli) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await PoliService().hapus(poli).then((value) {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context, true); // Kembali dengan refresh
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("YA"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Tidak"),
            ),
          ],
        );
      },
    );
  }
}
