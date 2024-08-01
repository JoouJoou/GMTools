import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreationScreen extends StatefulWidget {
  @override
  _CreationScreenState createState() => _CreationScreenState();
}

class _CreationScreenState extends State<CreationScreen> {
  final _campaignController = TextEditingController();
  final _ageController = TextEditingController();
  final _appearanceController = TextEditingController();
  final _historyController = TextEditingController();

  String? _selectedType;
  String? _selectedAlignment;

  final List<String> _types = ['Aliado', 'Comerciante', 'Vilão', 'Histórico', 'Incógnito'];
  final List<String> _alignments = [
    'Leal bom', 'Leal neutro', 'Leal mau', 'Neutro bom', 'Neutro', 'Neutro mau',
    'Caótico bom', 'Caótico neutro', 'Caótico mau'
  ];

  Future<void> _saveData() async {
    final campaign = _campaignController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    final type = _selectedType ?? '';
    final alignment = _selectedAlignment ?? '';
    final appearance = _appearanceController.text;
    final history = _historyController.text;

    if (campaign.isEmpty || type.isEmpty || alignment.isEmpty || appearance.isEmpty || history.isEmpty) {

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

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('characters').add({
          'userId': user.uid,
          'campaign': campaign,
          'age': age,
          'type': type,
          'alignment': alignment,
          'appearance': appearance,
          'history': history,
        });


        Navigator.pop(context);
      }
    } catch (e) {

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao salvar dados. Tente novamente.'),
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
              'Nome do Personagem',
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
                  child: _buildTextField(
                    controller: _campaignController,
                    label: 'Campanha',
                    hint: 'Nome da campanha',
                    isNumber: false,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    controller: _ageController,
                    label: 'Idade',
                    hint: 'Idade',
                    isNumber: true,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      hintText: 'Tipo',
                      filled: true,
                      fillColor: Color(0xFFFFF9EA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedAlignment,
                    decoration: InputDecoration(
                      hintText: 'Alinhamento',
                      filled: true,
                      fillColor: Color(0xFFFFF9EA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    controller: null,
                    label: 'Naturalidade',
                    hint: 'Local de origem',
                    isNumber: false,
                  ),
                ),
              ],
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
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFFFA61F),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.school, size: 30),
              onPressed: () {},
              color: Colors.white,
              iconSize: 30,
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.khanda, size: 30),
              onPressed: () {},
              color: Colors.white,
              iconSize: 30,
            ),
            IconButton(
              icon: Icon(Icons.healing, size: 30),
              onPressed: () {},
              color: Colors.white,
              iconSize: 30,
            ),
            IconButton(
              icon: Icon(Icons.backpack, size: 30),
              onPressed: () {},
              color: Colors.white,
              iconSize: 30,
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
}
