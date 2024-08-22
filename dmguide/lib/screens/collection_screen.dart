import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_screen.dart'; // Importe a tela de edição

class CollectionScreen extends StatelessWidget {
  final String email;

  CollectionScreen({required this.email, required characterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minhas Criações',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24,
            color: Color(0xFFFFF9EA),
          ),
        ),
        backgroundColor: Color(0xFF3CA8CF),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('characters')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum personagem criado.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var character = snapshot.data!.docs[index];
              var characterId = character['characterId']; // Obtenha o characterId

              return ListTile(
                title: Text(
                  character['campaign'],
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    color: Color(0xFF3CA8CF),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Idade: ${character['age']}'),
                    Text('Tipo: ${character['type']}'),
                    Text('Alinhamento: ${character['alignment']}'),
                  ],
                ),
                trailing: SizedBox(
                  width: 96,  // Ajuste a largura conforme necessário
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF3CA8CF)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditScreen(
                                characterId: characterId, // Passe o characterId
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Confirmar Exclusão'),
                              content: Text('Deseja realmente excluir este personagem?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  },
                                  child: Text('Excluir'),
                                ),
                              ],
                            ),
                          );

                          if (confirm) {
                            FirebaseFirestore.instance
                                .collection('characters')
                                .doc(character.id)
                                .delete();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Navegar para a tela de detalhes do personagem, se necessário
                },
              );
            },
          );
        },
      ),
    );
  }
}
