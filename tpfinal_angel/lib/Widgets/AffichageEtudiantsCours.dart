import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/presencesProvider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:tpfinal_angel/Widgets/AffichageCoursDate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AffichageEtudiantsCours extends StatefulWidget {
  const AffichageEtudiantsCours({Key? key}) : super(key: key);

  @override
  State<AffichageEtudiantsCours> createState() => _AffichageEtudiantsCoursState();
}

class _AffichageEtudiantsCoursState extends State<AffichageEtudiantsCours> {
  late Future<List<Map<String, dynamic>>?> futureClasses;
  String journeeAffichage = '';

  @override
  void initState() {
    super.initState();
    final _user = Provider.of<userProvider>(context, listen: false);
    futureClasses = Provider.of<PresenceProvider>(context, listen: false).recupererClasse(_user.email, _user.role);
  }

  @override
  Widget build(BuildContext context) {
    final _presences = Provider.of<PresenceProvider>(context);
    journeeAffichage = _presences.todayDate;

    return FutureBuilder(
      future: futureClasses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return const AffichageCoursDate();
        } else {
          return Text(AppLocalizations.of(context)!.noDataFound);
        }
      },
    );
  }
}
