import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // Adicione esta importação para usar o TextInputFormatter
import 'package:uuid/uuid.dart'; // Adicione esta importação

class CreationScreen extends StatefulWidget {
  @override
  _CreationScreenState createState() => _CreationScreenState();
}

class _CreationScreenState extends State<CreationScreen> {
  final _campaignController = TextEditingController();
  final _ageController = TextEditingController();
  final _appearanceController = TextEditingController();
  final _historyController = TextEditingController();
  final _naturalnessController = TextEditingController();

  String? _selectedType;
  String? _selectedAlignment;

  final List<String> _types = ['Aliado', 'Comerciante', 'Vilão', 'Histórico', 'Incógnito'];
  final List<String> _alignments = [
    'Leal bom', 'Leal neutro', 'Leal mau', 'Neutro bom', 'Neutro', 'Neutro mau',
    'Caótico bom', 'Caótico neutro', 'Caótico mau'
  ];

  String? _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _email = args['email'];
      print('Email recebido: $_email'); // Adiciona o print para verificar o email
    }
  }

  Future<void> _saveData() async {
    final campaign = _campaignController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    final type = _selectedType ?? '';
    final alignment = _selectedAlignment ?? '';
    final appearance = _appearanceController.text;
    final history = _historyController.text;
    final naturalness = _naturalnessController.text;

    if (campaign.isEmpty || type.isEmpty || alignment.isEmpty || appearance.isEmpty || history.isEmpty || naturalness.isEmpty) {
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

    // Gerar um ID único para o personagem
    final characterId = Uuid().v4();

    try {
      await FirebaseFirestore.instance.collection('characters').add({
        'characterId': characterId, // Adicionar o characterId
        'email': _email,
        'campaign': campaign,
        'age': age,
        'type': type,
        'alignment': alignment,
        'appearance': appearance,
        'history': history,
        'naturalness': naturalness,
      });

      Navigator.pop(context);
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao salvar dados: $e'),
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
      appBar: AppBar(
        backgroundColor: Color(0xFF3CA8CF),
        title: Row(
          children: [
            Text(
              'Criação de Personagem',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                color: Color(0xFFFFF9EA),
              ),
            ),
            Spacer(),
            Icon(Icons.account_circle, color: Color(0xFFFFF9EA)),
            SizedBox(width: 16),
            Icon(Icons.menu, color: Color(0xFFFFF9EA)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _campaignController,
                    label: 'Nome',
                    hint: 'Nome do Personagem',
                    isNumber: false,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: _buildTextField(
                    controller: _ageController,
                    label: 'Idade',
                    hint: 'Idade',
                    isNumber: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    value: _selectedType,
                    hint: 'Tipo',
                    items: _types,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildDropdownField(
                    value: _selectedAlignment,
                    hint: 'Alinhamento',
                    items: _alignments,
                    onChanged: (value) {
                      setState(() {
                        _selectedAlignment = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            _buildTextField(
              controller: _naturalnessController,
              label: 'Naturalidade',
              hint: 'Local de origem',
              isNumber: false,
            ),
            SizedBox(height: 16),
            _buildDescriptionField(
              controller: _appearanceController,
              label: 'Aparência',
              hint: 'Descreva aqui a aparência desse personagem...',
            ),
            SizedBox(height: 16),
            _buildDescriptionField(
              controller: _historyController,
              label: 'História',
              hint: 'Escreva aqui a história desse personagem...',
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3CA8CF),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Salvar',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  color: Color(0xFFFFF9EA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController? controller,
    required String label,
    required String hint,
    required bool isNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            color: Color(0xFFFFA61F),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFFFF9EA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDescriptionField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            color: Color(0xFFFFA61F),
          ),
        ),
        SizedBox(height: 8),
        Container(
          color: Color(0xFFFFF9EA),
          child: TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      constraints: BoxConstraints(maxHeight: 60), // Define a altura máxima para a caixa
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFFFF9EA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]), // Define a cor do texto do placeholder
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey[600]), // Define a cor do texto do placeholder
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
