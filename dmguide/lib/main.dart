import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';  // Importe a tela de registro
import 'screens/home_screen.dart';      // Importe a tela inicial
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF3CA8CF)),
            borderRadius: BorderRadius.circular(4.0),
          ),
          hintStyle: TextStyle(fontFamily: 'Outfit', fontSize: 16.0, color: Color(0xFF444040)),
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),  // Adicione a rota para a tela inicial
      },
    );
  }
}
