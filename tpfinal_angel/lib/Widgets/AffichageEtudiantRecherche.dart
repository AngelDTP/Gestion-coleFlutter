import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/studentSearchProvider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AffichageEtudiantRecherche extends StatefulWidget {
  const AffichageEtudiantRecherche({super.key});

  @override
  State<AffichageEtudiantRecherche> createState() => _AffichageEtudiantRechercheState();
}

class _AffichageEtudiantRechercheState extends State<AffichageEtudiantRecherche> {
  var modeModifs = false;

  final _formKey = GlobalKey<FormState>();
  var _matricule = '';
  var _nom = '';
  var _prenom = '';
  var _role = '';

  Widget FormationChamps(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label, style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value, style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _studentRecherche = Provider.of<StudentSearchProvider>(context);
    var _user = Provider.of<userProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          if (_studentRecherche.getImageUrl.isNotEmpty && !modeModifs)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_studentRecherche.getImageUrl),
                backgroundColor: Colors.grey[300],
              ),
            ),
          const SizedBox(height: 20),
          if (!modeModifs)
            FormationChamps('${AppLocalizations.of(context)!.nom}:', _studentRecherche.getNom),
          if (!modeModifs)
            FormationChamps('${AppLocalizations.of(context)!.prenom}:', _studentRecherche.getPrenom),
          if (!modeModifs)
            FormationChamps('${AppLocalizations.of(context)!.matricule}:', _studentRecherche.getMatricule),
          if (!modeModifs)
            FormationChamps('Email:', _studentRecherche.getEmail),
          if (modeModifs)
          Form(
            key: _formKey, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (_studentRecherche.getImageUrl.isNotEmpty)
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_studentRecherche.getImageUrl),
                    ),
                  ),
                TextFormField(
                  key: const ValueKey('matricule'),
                  initialValue: _studentRecherche.getMatricule,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.matricule
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
                TextFormField(
                  key: const ValueKey('nom'),
                  initialValue: _studentRecherche.getNom,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.nom
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.contraintesNom;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _nom = value;
                    });
                  },
                ),
                TextFormField(
                  key: const ValueKey('prenom'),
                  initialValue: _studentRecherche.getPrenom,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.prenom
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.contraintesPrenom;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _prenom = value;
                    });
                  },
                ),
                if (_user.isAdmin())
                  TextFormField(
                    key: const ValueKey('role'),
                    initialValue: _studentRecherche.getRole,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.role
                    ),
                    validator: (value) {
                      if (value!.isEmpty || (value != 'Enseignant' && value != 'Etudiant' && value != 'Administrateur')) {
                        return AppLocalizations.of(context)!.roleConstraints;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _role = value;
                      });
                    },
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_matricule.isNotEmpty && _studentRecherche.getMatricule != _matricule) {
                        _studentRecherche.updateMatricule(_matricule);
                        _studentRecherche.setMatricule(_matricule);
                      }
                      if (_nom.isNotEmpty && _studentRecherche.getNom != _nom) {
                        _studentRecherche.updateNom(_nom);
                        _studentRecherche.setNom(_nom);
                      }
                      if (_prenom.isNotEmpty && _studentRecherche.getPrenom != _prenom) {
                        _studentRecherche.updatePrenom(_prenom);
                        _studentRecherche.setPrenom(_prenom);
                      }
                      if (_role.isNotEmpty && _studentRecherche.getRole != _role) {
                        _studentRecherche.updateRole(_role);
                        _studentRecherche.setRole(_role);
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.enregistrerChangements),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                modeModifs = !modeModifs;
              });
            },
            child: Text(modeModifs == true ? AppLocalizations.of(context)!.modeConsultation: AppLocalizations.of(context)!.modeModifications),
          ),
        ],
      ),
    );
  }
}