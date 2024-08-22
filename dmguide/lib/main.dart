import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/creation_screen.dart';
import 'screens/collection_screen.dart';
import 'screens/edit_screen.dart'; // Importe a tela de edição
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
        '/creation_screen': (context) => CreationScreen(),
        // Remover o CollectionScreen daqui e incluir no onGenerateRoute
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return HomeScreen(
                userName: args['userName'] ?? '',
                email: args['email'] ?? '',
              );
            },
          );
        }

        if (settings.name == '/collection_screen') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return CollectionScreen(
                email: args['email'] ?? '', // Passar o email como argumento
              );
            },
          );
        }
if (settings.name == '/edit_screen') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return CollectionScreen(
                email: args['email'] ?? '', // Passar o email como argumento
              );
            },
          );
        }

        return null;
      },
    );
  }
}