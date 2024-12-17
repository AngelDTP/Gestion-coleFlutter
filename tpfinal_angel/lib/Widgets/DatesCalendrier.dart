import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/calendarProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatesCalendrier extends StatefulWidget {
  const DatesCalendrier({Key? key}) : super(key: key);

  @override
  _DatesCalendrierState createState() => _DatesCalendrierState();
}

class _DatesCalendrierState extends State<DatesCalendrier> {
  late Future<Map<String, dynamic>> _calendarFuture;
  late Map<String, dynamic> _calendarData;

  // Créer un GlobalKey pour le Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _calendarFuture = Provider.of<CalendarProvider>(context, listen: false).loadSchoolCalendar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calendrierTitle),
        backgroundColor: const Color.fromARGB(206, 205, 60, 167),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(206, 205, 60, 167),
              ),
              child: Text(
                AppLocalizations.of(context)!.legendeCouleurs,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.conge),
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.green),
              title: Text(AppLocalizations.of(context)!.jourTP),
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.blue),
              title: Text(AppLocalizations.of(context)!.dateLimiteAbandon),
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.yellow),
              title: Text(AppLocalizations.of(context)!.evaluationUniformeFR),
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.orange),
              title: Text(AppLocalizations.of(context)!.evaluationCommune),
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.purple),
              title: Text(AppLocalizations.of(context)!.portesOuvertes),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _calendarFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            _calendarData = snapshot.data!;
            var dates = _calendarData.entries.toList();
            return ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                var date = dates[index].key;
                var details = dates[index].value;

                bool nouvSemaine = index > 0 &&
                    details['semaine'] != null &&
                    dates[index - 1].value['semaine'] != null &&
                    details['semaine'] > dates[index - 1].value['semaine'];

                return Column(
                  children: [
                    if (nouvSemaine) const Divider(height: 20, thickness: 2, color: Colors.black),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          date,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 1),
                            Text(
                              '${AppLocalizations.of(context)!.semaine}: ${details['semaine'] ?? 'N/A'}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '${AppLocalizations.of(context)!.jour}: ${details['jour_semaine'] == 1 ? 'Dimanche' :
                                      details['jour_semaine'] == 2 ? 'Lundi' :
                                      details['jour_semaine'] == 3 ? 'Mardi' :
                                      details['jour_semaine'] == 4 ? 'Mercredi' :
                                      details['jour_semaine'] == 5 ? 'Jeudi' :
                                      details['jour_semaine'] == 6 ? 'Vendredi' :
                                      details['jour_semaine'] == 7 ? 'Samedi' :
                                      'N/A'}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (details['special'] != null && details['special'] != '')
                              ...[
                                const SizedBox(height: 1),
                                Text(
                                  'Special: ${details['special'] == "C" ? 'Congé' :
                                            details['special'] == "TP" ? 'Jour TP' :
                                            details['special'] == "A" ? 'Date limite d\'abandon' :
                                            details['special'] == "EUF" ? 'Évaluation uniforme de Français' :
                                            details['special'] == "EC" ? 'Évaluation commune' :
                                            details['special'] == "PO" ? 'Événement portes ouvertes' :
                                            null }',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                          ],
                        ),
                        tileColor: details['special'] == "C" ? Colors.red :
                                  details['special'] == "TP" ? Colors.green :
                                  details['special'] == "A" ? Colors.blue :
                                  details['special'] == "EUF" ? Colors.yellow :
                                  details['special'] == "EC" ? Colors.orange :
                                  details['special'] == "PO" ? Colors.purple :
                                  null,
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return Text(AppLocalizations.of(context)!.noDataFound);
          }
        },
      ),
    );
  }
}
