import 'package:flutter/material.dart';
import 'package:kesehatan/bloc/nutrisi_bloc.dart';
import 'package:kesehatan/widget/warning_dialog.dart';
import 'package:kesehatan/model/nutrisi.dart';
import 'package:kesehatan/ui/nutrisi_page.dart';

class NutrisiForm extends StatefulWidget {
  final Nutrisi? nutrisi;

  NutrisiForm({super.key, this.nutrisi});

  @override
  _NutrisiFormState createState() => _NutrisiFormState();
}

class _NutrisiFormState extends State<NutrisiForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _judul = "TAMBAH Nutrisi";
  String _tombolSubmit = "SIMPAN";
  final _itemNutrisiTextboxController = TextEditingController();
  final _caloriesNutrisiTextboxController = TextEditingController();
  final _fatNutrisiTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfUpdate();
  }

  void _checkIfUpdate() {
    if (widget.nutrisi != null) {
      setState(() {
        _judul = "UBAH Nutrisi";
        _tombolSubmit = "UBAH";
        _itemNutrisiTextboxController.text = widget.nutrisi!.itemNutrisi!;
        _caloriesNutrisiTextboxController.text =
            widget.nutrisi!.caloriesNutrisi.toString();
        _fatNutrisiTextboxController.text =
            widget.nutrisi!.fatNutrisi.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _judul,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier New',
          ),
        ),
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildItemNutrisiTextField(),
                    const SizedBox(height: 16.0),
                    _buildCaloriesNutrisiTextField(),
                    const SizedBox(height: 16.0),
                    _buildFatNutrisiTextField(),
                    const SizedBox(height: 32.0),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemNutrisiTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Item Nutrisi",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black54,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      controller: _itemNutrisiTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Item Nutrisi harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buildCaloriesNutrisiTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Kalori Nutrisi",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black54,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      controller: _caloriesNutrisiTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kalori harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buildFatNutrisiTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Lemak Nutrisi",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black54,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      controller: _fatNutrisiTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Lemak harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              _tombolSubmit,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: 'Courier New',
              ),
            ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (!_isLoading) {
            widget.nutrisi != null ? _updateNutrisi() : _simpanNutrisi();
          }
        }
      },
    );
  }

  void _simpanNutrisi() {
    setState(() {
      _isLoading = true;
    });

    Nutrisi newNutrisi = Nutrisi(id: null);
    newNutrisi.itemNutrisi = _itemNutrisiTextboxController.text;
    newNutrisi.caloriesNutrisi =
        int.tryParse(_caloriesNutrisiTextboxController.text);
    newNutrisi.fatNutrisi = int.tryParse(_fatNutrisiTextboxController.text);

    NutrisiBloc.addNutrisi(nutrisi: newNutrisi).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const NutrisiPage()));
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi.",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _updateNutrisi() {
    setState(() {
      _isLoading = true;
    });

    Nutrisi updatedNutrisi = Nutrisi(id: widget.nutrisi!.id!);
    updatedNutrisi.itemNutrisi = _itemNutrisiTextboxController.text;
    updatedNutrisi.caloriesNutrisi =
        int.tryParse(_caloriesNutrisiTextboxController.text);
    updatedNutrisi.fatNutrisi = int.tryParse(_fatNutrisiTextboxController.text);

    NutrisiBloc.updateNutrisi(nutrisi: updatedNutrisi).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const NutrisiPage()));
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Ubah data gagal, silahkan coba lagi.",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
