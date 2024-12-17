import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/ClassProvider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:tpfinal_angel/Widgets/AjoutClasse.dart';
import 'package:tpfinal_angel/Widgets/AjoutElevesClasse.dart';
import 'package:tpfinal_angel/Widgets/AjoutPeriodesClasse.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PageGestionClasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final _user = Provider.of<userProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gestionClassesTitle),
        backgroundColor: const Color.fromARGB(206, 205, 60, 167),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: classProvider.getModeDePage == '' ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_user.isAdmin())
                ElevatedButton(
                  onPressed: () {
                    classProvider.setModeDePage('ajoutClasse');
                  },
                  child: Text(AppLocalizations.of(context)!.ajouterClasse),
                ),
              if (_user.isAdmin())
                const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  classProvider.setModeDePage('ajoutPeriodes');
                },
                child: Text(AppLocalizations.of(context)!.ajouterPeriodes),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  classProvider.setModeDePage('ajoutEleves');
                },
                child: Text(AppLocalizations.of(context)!.ajouterEtudiants),
              ),
            ],
          ),
        ) : Center(
          child: classProvider.getModeDePage == 'ajoutClasse' ? const AjoutClasse() :
                 classProvider.getModeDePage == 'ajoutPeriodes' ? const AjoutPeriodesClasse() :
                 classProvider.getModeDePage == 'ajoutEleves' ? const AjoutElevesClasse() : null,
        ),
      ),
    );
  }
}
