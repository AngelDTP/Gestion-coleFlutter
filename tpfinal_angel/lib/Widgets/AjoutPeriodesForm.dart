import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/ClassProvider.dart';
import 'package:tpfinal_angel/Providers/calendarProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';

class AjoutPeriodesForm extends StatefulWidget {
  const AjoutPeriodesForm({super.key});

  @override
  State<AjoutPeriodesForm> createState() => _AjoutPeriodesFormState();
}

class _AjoutPeriodesFormState extends State<AjoutPeriodesForm> {
  final _formKey = GlobalKey<FormState>();
  String _nomClasse = '';
  num _numeroClasse = 0;
  String jourCalendrier = '';
  String _tempsDebut = '';
  String _tempsFin = '';

  bool searchMade = false;
  
  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final _user = Provider.of<userProvider>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!classProvider.searchMade && !classProvider.isFound)
            TextFormField(
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
                setState(() {
                  _nomClasse = value!;
                });
              },
            ),
          if (!classProvider.searchMade && !classProvider.isFound)
            TextFormField(
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
                setState(() {
                  _numeroClasse = num.parse(value!);
                });
              },
            ),
          if (!classProvider.searchMade && !classProvider.isFound)
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  searchMade = true;
                  classProvider.recupererClasse(_nomClasse, _numeroClasse, _user);
                }
              },
              child: Text(AppLocalizations.of(context)!.rechercheClasse),
            ),
          if (classProvider.searchMade && classProvider.isFound)
            Column(
              children: [
                DropdownButtonFormField<String>(
                  key: const ValueKey('dateCours'),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.jour,
                  ),
                  value: jourCalendrier.isEmpty ? null : jourCalendrier,
                  items: calendarProvider.getCalendarSchoolDays().keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      jourCalendrier = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.jourContraintes;
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  key: const ValueKey('tempsDebut'),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.heureDebut,
                  ),
                  value: _tempsDebut.isEmpty ? null : _tempsDebut,
                  items: classProvider.getHeuresDebutPossibles().map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _tempsDebut = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || classProvider.verificationHeureDebut(_tempsDebut, _tempsFin)) {
                      return AppLocalizations.of(context)!.heureDebutContraintes;
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  key: const ValueKey('tempsFin'),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.heureFin,
                  ),
                  value: _tempsFin.isEmpty ? null : _tempsFin,
                  items: classProvider.getHeuresFinPossibles().map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _tempsFin = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || classProvider.verificationHeureFin(_tempsDebut, _tempsFin)) {
                      return AppLocalizations.of(context)!.heureFinContraintes;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      classProvider.ajouterPeriodeCours(_nomClasse, _numeroClasse, jourCalendrier, _tempsDebut, _tempsFin);
                      jourCalendrier = '';
                      _tempsDebut = '';
                      _tempsFin = '';
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.ajouterPeriode),
                ),
              ],
            ),
          if (classProvider.searchMade && !classProvider.isFound)
            ElevatedButton(
              onPressed: () {
                classProvider.setSearchMade(false);
                setState(() {
                  _nomClasse = '';
                  _numeroClasse = 0;
                });
              },
              child: Text(AppLocalizations.of(context)!.reessayer),
            ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              _nomClasse = '';
              _numeroClasse = 0;
              classProvider.changementCours();
              classProvider.setModeDePage('');
            },
            child: Text(AppLocalizations.of(context)!.revenir),
          ),
        ],
      ),
    );
  }
}
