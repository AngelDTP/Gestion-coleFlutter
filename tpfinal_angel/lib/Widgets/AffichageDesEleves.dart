import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/ClassProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AffichageDesEleves extends StatelessWidget {
  final List<Map<String, dynamic>> students;

  const AffichageDesEleves({Key? key, required this.students}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              classProvider.changementCours();
            }, 
            child: Text(AppLocalizations.of(context)!.revenir)
          ),
          ElevatedButton(
            onPressed: () {
              classProvider.ajouterEtudiantsCours();
            },
            child: Text(AppLocalizations.of(context)!.enregistrerChangements),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];

                return GestureDetector(
                  onTap: () {
                    classProvider.toggleEtudiantCours(student['email']);
                  },
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        student['email'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${AppLocalizations.of(context)!.matricule}: ${student['matricule']}'),
                          Text('${AppLocalizations.of(context)!.prenom}: ${student['prenom']}'),
                          Text('${AppLocalizations.of(context)!.nom}: ${student['nom']}'),
                        ],
                      ),
                      tileColor: classProvider.getEtudiantsCours().contains(student['email']) ? Colors.green : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
