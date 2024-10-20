import 'package:flutter/material.dart';
import 'package:kesehatan/bloc/login_bloc.dart';
import 'package:kesehatan/helpers/user_info.dart';
import 'package:kesehatan/ui/nutrisi_page.dart';
import 'package:kesehatan/ui/registrasi_page.dart';
import 'package:kesehatan/widget/success_dialog.dart';
import 'package:kesehatan/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAppBar(),
                const SizedBox(height: 50),
                _buildLoginForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Membangun latar belakang dengan tema monokrom
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black87, Colors.black54],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  // Membangun header atau judul halaman login
  Widget _buildAppBar() {
    return Column(
      children: const [
        Text(
          'Login',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Courier New',
          ),
        ),
      ],
    );
  }

  // Membangun form login
  Widget _buildLoginForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white, width: 2),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _emailTextField(),
            const SizedBox(height: 20),
            _passwordTextField(),
            const SizedBox(height: 40),
            _buttonLogin(),
            const SizedBox(height: 20),
            _menuRegistrasi(),
          ],
        ),
      ),
    );
  }

  // Membuat Textbox Email dengan gaya monokrom
  Widget _emailTextField() {
    return TextFormField(
      controller: _emailTextboxController,
      decoration: _inputDecoration("Email", Icons.email),
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Textbox Password dengan gaya monokrom
  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordTextboxController,
      decoration: _inputDecoration("Password", Icons.lock),
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat InputDecoration dengan tema monokrom
  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.black54,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Colors.white38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Colors.white70),
      ),
    );
  }

  // Membuat Tombol Login dengan gaya monokrom
  Widget _buttonLogin() {
    return _isLoading
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.black54,
            ),
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              var validate = _formKey.currentState!.validate();
              if (validate && !_isLoading) _submit();
            },
          );
  }

  // Fungsi submit untuk proses login
  void _submit() {
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));

        // Tampilkan dialog sukses setelah berhasil login
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Anda berhasil login.",
            okClick: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NutrisiPage()),
              );
            },
          ),
        );
      } else {
        _showWarningDialog("Login gagal, silahkan coba lagi");
      }
    }).catchError((error) {
      _showWarningDialog("Login gagal, silahkan coba lagi");
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Menampilkan dialog registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Courier New',
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }

  // Menampilkan dialog peringatan
  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WarningDialog(description: message),
    );
  }
}
