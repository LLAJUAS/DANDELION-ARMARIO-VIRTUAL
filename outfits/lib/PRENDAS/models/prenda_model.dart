import 'package:cloud_firestore/cloud_firestore.dart';

class Prenda {
  final String usuarioId;
  final List<String> rutasImagenes;
  final String categoria;
  final String subcategoria;
  final List<String> colores;
  final List<String> etiquetas;
  final String marca;
  final String estacion;
  final bool favorito;
  final DateTime fechaCreacion;

  Prenda({
    required this.usuarioId,
    required this.rutasImagenes,
    required this.categoria,
    required this.subcategoria,
    required this.colores,
    required this.etiquetas,
    required this.marca,
    required this.estacion,
    required this.favorito,
    required this.fechaCreacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'rutasImagenes': rutasImagenes,
      'categoria': categoria,
      'subcategoria': subcategoria,
      'colores': colores,
      'etiquetas': etiquetas,
      'marca': marca,
      'estacion': estacion,
      'favorito': favorito,
      'fechaCreacion': fechaCreacion,
    };
  }

  factory Prenda.fromMap(Map<String, dynamic> map) {
    return Prenda(
      usuarioId: map['usuarioId'],
      rutasImagenes: List<String>.from(map['rutasImagenes']),
      categoria: map['categoria'],
      subcategoria: map['subcategoria'],
      colores: List<String>.from(map['colores']),
      etiquetas: List<String>.from(map['etiquetas']),
      marca: map['marca'],
      estacion: map['estacion'],
      favorito: map['favorito'],
      fechaCreacion: (map['fechaCreacion'] as Timestamp).toDate(),
    );
  }
}