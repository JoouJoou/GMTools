import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditScreen extends StatefulWidget {
  final String email;

  EditScreen({required this.email});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _campaignController;
  late TextEditingController _ageController;
  late TextEditingController _typeController;
  late TextEditingController _alignmentController;

  @override
  void initState() {
    super.initState();
    _campaignController = TextEditingController();
    _ageController = TextEditingController();
    _typeController = TextEditingController();
    _alignmentController = TextEditingController();

    _loadCharacterData();
  }

  Future<void> _loadCharacterData() async {
    var characterDoc = await FirebaseFirestore.instance
        .collection('characters')
        .where('email', isEqualTo: widget.email)
        .get();

    var data = characterDoc.docs.first.data() as Map<String, dynamic>;

    setState(() {
      _campaignController.text = data['campaign'];
      _ageController.text = data['age'].toString();
      _typeController.text = data['type'];
      _alignmentController.text = data['alignment'];
    });
  }

  Future<void> _saveCharacter() async {
    if (_formKey.currentState?.validate() ?? false) {
      var characterDoc = await FirebaseFirestore.instance
          .collection('characters')
          .where('email', isEqualTo: widget.email)
          .get();

      await FirebaseFirestore.instance
          .collection('characters')
          .doc(characterDoc.docs.first.id)
          .update({
        'campaign': _campaignController.text,
        'age': int.parse(_ageController.text),
        'type': _typeController.text,
        'alignment': _alignmentController.text,
      });

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _campaignController.dispose();
    _ageController.dispose();
    _typeController.dispose();
    _alignmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edição de NPC'),
        backgroundColor: Color(0xFF3CA8CF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _campaignController,
                decoration: InputDecoration(
                  labelText: 'Campanha',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da campanha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Idade',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a idade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tipo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _alignmentController,
                decoration: InputDecoration(
                  labelText: 'Alinhamento',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o alinhamento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveCharacter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3CA8CF),
                ),
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
