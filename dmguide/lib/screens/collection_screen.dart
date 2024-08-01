import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Criações'),
        backgroundColor: Color(0xFF3CA8CF),
      ),
      body: Center(
        child: Text(
          'Tela de Minhas Criações',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
