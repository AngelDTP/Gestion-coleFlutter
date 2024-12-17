import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/calendarProvider.dart';
import 'package:tpfinal_angel/Widgets/AjoutPeriodesForm.dart';

class AjoutPeriodesClasse extends StatefulWidget {
  const AjoutPeriodesClasse({super.key});

  @override
  State<AjoutPeriodesClasse> createState() => _AjoutPeriodesClasseState();
}

class _AjoutPeriodesClasseState extends State<AjoutPeriodesClasse> {
  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: calendarProvider.loadSchoolCalendar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child:const Padding(
              padding: EdgeInsets.all(8.0),
              child: AjoutPeriodesForm(),
            ),
          );
        },
      ),
    );
  }
}
