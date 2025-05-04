class Usuario {
  String id;
  String email;
  String password;

  Usuario({required this.id, required this.email, required this.password});

  factory Usuario.fromMap(Map<String, dynamic> data, String documentId) {
    return Usuario(
      id: documentId,
      email: data['email'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}