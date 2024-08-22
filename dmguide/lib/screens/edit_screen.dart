import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditScreen extends StatefulWidget {
  final String characterId;

  EditScreen({required this.characterId});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _campaignController;
  late TextEditingController _ageController;
  String? _selectedType;
  String? _selectedAlignment;

  final List<String> _types = ['Aliado', 'Comerciante', 'Vilão', 'Histórico', 'Incógnito']; // Adicione mais tipos se necessário
  final List<String> _alignments = ['Leal bom', 'Leal neutro', 'Leal mau', 'Neutro bom', 'Neutro', 'Neutro mau',
    'Caótico bom', 'Caótico neutro', 'Caótico mau']; // Adicione mais alinhamentos se necessário

  @override
  void initState() {
    super.initState();
    _campaignController = TextEditingController();
    _ageController = TextEditingController();

    _loadCharacterData();
  }

  Future<void> _loadCharacterData() async {
    var characterDoc = await FirebaseFirestore.instance
        .collection('characters')
        .where('characterId', isEqualTo: widget.characterId)
        .get();

    var data = characterDoc.docs.first.data() as Map<String, dynamic>;

    setState(() {
      _campaignController.text = data['campaign'];
      _ageController.text = data['age'].toString();
      _selectedType = data['type'];
      _selectedAlignment = data['alignment'];
    });
  }

  Future<void> _saveCharacter() async {
    if (_formKey.currentState?.validate() ?? false) {
      var characterDoc = await FirebaseFirestore.instance
          .collection('characters')
          .where('characterId', isEqualTo: widget.characterId)
          .get();

      await FirebaseFirestore.instance
          .collection('characters')
          .doc(characterDoc.docs.first.id)
          .update({
        'campaign': _campaignController.text,
        'age': int.parse(_ageController.text),
        'type': _selectedType,
        'alignment': _selectedAlignment,
      });

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _campaignController.dispose();
    _ageController.dispose();
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
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                ),
                items: _types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um tipo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAlignment,
                decoration: InputDecoration(
                  labelText: 'Alinhamento',
                ),
                items: _alignments.map((alignment) {
                  return DropdownMenuItem(
                    value: alignment,
                    child: Text(alignment),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAlignment = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um alinhamento';
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
