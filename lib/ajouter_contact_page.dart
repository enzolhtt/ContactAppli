import 'package:flutter/material.dart';

class AjouterContactPage extends StatefulWidget {
  @override
  _AjouterContactPageState createState() => _AjouterContactPageState();
}

class _AjouterContactPageState extends State<AjouterContactPage> {
  final prenomController = TextEditingController();
  final numeroController = TextEditingController();

  bool get _champsRemplis =>
      prenomController.text.isNotEmpty && numeroController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un contact")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: prenomController,
              decoration: InputDecoration(labelText: "Prénom"),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: numeroController,
              decoration: InputDecoration(labelText: "Numéro"),
              keyboardType: TextInputType.phone,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _champsRemplis
                      ? () {
                        Navigator.pop(context, {
                          'prenom': prenomController.text,
                          'numero': numeroController.text,
                        });
                      }
                      : null,
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
