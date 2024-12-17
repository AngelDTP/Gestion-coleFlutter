import 'package:flutter/material.dart';
import 'package:tpfinal_angel/Widgets/AffichageEtudiantsCours.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PagePresence extends StatefulWidget {
  const PagePresence({super.key});

  @override
  State<PagePresence> createState() => _PagePresenceState();
}

class _PagePresenceState extends State<PagePresence> {
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.presenceTitle),
        backgroundColor: const Color.fromARGB(206, 205, 60, 167),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/calendrier');
            },
          ),
        ],
      ),
      body: const Center(
        child: AffichageEtudiantsCours(),
      ),
    );
  }
}