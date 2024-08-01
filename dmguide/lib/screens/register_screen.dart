import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro'),
          content: Text('Preencha todos os campos obrigatórios.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await _firestore.collection('users').add({
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
      });

      Navigator.pop(context);
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao registrar. Tente novamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9EA),
      appBar: AppBar(
        title: Text(
          'Registro',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24,
            color: Color(0xFFFFA61F),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registro',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 24,
                  color: Color(0xFFFFA61F),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Nome de usuário',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  color: Color(0xFF444040),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  color: Color(0xFF444040),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Número de telefone',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  color: Color(0xFF444040),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3CA8CF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  color: Color(0xFF444040),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3CA8CF),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  'Registrar',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 24,
                    color: Color(0xFFFFF9EA),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Já tem uma conta? Faça login',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    color: Color(0xFF3CA8CF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
