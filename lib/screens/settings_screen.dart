import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paramètres'), backgroundColor: Colors.blueAccent),
      body: ListView(
        children: [
          _buildSectionHeader('Personnalisation'),
          _buildDropdownTile(Icons.color_lens, 'Thème', ['Clair', 'Sombre']),
          _buildDropdownTile(Icons.font_download, 'Police', ['Roboto', 'Arial', 'Times']),
          _buildSliderTile(Icons.text_fields, 'Taille du texte', 14, 30),
          Divider(),
          _buildSectionHeader('Notifications'),
          SwitchListTile(secondary: Icon(Icons.notifications, color: Colors.orange), title: Text('Activer les notifications'), value: true, onChanged: (val) {}),
          _buildDropdownTile(Icons.music_note, 'Son de notification', ['Classique', 'Pop', 'Silence']),
          Divider(),
          _buildSectionHeader('Compte'),
          ListTile(leading: Icon(Icons.person, color: Colors.green), title: Text('Modifier profil'), onTap: () {}),
          ListTile(leading: Icon(Icons.lock, color: Colors.redAccent), title: Text('Changer mot de passe'), onTap: () {}),
          ElevatedButton.icon(
            icon: Icon(Icons.logout),
            label: Text('Déconnexion'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
          Divider(),
          _buildSectionHeader('À propos'),
          ListTile(leading: Icon(Icons.info, color: Colors.blue), title: Text('Version 1.0.0')),
          ListTile(leading: Icon(Icons.policy, color: Colors.purple), title: Text('Politique de confidentialité'), onTap: () {}),
          ListTile(leading: Icon(Icons.support_agent, color: Colors.teal), title: Text('Contact support'), onTap: () {}),
        ],
      ),
    );
  }