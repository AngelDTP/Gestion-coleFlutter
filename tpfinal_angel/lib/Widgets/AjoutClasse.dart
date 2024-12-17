import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/ClassProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AjoutClasse extends StatefulWidget {
  const AjoutClasse({super.key});

  @override
  State<AjoutClasse> createState() => _AjoutClasseState();
}

class _AjoutClasseState extends State<AjoutClasse> {
  final _key = GlobalKey<FormState>();
  String _nomClasse = '';
  num _numeroClasse = 0;
  var _selectedTeacher;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);

    return FutureBuilder(
      future: classProvider.getAllTeachers(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
      
        return Column(
          children: [
            Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton(
                    key: const ValueKey('teacherDropdown'),
                    hint:  Text(AppLocalizations.of(context)!.choisirEnseignant),
                    value: _selectedTeacher,
                    onChanged: (value) {
                      setState(() {
                        _selectedTeacher = value;
                      });
                    },
                    items: (snapshot.data as List<Map<String, dynamic>>).map((teacher) {
                      return DropdownMenuItem(
                        value: teacher['email'],
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(teacher['image_url']),
                            ),
                            const SizedBox(width: 10),
                            Text('${teacher['prenom']} ${teacher['nom']}'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    key: const ValueKey('nomClasse'),
                    keyboardType: TextInputType.text,
                    decoration:  InputDecoration(
                      labelText: AppLocalizations.of(context)!.nomClasse
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.nomClasseContraintes;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _nomClasse = value!;
                      });
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('numeroClasse'),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.numeroGroupe
                    ),
                    validator: (value) {
                      if (value!.isEmpty || num.parse(value) <= 0 ) {
                        return AppLocalizations.of(context)!.numeroGroupeContraintes;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _numeroClasse = num.parse(value!);
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        if (_selectedTeacher == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.choisirEnseignant),
                            ),
                          );
                          return;
                        }
                        _key.currentState!.save();
                        classProvider.creerClasse(_nomClasse, _numeroClasse, _selectedTeacher);
                        _nomClasse = '';
                        _numeroClasse = 0;
                        _selectedTeacher = null;
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.creerClasse),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      classProvider.setModeDePage('');
                    },
                    child: Text(AppLocalizations.of(context)!.revenir),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}