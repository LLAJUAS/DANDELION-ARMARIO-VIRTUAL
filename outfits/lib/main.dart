import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outfits/routes/app_routes.dart';
import 'package:outfits/screens/screens.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDqBIfiyCM_JEthh60PRfBePq3BprFMfEk',
      appId: '1:152177659528:android:d124dedc9f249bf39dd93d',
      messagingSenderId: '152177659528',
      projectId: 'ropa-bb88f',
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute, // Esto seguirá dirigiendo al home como antes
      routes: AppRoutes.getAppRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      // Opcional: puedes agregar la página de login como una ruta nombrada en tu AppRoutes
    );
  }
}