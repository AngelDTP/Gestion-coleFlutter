import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/ClassProvider.dart';
import 'package:tpfinal_angel/Widgets/AffichageDesEleves.dart';

class RecupEleves extends StatefulWidget {
  const RecupEleves({Key? key}) : super(key: key);

  @override
  _RecupElevesState createState() => _RecupElevesState();
}

class _RecupElevesState extends State<RecupEleves> {
  @override
  void initState() {
    super.initState();
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    if (classProvider.getAllStudentsList.isEmpty) {
      classProvider.getAllStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: classProvider.getAllStudentsList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : AffichageDesEleves(students: classProvider.getAllStudentsList),
    );
  }
}
