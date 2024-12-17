import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModifsDonneesUser extends StatefulWidget {
  const ModifsDonneesUser({Key? key}) : super(key: key);

  @override
  State<ModifsDonneesUser> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ModifsDonneesUser> {
  final _formKey = GlobalKey<FormState>();
  var _matricule = '';
  var _nom = '';
  var _prenom = '';

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<userProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.modifTitle),
        backgroundColor: const Color.fromARGB(206, 205, 60, 167),
      ),
       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              TextFormField(
                key: const ValueKey('matricule'),
                initialValue: _user.getMatricule,
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
                initialValue: _user.getNom,
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
                initialValue: _user.getPrenom,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_matricule.isNotEmpty && _user.getMatricule != _matricule) {
                      _user.updateMatricule(_matricule);
                      _user.setMatricule(_matricule);
                    }
                    if (_nom.isNotEmpty && _user.getNom != _nom) {
                      _user.updateNom(_nom);
                      _user.setNom(_nom);
                    }
                    if (_prenom.isNotEmpty && _user.getPrenom != _prenom) {
                      _user.updatePrenom(_prenom);
                      _user.setPrenom(_prenom);
                    }
                  }
                },
                child: Text(AppLocalizations.of(context)!.modifInfosText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
