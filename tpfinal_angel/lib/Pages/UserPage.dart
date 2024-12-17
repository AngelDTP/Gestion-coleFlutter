import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:tpfinal_angel/Widgets/InfoUser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PageUtilisateur extends StatefulWidget {
  const PageUtilisateur({super.key});

  @override
  State<PageUtilisateur> createState() => _PageUtilisateurState();
}

class _PageUtilisateurState extends State<PageUtilisateur> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    final _user = Provider.of<userProvider>(context, listen: false);
 
    return FutureBuilder(
      future: _user.getUserDataByEmail(_user.getEmail),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } 
        
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.appTitle),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(206, 205, 60, 167),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.black),
                onPressed: () {
                  _user.logout();
                },
              ),
            ],
          ),
          body: const AffichageInformationsUtilisateur(),
          floatingActionButton: _user.isAdmin() || _user.isTeacher() ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/recherche');
                },
                child: const Icon(Icons.search, color: Colors.black),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/gestionClasse');
                },
                child: const Icon(Icons.school_outlined, color: Colors.black),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/gestionPresences');
                },
                child: const Icon(Icons.accessibility_new_outlined, color: Colors.black),
              )
            ],
          ): null,
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month_outlined, color: Colors.black),
                label: AppLocalizations.of(context)!.calendrier,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.edit, color: Colors.black),
                label: AppLocalizations.of(context)!.modifications,
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.pushNamed(context, '/calendrier');
              }
              if (index == 1) {
                Navigator.pushNamed(context, '/modifications');
              }
            },
          ),
        );
      }
    );
  }
}
