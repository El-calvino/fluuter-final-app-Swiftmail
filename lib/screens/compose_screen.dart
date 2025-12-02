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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/compose_bg.jpg'), // Image locale
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85), // Lisibilité sur fond
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                TextField(controller: toController, decoration: InputDecoration(labelText: 'À')),
                TextField(controller: fromController, decoration: InputDecoration(labelText: 'De')),
                TextField(controller: subjectController, decoration: InputDecoration(labelText: 'Sujet')),
                Expanded(child: TextField(controller: contentController, decoration: InputDecoration(labelText: 'Message'), maxLines: null)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.blue),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(leading: Icon(Icons.image, color: Colors.purple), title: Text('Photo')),
                              ListTile(leading: Icon(Icons.camera_alt, color: Colors.orange), title: Text('Caméra')),
                              ListTile(leading: Icon(Icons.folder, color: Colors.green), title: Text('Fichier')),
                              ListTile(leading: Icon(Icons.cloud, color: Colors.blueAccent), title: Text('Drive')),
                            ],
                          ),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.send),
                      label: Text('Envoyer'),
                      onPressed: _sendEmail,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
