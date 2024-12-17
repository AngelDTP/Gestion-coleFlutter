import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AffichageInformationsUtilisateur extends StatelessWidget {
  const AffichageInformationsUtilisateur({super.key});

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<userProvider>(context);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_user.getImageUrl.isNotEmpty)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_user.getImageUrl),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.matricule}: ${_user.getMatricule}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(
              '${AppLocalizations.of(context)!.prenom}: ${_user.getPrenom}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.nom}: ${_user.getNom}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${_user.getEmail}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
