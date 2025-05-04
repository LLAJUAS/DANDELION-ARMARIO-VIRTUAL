import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _usuarios = FirebaseFirestore.instance.collection(
    'USUARIOS',
  );

  // Registrar usuario
  Future<void> registrarUsuario(
    String nombre,
    String email,
    String telefono,
    String password,
  ) async {
    // Determinar el rol basado en el correo
    String role = email.endsWith('@gmailadmi.com') ? 'admin' : 'user';

    await _usuarios.add({
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'password': password,
      'role': role, // Agregamos el campo 'role'
    });
  }

  // Iniciar sesión
  Future<Map<String, dynamic>?> iniciarSesion(
    String email,
    String password,
  ) async {
    final querySnapshot =
        await _usuarios
            .where('email', isEqualTo: email)
            .where('password', isEqualTo: password)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;
      return userDoc.data() as Map<String, dynamic>;
    }
    return null; // Si no se encuentra el usuario
  }
}