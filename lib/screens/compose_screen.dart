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

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouveau message'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$value sélectionné')));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Programmer l\'envoi',
                child: Row(children: [Icon(Icons.schedule, color: Colors.blue), SizedBox(width: 8), Text('Programmer l\'envoi')]),
              ),
              PopupMenuItem(
                value: 'Mode confidentiel',
                child: Row(children: [Icon(Icons.lock, color: Colors.green), SizedBox(width: 8), Text('Mode confidentiel')]),
              ),
              PopupMenuItem(
                value: 'Annuler',
                child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Annuler')]),
              ),
            ],
          ),
        ],
      ),