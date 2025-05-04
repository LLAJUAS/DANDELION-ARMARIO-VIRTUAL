import 'package:flutter/material.dart';
import 'package:outfits/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      'home': (_) => HomeScreen(),
      'registro': (_) => Registro(),
      'login': (_) => Login(),
       'prueba': (context) => PruebaScreen(),
      'armario': (context) => Armario(),
      'agregar': (context) => AgregarPrendaFoto(),
      'datosprenda': (context) => DatosPrenda(imagenes: []),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => HomeScreen()
    );
  }
}
