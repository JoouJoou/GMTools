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
  late TextEditingController _naturalnessController;
  late TextEditingController _appearanceController;
  late TextEditingController _historyController;

  String? _selectedType;
  String? _selectedAlignment;
  bool _isLoading = true;

  final List<String> _types = ['Aliado', 'Comerciante', 'Vilão', 'Histórico', 'Incógnito'];
  final List<String> _alignments = ['Leal bom', 'Leal neutro', 'Leal mau', 'Neutro bom', 'Neutro', 'Neutro mau',
    'Caótico bom', 'Caótico neutro', 'Caótico mau'];

  @override
  void initState() {
    super.initState();
    _campaignController = TextEditingController();
    _ageController = TextEditingController();
    _naturalnessController = TextEditingController();
    _appearanceController = TextEditingController();
    _historyController = TextEditingController();

    _loadCharacterData();
  }

  Future<void> _loadCharacterData() async {
    try {
      var characterDoc = await FirebaseFirestore.instance
          .collection('characters')
          .where('characterId', isEqualTo: widget.characterId)
          .get();

      if (characterDoc.docs.isNotEmpty) {
        var data = characterDoc.docs.first.data() as Map<String, dynamic>;

        setState(() {
          _campaignController.text = data['campaign'] ?? '';
          _ageController.text = data['age'].toString() ?? '';
          _naturalnessController.text = data['naturalness'] ?? '';
          _appearanceController.text = data['appearance'] ?? '';
          _historyController.text = data['history'] ?? '';
          _selectedType = data['type'];
          _selectedAlignment = data['alignment'];
          _isLoading = false;
        });
      } else {
        // Exibir uma mensagem de erro se o documento não for encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Personagem não encontrado')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar personagem: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCharacter() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        var characterDoc = await FirebaseFirestore.instance
            .collection('characters')
            .where('characterId', isEqualTo: widget.characterId)
            .get();

        if (characterDoc.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('characters')
              .doc(characterDoc.docs.first.id)
              .update({
            'campaign': _campaignController.text,
            'age': int.parse(_ageController.text),
            'naturalness': _naturalnessController.text,
            'appearance': _appearanceController.text,
            'history': _historyController.text,
            'type': _selectedType,
            'alignment': _selectedAlignment,
          });

          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Personagem não encontrado')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar personagem: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _campaignController.dispose();
    _ageController.dispose();
    _naturalnessController.dispose();
    _appearanceController.dispose();
    _historyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edição de NPC',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24,
            color: Color(0xFFFFF9EA),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF3CA8CF),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _campaignController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do NPC';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _naturalnessController,
                decoration: InputDecoration(
                  labelText: 'Naturalidade',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, atualize a naturalidade do NPC';
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
              SizedBox(height: 16),
              TextFormField(
                controller: _historyController,
                decoration: InputDecoration(
                  labelText: 'História',
                ),
                maxLines: 10,
                minLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, atualize a história do NPC';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _appearanceController,
                decoration: InputDecoration(
                  labelText: 'Aparência',
                ),
                maxLines: 10,
                minLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, atualize a aparência do NPC';
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
                child: Text(
                  'Salvar Alterações',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    color: Color(0xFFFFF9EA),
                    fontWeight: FontWeight.bold,
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
