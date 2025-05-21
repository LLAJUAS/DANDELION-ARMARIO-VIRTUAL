import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServicePrendas {
  final CollectionReference _prendas = 
      FirebaseFirestore.instance.collection('PRENDAS');

  // Registrar una prenda con rutas locales
  Future<void> registrarPrenda({
    required String usuarioId,
    required List<String> rutasImagenes,
    required String categoria,
    required String subcategoria,
    required List<String> colores,
    required List<String> etiquetas,
    required String marca,
    required String estacion,
    bool favorito = false,
  }) async {
    try {
      await _prendas.add({
        'usuarioId': usuarioId,
        'rutasImagenes': rutasImagenes,
        'categoria': categoria,
        'subcategoria': subcategoria,
        'colores': colores,
        'etiquetas': etiquetas,
        'marca': marca,
        'estacion': estacion,
        'favorito': favorito,
        'fechaCreacion': FieldValue.serverTimestamp(),
        'ultimaModificacion': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al registrar prenda: $e');
    }
  }

  // Obtener todas las prendas de un usuario ordenadas por fecha
  Future<QuerySnapshot> obtenerPrendasUsuario(String usuarioId) async {
    try {
      return await _prendas
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('fechaCreacion', descending: true)
          .get();
    } catch (e) {
      throw Exception('Error al obtener prendas: $e');
    }
  }

  // Actualizar prenda por ID
  Future<void> actualizarPrenda({
    required String prendaId,
    required Map<String, dynamic> nuevosDatos,
  }) async {
    try {
      await _prendas.doc(prendaId).update({
        ...nuevosDatos,
        'ultimaModificacion': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al actualizar prenda: $e');
    }
  }

  // Eliminar una prenda por ID
  Future<void> eliminarPrenda(String prendaId) async {
    try {
      await _prendas.doc(prendaId).delete();
    } catch (e) {
      throw Exception('Error al eliminar prenda: $e');
    }
  }

  // Obtener una prenda específica por ID
  Future<DocumentSnapshot> obtenerPrenda(String prendaId) async {
    try {
      return await _prendas.doc(prendaId).get();
    } catch (e) {
      throw Exception('Error al obtener prenda: $e');
    }
  }

  // Obtener stream de prendas para actualizaciones en tiempo real
  Stream<QuerySnapshot> obtenerPrendasStream(String usuarioId) {
    return _prendas
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('fechaCreacion', descending: true)
        .snapshots();
  }
}