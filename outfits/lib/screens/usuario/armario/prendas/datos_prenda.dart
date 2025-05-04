import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:typed_data';

class DatosPrenda extends StatefulWidget {
  final List<Uint8List> imagenes;

  const DatosPrenda({super.key, required this.imagenes});

  @override
  State<DatosPrenda> createState() => _AgregarPrendaState();
}

class _AgregarPrendaState extends State<DatosPrenda> {
  final String _selectedCategory = 'Vaqueros > Tiro alto';
  final List<String> _selectedColors = ['AZUL'];
  final List<String> _selectedTags = ['LONGITUD TOTAL', 'SENCILLA'];
  final String _brand = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'REVISAR ARTÍCULOS',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen central
                  if (widget.imagenes.isNotEmpty)
                    Center(
                      child: SizedBox(
                        height: 300,
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: MemoryImage(widget.imagenes.first),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  
                  // Acerca de
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      'Acerca de',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const Divider(height: 1),
                  
                  // Categoría
                  ListTile(
                    title: const Text(
                      'Categoría',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedCategory,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: Colors.grey[400]),
                      ],
                    ),
                    onTap: () {
                      // Show category selection dialog
                    },
                  ),
                  
                  const Divider(height: 1),
                  
                  // Colores
                  ListTile(
                    title: const Text(
                      'Colores',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        // Show color edit dialog
                      },
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: _selectedColors.map((color) => _buildColorChip(color)).toList(),
                    ),
                  ),
                  
                  const Divider(height: 32),
                  
                  // Etiquetas
                  ListTile(
                    title: const Text(
                      'Etiquetas',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        // Show tags edit dialog
                      },
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: _selectedTags.map((tag) => _buildTagChip(tag)).toList(),
                    ),
                  ),
                  
                  const Divider(height: 32),
                  
                  // Marca
                  ListTile(
                    title: const Text(
                      'Marca',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        // Show brand input dialog
                      },
                      child: Text(
                        'Agregar',
                        style: TextStyle(
                          color: Colors.pink[300],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón Guardar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción para guardar
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Color(0xFFCCFF00), // Color verde neón
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  // Botón Revisar más tarde
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: OutlinedButton(
                      onPressed: () {
                        // Acción para "Revisar más tarde"
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: BorderSide(color: Color(0xFFCCFF00)), // Borde verde neón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Revisar más tarde',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String color) {
    Color chipColor = Colors.blue;
    // Map color names to actual colors
    if (color == 'AZUL') chipColor = Colors.blue;
    if (color == 'NEGRO') chipColor = Colors.black;
    if (color == 'BLANCO') chipColor = Colors.white;
    if (color == 'ROJO') chipColor = Colors.red;
    if (color == 'VERDE') chipColor = Colors.green;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor: chipColor,
          radius: 10,
        ),
        label: Text(color),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          setState(() {
            _selectedColors.remove(color);
          });
        },
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Chip(
        label: Text(tag),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          setState(() {
            _selectedTags.remove(tag);
          });
        },
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}