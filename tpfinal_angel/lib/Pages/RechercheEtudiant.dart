import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/studentSearchProvider.dart';
import 'package:tpfinal_angel/Widgets/AffichageEtudiantRecherche.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RechercheEtudiant extends StatefulWidget {
  const RechercheEtudiant({super.key});

  @override
  State<RechercheEtudiant> createState() => _RechercheEtudiantState();
}

class _RechercheEtudiantState extends State<RechercheEtudiant> {
  final _formKey = GlobalKey<FormState>();
  var searchMade = false;
  var _matricule = '';

  @override
  Widget build(BuildContext context) {
    var _studentRecherche = Provider.of<StudentSearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rechercheTitle),
        backgroundColor: const Color.fromARGB(206, 205, 60, 167),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                key: const ValueKey('Recherche'),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.matricule,
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length != 7) {
                    return AppLocalizations.of(context)!.contraintesMatricule;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _matricule = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      searchMade = true;
                    });
                    _studentRecherche.getUserByMatricule(_matricule);
                  }
                },
                child: Text(AppLocalizations.of(context)!.chercherEtudiant),
              ),
              const SizedBox(height: 20),
              if (searchMade) 
                _studentRecherche.getIsFound() 
                ? const AffichageEtudiantRecherche() 
                : Text(AppLocalizations.of(context)!.etudiantPasTrouve),
            ],
          ),
        ),
      ),
    );
  }
}
