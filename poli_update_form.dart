import 'package:flutter/material.dart';
import '../model/poli.dart';
import '../service/poli_service.dart';

class PoliUpdateForm extends StatefulWidget {
  final Poli poli;

  const PoliUpdateForm({Key? key, required this.poli}) : super(key: key);

  @override
  _PoliUpdateFormState createState() => _PoliUpdateFormState();
}

class _PoliUpdateFormState extends State<PoliUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPoliCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaPoliCtrl.text = widget.poli.namaPoli;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Poli")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaPoliCtrl,
                decoration: const InputDecoration(labelText: "Nama Poli"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama Poli tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Poli poli = Poli(
                      id: widget.poli.id,
                      namaPoli: _namaPoliCtrl.text,
                    );
                    await PoliService().ubah(poli, poli.id.toString()).then((_) {
                      Navigator.pop(context, true); // Kembali dengan refresh
                    });
                  }
                },
                child: const Text("Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
