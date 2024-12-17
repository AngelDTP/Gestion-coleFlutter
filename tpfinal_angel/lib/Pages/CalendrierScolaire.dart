import 'package:flutter/material.dart';
import 'package:tpfinal_angel/Widgets/DatesCalendrier.dart';

class CalendrierScolaire extends StatefulWidget {
  const CalendrierScolaire({super.key});

  @override
  State<CalendrierScolaire> createState() => _CalendrierScolaireState();
}

class _CalendrierScolaireState extends State<CalendrierScolaire> {
  @override
  Widget build(BuildContext context) {
    return const DatesCalendrier();
  }
}
