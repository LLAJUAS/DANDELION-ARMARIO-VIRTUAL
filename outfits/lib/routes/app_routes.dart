import 'package:flutter/material.dart';
import 'package:outfits/screens/screens.dart';
// Asegúrate de crear esta pantalla

class AppRoutes {
  static const initialRoute = '/'; // Ahora el splash es la ruta inicial

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      '/': (_) => const SplashVideoScreen(),       // Video splash
      'home': (_) => HomeScreen(),
      'registro': (_) => Registro(),
      'login': (_) => Login(),
      'prueba': (context) => PruebaScreen(),
      
      'agregar': (context) => AgregarPrendaFoto(),
      'datosprenda': (context) => DatosPrenda(imagenes: []),
      
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => HomeScreen(),
    );
  }
}
