import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/custom_button.dart';  // Importe o botão personalizado

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;
    print('Email: $email, Password: $password');
  }

  void _register() {
    print('Ir para a tela de registro');
  }

  Future<void> _loginWithGoogle() async {
    try {
      await _googleSignIn.signIn();
      print('Login com Google bem-sucedido');
    } catch (error) {
      print('Erro ao fazer login com Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9EA),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 100.0),  // Espaço para centralizar o conteúdo verticalmente
              Container(
                width: double.infinity,
                height: 200.0,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                  fontSize: 24.0,
                  color: Color(0xFFFFA61F),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Outfit',
                    color: Color(0xFF444040),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 2.0,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF444040),
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(
                    fontFamily: 'Outfit',
                    color: Color(0xFF444040),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF444040),
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    print('Esqueceu sua senha?');
                  },
                  child: Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Color(0xFF444040),
                      fontSize: 16.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3CA8CF),  // Usar backgroundColor em vez de primary
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24.0,
                      color: Color(0xFFFFF9EA),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: GestureDetector(
                  onTap: () {
                  // Navegar para a tela de registro
                  Navigator.pushNamed(context, '/register');
        },
                  child: Text(
                    'Registre-se',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Color(0xFF3CA8CF),
                      fontSize: 16.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Ou entre com:',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Color(0xFF555252),
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Color(0xFF3CA8CF),
                      thickness: 1.0,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: _loginWithGoogle,
                    child: Image.asset(
                      'assets/google.png',  // Verifique se o caminho está correto
                      width: 48.0,  // Aumentar o tamanho do ícone
                      height: 48.0,  // Aumentar o tamanho do ícone
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Divider(
                      color: Color(0xFF3CA8CF),
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
