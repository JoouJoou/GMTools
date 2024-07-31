import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      print('Campos vazios: email ou senha não fornecidos');
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
      print('Consultando Firestore para o email: $email');
      final query = await _firestore.collection('users').where('email', isEqualTo: email).get();
      print('Consulta Firestore concluída. Total de documentos encontrados: ${query.docs.length}');

      if (query.docs.isNotEmpty) {
        final user = query.docs.first.data();
        print('Usuário encontrado: ${user['email']}');
        print('Senha armazenada: ${user['password']}'); // Atenção ao expor senhas

        if (user['password'] == password) {
          print('Login bem-sucedido');
          Navigator.pushReplacementNamed(context, '/home');  // Substitua '/home' pela sua tela inicial
        } else {
          print('Senha incorreta');
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Erro'),
              content: Text('Email ou senha incorretos.'),
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
      } else {
        print('Usuário não encontrado');
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Erro'),
            content: Text('Usuário não encontrado.'),
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
    } catch (e) {
      print('Erro ao fazer login: $e');
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao fazer login. Tente novamente.'),
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
          '',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24,
            color: Color(0xFFFFA61F),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/logo.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 24,
                        color: Color(0xFFFFA61F),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF3CA8CF), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF3CA8CF), width: 1),
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
                          borderSide: BorderSide(color: Color(0xFF3CA8CF), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF3CA8CF), width: 1),
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
                    SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Implementar a navegação para tela de recuperação de senha
                        },
                        child: Text(
                          'Esqueceu sua senha?',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            color: Color(0xFF444040),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3CA8CF),
                        minimumSize: Size(double.infinity, 48),  // Largura 100%
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          color: Color(0xFFFFF9EA),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');  // Navegar para a tela de registro
                        },
                        child: Text(
                          'Registre-se',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            color: Color(0xFF3CA8CF),
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
                          fontSize: 16,
                          color: Color(0xFF555252),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 1,
                          color: Color(0xFF3CA8CF),
                        ),
                        SizedBox(width: 8.0),
                        Image.asset(
                          'assets/google.png',
                          width: 50,  // Tamanho do ícone
                          height: 50, // Tamanho do ícone
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          width: 50,
                          height: 1,
                          color: Color(0xFF3CA8CF),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
