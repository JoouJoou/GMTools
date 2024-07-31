import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial'),
        backgroundColor: Color(0xFF3CA8CF),
      ),
      body: Center(
        child: Text(
          'Bem-vindo à Tela Inicial!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
