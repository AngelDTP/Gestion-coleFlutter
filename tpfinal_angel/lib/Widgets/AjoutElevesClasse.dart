import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/ClassProvider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:tpfinal_angel/Widgets/RecupEleves.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AjoutElevesClasse extends StatefulWidget {
  const AjoutElevesClasse({super.key});

  @override
  State<AjoutElevesClasse> createState() => _AjoutElevesClasseState();
}

class _AjoutElevesClasseState extends State<AjoutElevesClasse> {
  final _formKey = GlobalKey<FormState>();
  String _nomClasse = '';
  num _numeroClasse = 0;

  void _submitForm(ClassProvider classProvider, userProvider user) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var classData = await classProvider.recupererClasse(_nomClasse, _numeroClasse, user);
      if (classData != null) {
        setState(() {
          classProvider.setEnseignant(classData['Enseignant']);
          classProvider.setNomCours(classData['Num_Cours']);
          classProvider.setNumeroClasse(classData['Num_Groupe']);
          classProvider.setPeriodeCours(classData['Periode_Cours']);
          classProvider.setEtudiants(classData['Etudiants']);
          classProvider.setIsFound(true);
        });

        classProvider.setSearchMade(true);
      } else {
        setState(() {
          classProvider.setIsFound(false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var classProvider = Provider.of<ClassProvider>(context);
    final _user = Provider.of<userProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!classProvider.isFound && !classProvider.getSearchMade)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    key: const ValueKey('nomClasse'),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.nomClasse,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.nomClasseContraintes;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nomClasse = value!;
                    },
                  ),
                ),
              if (!classProvider.isFound && !classProvider.getSearchMade)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    key: const ValueKey('numeroClasse'),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.numeroGroupe,
                    ),
                    validator: (value) {
                      if (value!.isEmpty || num.parse(value) <= 0) {
                        return AppLocalizations.of(context)!.numeroGroupeContraintes;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _numeroClasse = num.parse(value!);
                    },
                  ),
                ),
              if (!classProvider.isFound && !classProvider.getSearchMade)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _submitForm(classProvider, _user),
                    child: Text(AppLocalizations.of(context)!.afficherEleves),
                  ),
                ),
              if (!classProvider.isFound && !classProvider.getSearchMade)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      classProvider.retourDebut();
                    },
                    child: Text(AppLocalizations.of(context)!.revenir),
                  ),
                ),
              Consumer<ClassProvider>(
                builder: (context, classProvider, child) {
                  return classProvider.isFound && classProvider.getSearchMade
                      ? const RecupEleves()
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
