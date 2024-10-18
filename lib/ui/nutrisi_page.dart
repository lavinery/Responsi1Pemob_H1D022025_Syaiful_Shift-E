import 'package:flutter/material.dart';
import 'package:kesehatan/bloc/logout_bloc.dart';
import 'package:kesehatan/bloc/nutrisi_bloc.dart';
import 'package:kesehatan/model/nutrisi.dart';
import 'package:kesehatan/ui/nutrisi_detail.dart';
import 'package:kesehatan/ui/nutrisi_form.dart';
import 'package:kesehatan/ui/login_page.dart';

class NutrisiPage extends StatefulWidget {
  const NutrisiPage({super.key});

  @override
  _NutrisiPageState createState() => _NutrisiPageState();
}

class _NutrisiPageState extends State<NutrisiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'List Nutrisi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily:
                'Courier New', // Menyelaraskan dengan font di halaman login
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NutrisiForm()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black87,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black87, // Gelap
                    Color.fromARGB(136, 83, 83,
                        83), // Lebih terang, selaras dengan halaman login
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Courier New',
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              trailing: const Icon(Icons.logout, color: Colors.white),
              onTap: () async {
                await LogoutBloc.logout().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors
                  .black87, // Menggunakan warna yang sama seperti halaman login
              Colors.black54,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Nutrisi>>(
          future: NutrisiBloc.getNutrisi(), // Call to fetch the data
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(
                child: Text(
                  "Error loading data",
                  style: TextStyle(color: Colors.redAccent),
                ),
              );
            }
            return snapshot.hasData
                ? ListNutrisi(list: snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class ListNutrisi extends StatelessWidget {
  final List<Nutrisi> list;

  const ListNutrisi({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ItemNutrisi(nutrisi: list[index]);
      },
    );
  }
}

class ItemNutrisi extends StatelessWidget {
  final Nutrisi nutrisi;

  const ItemNutrisi({super.key, required this.nutrisi});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NutrisiDetail(nutrisi: nutrisi),
          ),
        );
      },
      child: Card(
        color: const Color.fromARGB(115, 255, 255,
            255), // Warna background kartu lebih terang dari background umum
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Text(
            nutrisi.itemNutrisi ?? 'Unknown',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              fontFamily:
                  'Courier New', // Konsistensi font dengan halaman login
            ),
          ),
          subtitle: Text(
            'Kalori: ${nutrisi.caloriesNutrisi?.toString() ?? '0'}\nLemak: ${nutrisi.fatNutrisi?.toString() ?? '0'}',
            style: const TextStyle(
              color: Colors
                  .white70, // Menggunakan warna lebih terang untuk subtitle
              fontSize: 14.0,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        ),
      ),
    );
  }
}
