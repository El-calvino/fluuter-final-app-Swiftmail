import 'package:flutter/material.dart';
import '../db/email_database.dart';
import 'compose_screen.dart';
import 'settings_screen.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}


class _InboxScreenState extends State<InboxScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boîte de réception'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/inbox_bg.jpg'), // Image locale
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: EmailDatabase.instance.getEmails(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            final emails = snapshot.data!
                .where((email) => email['subject'].toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            if (emails.isEmpty) return Center(child: Text('Aucun message'));
            return ListView.builder(
              itemCount: emails.length,
              itemBuilder: (context, index) {
                final email = emails[index];
                return Dismissible(
                  key: ValueKey(email['id']),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.archive, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    await EmailDatabase.instance.deleteEmail(email['id']);
                    setState(() {});
                  },
                  child: Card(
                    color: Colors.white.withOpacity(0.9), // Pour lisibilité sur fond
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(Icons.email)),
                      title: Text(email['subject'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(email['content'], maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(email['date'].substring(0, 10), style: TextStyle(fontSize: 12)),
                          Icon(Icons.star_border),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),