import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/presencesProvider.dart';
import 'package:tpfinal_angel/Widgets/RapportEtudiant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AffichageCoursDate extends StatefulWidget {
  const AffichageCoursDate({Key? key}) : super(key: key);

  @override
  State<AffichageCoursDate> createState() => _AffichageCoursDateState();
}

class _AffichageCoursDateState extends State<AffichageCoursDate> {
  late TextEditingController dateController;
  String modeAffichage = 'toutEleves';

  @override
  void initState() {
    super.initState();
    final _presences = Provider.of<PresenceProvider>(context, listen: false);
    dateController = TextEditingController(text: _presences.todayDate);
  }

  @override
  Widget build(BuildContext context) {
    final _presences = Provider.of<PresenceProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                dateController.text = value;
              });
            },
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _presences.getClassesEnseignant.length,
                itemBuilder: (context, index) {
                  var course = _presences.classesEnseignant[index];
                  var periodesCours = course['Periode_Cours'] as List<dynamic>;

                  bool containsJournee = periodesCours.any((periode) => periode['Jour'] == dateController.text);

                  if (containsJournee) {
                    return ListTile(
                      title: Text(
                        '${course['Num_Cours']} - Gr:${course['Num_Groupe']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: course['Etudiants'].length,
                            itemBuilder: (context, indexStudent) {
                              var emailEtudiant = course['Etudiants'][indexStudent];
                              var etudiant = _presences.getEtudiantSelonEmail(emailEtudiant);

                              return modeAffichage == 'toutEleves' ||
                                      (modeAffichage == 'Presents' &&
                                          _presences.verificationPresent(etudiant['email'], course['Num_Cours'], dateController.text)) ||
                                      (modeAffichage == 'Absents' &&
                                          !_presences.verificationPresent(etudiant['email'], course['Num_Cours'], dateController.text))
                                  ? GestureDetector(
                                      onHorizontalDragStart: (details) {
                                        _presences.marquerPresence(etudiant['email'], course['Num_Cours'], dateController.text);
                                        setState(() {});
                                      },
                                      onTap: () {
                                        _presences.creationRapportEtudiant(etudiant['email']);
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: EtudiantDetails(etudiant: etudiant),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(etudiant['image_url']),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${etudiant['prenom']} ${etudiant['nom']}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${AppLocalizations.of(context)!.matricule}: ${etudiant['matricule']}',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                if (_presences.verificationPresent(etudiant['email'], course['Num_Cours'], dateController.text))
                                                  Text(
                                                    AppLocalizations.of(context)!.present,
                                                    style: TextStyle(
                                                      color: Colors.green[700],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                if (!_presences.verificationPresent(etudiant['email'], course['Num_Cours'], dateController.text))
                                                  Text(
                                                    'Absent',
                                                    style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (modeAffichage != 'toutEleves')
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    modeAffichage = 'toutEleves';
                  });
                },
                tooltip: 'Tout Élèves',
                child: const Icon(Icons.people),
              ),
            if (modeAffichage != 'Presents')
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    modeAffichage = 'Presents';
                  });
                },
                tooltip: 'Élèves Présents',
                child: const Icon(Icons.person_add),
              ),
            if (modeAffichage != 'Absents')
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    modeAffichage = 'Absents';
                  });
                },
                tooltip: 'Élèves Absents',
                child: const Icon(Icons.person_off),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }
}
