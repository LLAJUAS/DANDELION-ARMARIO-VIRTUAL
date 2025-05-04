class Usuario {
  String id;
  String email;
  String password;

  Usuario({required this.id, required this.email, required this.password});

  factory Usuario.fromMap(Map<String, dynamic> data, String documentId) {
    return Usuario(
      id: data['nombre'] ?? '', // Usa el campo 'nombre'
      email: data['email'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'nombre': id, 'email': email, 'password': password};
  }
}