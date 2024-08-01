import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      setState(() {
        _userName = userDoc['username'];
      });
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3CA8CF),
      appBar: AppBar(
        backgroundColor: Color(0xFF3CA8CF),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/user.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              _userName,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                color: Color(0xFFFFF9EA),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/creation_screen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFF9EA),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Criar NPC',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 32,
                    color: Color(0xFFFFA61F),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/collection_screen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFF9EA),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Minhas criações',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 32,
                    color: Color(0xFFFFA61F),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFF9EA),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 32,
                    color: Color(0xFFFFA61F),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
