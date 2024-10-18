import 'package:flutter/material.dart';
import 'package:kesehatan/bloc/nutrisi_bloc.dart';
import 'package:kesehatan/widget/warning_dialog.dart';
import 'package:kesehatan/model/nutrisi.dart';
import 'package:kesehatan/ui/nutrisi_form.dart';
import 'package:kesehatan/ui/nutrisi_page.dart';

class NutrisiDetail extends StatefulWidget {
  final Nutrisi? nutrisi;

  NutrisiDetail({super.key, this.nutrisi});

  @override
  _NutrisiDetailState createState() => _NutrisiDetailState();
}

class _NutrisiDetailState extends State<NutrisiDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Nutrisi'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.white, width: 2),
            ),
            padding: const EdgeInsets.all(16.0),
            width: 350, // Sesuaikan lebar sesuai kebutuhan
            child: Column(
              mainAxisSize: MainAxisSize.min, // Untuk mengatur tinggi konten
              children: [
                Text(
                  "Item: ${widget.nutrisi!.itemNutrisi}",
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Kalori: ${widget.nutrisi!.caloriesNutrisi}",
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Lemak: Rp. ${widget.nutrisi!.fatNutrisi}",
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                const SizedBox(height: 32.0),
                _tombolHapusEdit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Tombol Edit
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(209, 0, 0, 0),
            side: const BorderSide(color: Colors.white), // Border putih
          ),
          child: const Text(
            "EDIT",
            style: TextStyle(color: Colors.white, fontFamily: 'Courier New'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NutrisiForm(
                  nutrisi: widget.nutrisi!,
                ),
              ),
            );
          },
        ),
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(209, 0, 0, 0),
            side: const BorderSide(color: Colors.white), // Border putih
          ),
          child: const Text(
            "DELETE",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?",
          style: TextStyle(color: Colors.black)),
      actions: [
        // Tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            NutrisiBloc.deleteNutrisi(id: widget.nutrisi!.id!).then(
              (value) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NutrisiPage(),
                ));
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            );
          },
        ),
        // Tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
