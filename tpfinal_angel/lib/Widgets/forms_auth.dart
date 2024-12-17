import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:tpfinal_angel/Widgets/imagePicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class form_auth extends StatefulWidget {
  final void Function(
    String matricule,
    String nom,
    String prenom,
    String email,
    String password,
    bool isLoggedIn,
    XFile? image,
    String role,
  ) enregistrerUtilisateur;
  const form_auth(this.enregistrerUtilisateur, {super.key});

  @override
  State<form_auth> createState() => _form_authState();
}

class _form_authState extends State<form_auth> {
  final _key = GlobalKey<FormState>();
  String _matricule = '';
  String _nom = '';
  String _prenom = '';
  String _email = '';
  String _password = '';
  final String _role = 'Etudiant';
  var _isLoggedIn = true;
  var _myUserImageFile;

  void _myPickImage(XFile pickedImage) {
    _myUserImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _key.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (!_isLoggedIn && _myUserImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.svpAjoutImage),
        ),
      );
      return;
    }

    if (isValid ?? false) {
      _key.currentState?.save();

      print(_matricule);
      print(_nom);
      print(_prenom);
      print(_email);

      widget.enregistrerUtilisateur(
        _matricule.trim(),
        _nom.trim(),
        _prenom.trim(),
        _email,
        _password,
        _isLoggedIn,
        _myUserImageFile,
        _role,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<userProvider>(context);

    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView (
          child: Padding (
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLoggedIn) 
                    UserImagePicker(_myPickImage),
                  if (!_isLoggedIn)
                    TextFormField(
                      key: const ValueKey('matricule'),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.matricule,
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||value.length != 7) {
                          return AppLocalizations.of(context)!.contraintesMatricule;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _matricule = value!;
                      },
                    ),
                  if (!_isLoggedIn)
                    TextFormField(
                      key: const ValueKey('nom'),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.nom
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.contraintesNom;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nom = value!;
                      },
                    ),
                  if (!_isLoggedIn)
                    TextFormField(
                      key: const ValueKey('prenom'),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.prenom
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.contraintesPrenom;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _prenom = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email'
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@') || !value.contains('.')) {
                        return AppLocalizations.of(context)!.emailContraintes;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.mdp,
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return AppLocalizations.of(context)!.mdpContraintes;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 12
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submit();
                      _user.setEmail(_email);
                    },
                    child: Text(_isLoggedIn ? AppLocalizations.of(context)!.connexion : AppLocalizations.of(context)!.inscription),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoggedIn = !_isLoggedIn;
                      });
                    },
                    child:
                        Text(_isLoggedIn ? AppLocalizations.of(context)!.creerCompte : AppLocalizations.of(context)!.dejaUnCompte),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}