import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:typed_data';
import 'package:outfits/PRENDAS/services/firestore_service.dart';
import 'dart:io'; // Agregar esta importación
import 'package:path_provider/path_provider.dart'; // Agregar esta importación
import 'package:uuid/uuid.dart';
// Agrega este import al inicio
import 'package:path/path.dart' as path;

class DatosPrenda extends StatefulWidget {
  final List<Uint8List> imagenes;

  const DatosPrenda({super.key, required this.imagenes});

  @override
  State<DatosPrenda> createState() => _AgregarPrendaState();
}

class _AgregarPrendaState extends State<DatosPrenda> {
  String _selectedCategory = 'partes de arriba';
  String _selectedSubcategory = 'camisas';
  final List<String> _selectedColors = ['#FF5733', '#000000']; // Ahora en formato HEX
  final List<String> _selectedTags = ['formal', 'trabajo'];
  String _brand = 'Zara';
  String _season = 'primavera';
  String _userId = ''; // Se establecerá dinámicamente

  // Agregamos el servicio de Firestore
  final FirestoreServicePrendas _firestoreService = FirestoreServicePrendas();

  @override
  void initState() {
    super.initState();
    // Aquí deberías obtener el ID del usuario logueado
    _userId = 'abc123'; // Temporal hasta implementar la autenticación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'REVISAR PRENDA',
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
                          '$_selectedCategory > $_selectedSubcategory',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: Colors.grey[400]),
                      ],
                    ),
                    onTap: () {
                      _showCategorySelectionDialog();
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
                        _showColorSelectionDialog();
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
                        _showTagSelectionDialog();
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
                  
                  const Divider(height: 1),
                  
                  // Estación
                  ListTile(
                    title: const Text(
                      'Estación',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _season,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: Colors.grey[400]),
                      ],
                    ),
                    onTap: () {
                      _showSeasonSelectionDialog();
                    },
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
                        _showBrandInputDialog();
                      },
                      child: Text(
                        _brand.isEmpty ? 'Agregar' : _brand,
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
                      
                      onPressed: () async {
                        try {
                          // Guardar imágenes localmente
                          final rutas = await guardarImagenesLocalmente(widget.imagenes);

                          // Guardar en Firestore
                          await _firestoreService.registrarPrenda(
                            usuarioId: _userId,
                            rutasImagenes: rutas, // Nuevo campo para rutas locales
                            categoria: _selectedCategory,
                            subcategoria: _selectedSubcategory,
                            colores: _selectedColors,
                            etiquetas: _selectedTags,
                            marca: _brand,
                            estacion: _season,
                            favorito: false,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Prenda guardada exitosamente')),
                          );

                          // Redirigir y pasar las rutas de las imágenes
                          Navigator.of(context).pop(rutas);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al guardar: $e')),
                          );
                        }
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

  Widget _buildColorChip(String hexColor) {
    Color chipColor = _hexToColor(hexColor);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor: chipColor,
          radius: 10,
        ),
        label: Text(hexColor),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          setState(() {
            _selectedColors.remove(hexColor);
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

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Agregar opacidad si no está presente
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  void _showCategorySelectionDialog() {
    final Map<String, List<String>> categories = {
      'partes de arriba': ['camisas', 'blusas', 'suéteres', 'chaquetas'],
      'partes de abajo': ['pantalones', 'jeans', 'faldas', 'shorts'],
      'vestidos': ['vestidos casuales', 'vestidos formales', 'vestidos de noche'],
      'calzado': ['zapatos', 'sandalias', 'botas', 'tenis'],
      'accesorios': ['bolsos', 'cinturones', 'bufandas', 'sombreros'],
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar categoría'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: categories.entries.map((entry) {
                return ExpansionTile(
                  title: Text(entry.key),
                  children: entry.value.map((subcategory) {
                    return ListTile(
                      title: Text(subcategory),
                      onTap: () {
                        setState(() {
                          _selectedCategory = entry.key;
                          _selectedSubcategory = subcategory;
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showColorSelectionDialog() {
    final List<String> availableColors = [
      '#FF5733', '#000000', '#FFFFFF', '#FF0000', '#00FF00', 
      '#0000FF', '#FFFF00', '#FF00FF', '#00FFFF', '#C0C0C0'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar colores'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: availableColors.map((color) {
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: _hexToColor(color),
                          margin: const EdgeInsets.only(right: 10),
                        ),
                        Text(color),
                      ],
                    ),
                    value: _selectedColors.contains(color),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedColors.add(color);
                        } else {
                          _selectedColors.remove(color);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Listo'),
            ),
          ],
        );
      },
    );
  }

  void _showTagSelectionDialog() {
    final List<String> availableTags = [
      'formal', 'casual', 'trabajo', 'fiesta', 'deporte',
      'verano', 'invierno', 'otoño', 'primavera', 'elegante'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar etiquetas'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: availableTags.map((tag) {
                  return CheckboxListTile(
                    title: Text(tag),
                    value: _selectedTags.contains(tag),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Listo'),
            ),
          ],
        );
      },
    );
  }

  void _showSeasonSelectionDialog() {
    final List<String> seasons = ['primavera', 'verano', 'otoño', 'invierno'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar estación'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: seasons.map((season) {
                return ListTile(
                  title: Text(season),
                  onTap: () {
                    setState(() {
                      _season = season;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showBrandInputDialog() {
    TextEditingController brandController = TextEditingController(text: _brand);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingresar marca'),
          content: TextField(
            controller: brandController,
            decoration: const InputDecoration(
              hintText: 'Ejemplo: Zara, H&M, etc.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _brand = brandController.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

// Modifica la función guardarImagenesLocalmente
Future<List<String>> guardarImagenesLocalmente(List<Uint8List> imagenes) async {
  final List<String> rutasGuardadas = [];
  final directorio = await getApplicationDocumentsDirectory();
  final uuid = const Uuid();

  for (var imagen in imagenes) {
    final nombreArchivo = 'prenda_${uuid.v4()}.png';
    final rutaCompleta = '${directorio.path}/$nombreArchivo';
    final archivo = File(rutaCompleta);
    await archivo.writeAsBytes(imagen);
    // Guardamos solo el nombre del archivo, no la ruta completa
    rutasGuardadas.add(nombreArchivo);
  }

  return rutasGuardadas;
}
