import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/presencesProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EtudiantDetails extends StatelessWidget {
  final Map<String, dynamic> etudiant;

  const EtudiantDetails({Key? key, required this.etudiant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _presences = Provider.of<PresenceProvider>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                _presences.videCreationRapportEtudiant();
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.revenir),
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(etudiant['image_url']),
            ),
            const SizedBox(height: 16),
            Text(
              '${etudiant['prenom']} ${etudiant['nom']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.matricule}: ${etudiant['matricule']}',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 4),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _presences.rapportEtudiant.length,
              itemBuilder: (context, index) {
                final presence = _presences.rapportEtudiant[index];
                return ListTile(
                  title: Text(
                    presence['Num_Cours'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    presence['Jour'] + ': ' + presence['Duree'].toString() + ' minutes',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
