import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal_angel/Pages/CalendrierScolaire.dart';
import 'package:tpfinal_angel/Pages/Ecran_Authentification.dart';
import 'package:tpfinal_angel/Pages/ModificationsDeDonnes.dart';
import 'package:tpfinal_angel/Pages/PageGestionClasses.dart';
import 'package:tpfinal_angel/Pages/PagePresences.dart';
import 'package:tpfinal_angel/Pages/RechercheEtudiant.dart';
import 'package:tpfinal_angel/Pages/UserPAge.dart';
import 'package:tpfinal_angel/Providers/ClassProvider.dart';
import 'package:tpfinal_angel/Providers/calendarProvider.dart';
import 'package:tpfinal_angel/Providers/presencesProvider.dart';
import 'package:tpfinal_angel/Providers/studentSearchProvider.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';
import 'package:tpfinal_angel/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => userProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => StudentSearchProvider()),
        ChangeNotifierProvider(create: (context) => ClassProvider()),
        ChangeNotifierProvider(create: (context) => PresenceProvider()),
      ],
      child: MaterialApp(
        routes: {
          '/Acceuil': (context) => const EcranAuthentification(),
          '/user': (context) => const PageUtilisateur(),
          '/calendrier': (context) => const CalendrierScolaire(),
          '/modifications': (context) => const ModifsDonneesUser(),
          '/recherche': (context) => const RechercheEtudiant(),
          '/gestionClasse': (context) => PageGestionClasses(),
          '/gestionPresences': (context) => const PagePresence(),
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
        ],
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Center(child: Text(AppLocalizations.of(context)!.errorText));
            }

            if (snapshot.hasData) {
              return const PageUtilisateur();
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.appTitle),
                centerTitle: true,
                backgroundColor: const Color.fromARGB(206, 205, 60, 167),
              ),
              body: const Center(
                child: EcranAuthentification(),
              ),
            );
          },
        ),
      ),
    );
  }
}
