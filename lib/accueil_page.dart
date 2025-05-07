import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ajouter_contact_page.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredContacts = [];

  List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('contacts');
    if (jsonString != null) {
      final List<dynamic> decoded = json.decode(jsonString);
      final loaded =
          decoded.map<Map<String, String>>((item) {
            return {
              'prenom': item['prenom'] as String,
              'numero': item['numero'] as String,
            };
          }).toList();

      setState(() {
        contacts = loaded;
        contacts.sort((a, b) => a['prenom']!.compareTo(b['prenom']!));
        _filteredContacts = List.from(contacts);
      });
    }
  }

  void _filtrerContacts(String query) {
    setState(() {
      _filteredContacts =
          contacts
              .where(
                (contact) => contact['prenom']!.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  void _supprimerContact(Map<String, String> contact) {
    setState(() {
      contacts.remove(contact);
      _filteredContacts = List.from(contacts);
    });
    _sauvegarderContacts();
  }

  void _ajouterContact(Map<String, String> contact) {
    setState(() {
      contacts.add(contact);
      contacts.sort((a, b) => a['prenom']!.compareTo(b['prenom']!));
      _filteredContacts = List.from(contacts);
    });
    _sauvegarderContacts();
  }

  void _sauvegarderContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(contacts);
    await prefs.setString('contacts', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Carnet de Contacts")),
      body: Column(
        children: [
          SizedBox(height: 16),
          Image.asset('assets/logo.png', height: 100),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un prénom...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filtrerContacts,
            ),
          ),
          Expanded(
            child:
                _filteredContacts.isEmpty
                    ? Center(child: Text("Aucun contact enregistré"))
                    : ListView.builder(
                      itemCount: _filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = _filteredContacts[index];
                        return ListTile(
                          title: Text(contact['prenom'] ?? ''),
                          subtitle: Text(contact['numero'] ?? ''),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              final realIndex = contacts.indexOf(contact);
                              _supprimerContact(contact);
                              _filtrerContacts(_searchController.text);
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Map<String, String>>(
            context,
            MaterialPageRoute(builder: (_) => AjouterContactPage()),
          );
          if (result != null) {
            _ajouterContact(result);
            _filtrerContacts(
              _searchController.text,
            ); // met à jour l'affichage filtré
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
