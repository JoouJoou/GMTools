import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';  // Importe a tela de registro

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Defina a fonte padrão para todos os textos no tema
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF3CA8CF)),
            borderRadius: BorderRadius.circular(4.0),
          ),
          hintStyle: TextStyle(fontFamily: 'Outfit', fontSize: 16.0, color: Color(0xFF444040)),
        ),
        // Outras propriedades de tema, se necessário
        // backgroundColor: Colors.white,
      ),
      home: LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),  // Adicione a rota
      },
    );
  }
}
