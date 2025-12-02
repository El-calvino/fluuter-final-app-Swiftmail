import 'package:flutter/material.dart';
import '../db/email_database.dart';

class ComposeScreen extends StatefulWidget {
  final VoidCallback onSend;
  ComposeScreen({required this.onSend});

  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final toController = TextEditingController();
  final fromController = TextEditingController(text: 'moi@swiftmail.com'); // Exemple statique
  final subjectController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    toController.dispose();
    fromController.dispose();
    subjectController.dispose();
    contentController.dispose();
    super.dispose();
  }

    Future<void> _sendEmail() async {
    if (subjectController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    await EmailDatabase.instance.insertEmail(
      subjectController.text,
      contentController.text,
    );

    widget.onSend();
    Navigator.pop(context);
  }
