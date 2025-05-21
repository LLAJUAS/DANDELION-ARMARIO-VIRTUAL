import 'package:flutter/material.dart';
import 'package:outfits/screens/usuario/armario/prendas/agregar.dart';
import 'package:outfits/theme/armario_theme.dart';
import 'package:outfits/LOGIN/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Armario extends StatefulWidget {
  final Usuario usuario;

  const Armario({super.key, required this.usuario});

  @override
  _ArmarioState createState() => _ArmarioState();
}

class _ArmarioState extends State<Armario> {
  final prendasRef = FirebaseFirestore.instance.collection('PRENDAS');
  File? _imagenSeleccionada;
  bool _isLoading = true;
  String _currentFilter = 'Todo';
  List<DocumentSnapshot> _prendas = [];
  final Map<String, Map<String, dynamic>> _prendasData = {};

  @override
  void initState() {
    super.initState();
    _loadPrendas();
  }

  Future<void> _loadPrendas() async {
    try {
      Query query = prendasRef.where('usuarioId', isEqualTo: widget.usuario.id);

      if (_currentFilter != 'Todo') {
        query = query.where('categoria', isEqualTo: _currentFilter);
      }

      final snapshot = await query.get();

      // Ordenar localmente por fecha de creación
      List<DocumentSnapshot> docs = snapshot.docs;
      docs.sort((a, b) {
        final aDate = a['fechaCreacion'] as Timestamp? ?? Timestamp.now();
        final bDate = b['fechaCreacion'] as Timestamp? ?? Timestamp.now();
        return bDate.compareTo(aDate); // Orden descendente
      });

      // Preparar datos para la vista de grid
      for (var doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> rutas = data['rutasImagenes'] ?? [];
        if (rutas.isNotEmpty) {
          _prendasData[rutas.first] = data;
        }
      }

      setState(() {
        _prendas = docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error cargando prendas: $e');
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _currentFilter = filter;
      _isLoading = true;
      _prendasData.clear();
    });
    _loadPrendas();
  }

  Future<void> _seleccionarImagen() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagenSeleccionada = File(pickedFile.path);
      });
    }
  }

  void eliminarPrenda(String id) {
    prendasRef.doc(id).delete().then((_) {
      _loadPrendas(); // Recargar las prendas después de eliminar
    });
  }

  void cambiarFavoritoPrenda(String id, bool favorito) {
    prendasRef.doc(id).update({'favorito': favorito});
  }
void mostrarFormulario({DocumentSnapshot? prenda}) {
  // Controllers inicializados
  final categoriaController = TextEditingController(text: prenda?['categoria'] ?? '');
  final subcategoriaController = TextEditingController(text: prenda?['subcategoria'] ?? '');
  final marcaController = TextEditingController(text: prenda?['marca'] ?? '');
  final estacionController = TextEditingController(text: prenda?['estacion'] ?? '');
  final coloresController = TextEditingController(text: (prenda?['colores'] as List<dynamic>?)?.join(', ') ?? '');
  final etiquetasController = TextEditingController(text: (prenda?['etiquetas'] as List<dynamic>?)?.join(', ') ?? '');
  final imagenUrl = prenda?['rutasImagenes']?.first;

  // Definiciones de opciones disponibles (igual que antes)
  final Map<String, List<String>> categorias = {
    'partes de arriba': ['camisas', 'blusas', 'suéteres', 'chaquetas'],
    'partes de abajo': ['pantalones', 'jeans', 'faldas', 'shorts'],
    'vestidos': ['vestidos casuales', 'vestidos formales', 'vestidos de noche'],
    'calzado': ['zapatos', 'sandalias', 'botas', 'tenis'],
    'accesorios': ['bolsos', 'cinturones', 'bufandas', 'sombreros'],
  };

  final List<String> estaciones = ['primavera', 'verano', 'otoño', 'invierno'];
  final List<String> coloresDisponibles = [
    '#FF5733', '#000000', '#FFFFFF', '#FF0000', '#00FF00',
    '#0000FF', '#FFFF00', '#FF00FF', '#00FFFF', '#C0C0C0'
  ];
  final List<String> etiquetasDisponibles = [
    'formal', 'casual', 'trabajo', 'fiesta', 'deporte',
    'verano', 'invierno', 'otoño', 'primavera', 'elegante'
  ];
  final defaultImageIndex = prenda != null ? (_prendas.indexOf(prenda) % 6 + 1) : 1;
final defaultImagePath = 'assets/ROPA/$defaultImageIndex.png';

  // Variable para manejar el estado del formulario
  bool formChanged = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            backgroundColor: ArmarioTheme.backgroundColor,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                maxWidth: double.infinity,
                maxHeight: 600,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prenda == null ? 'Nueva Prenda' : 'Editar Prenda',
                        style: ArmarioTheme.profileNameTextStyle.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      
                      // Campo de Categoría con selector
                      ListTile(
                        title: Text(
                          'Categoría',
                          style: ArmarioTheme.profileUsernameTextStyle,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              categoriaController.text.isNotEmpty && subcategoriaController.text.isNotEmpty
                                  ? '${categoriaController.text} > ${subcategoriaController.text}'
                                  : 'Seleccionar',
                              style: TextStyle(
                                color: categoriaController.text.isEmpty ? Colors.grey[600] : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right, color: Colors.grey[400]),
                          ],
                        ),
                        onTap: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Seleccionar categoría'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: categorias.entries.map((entry) {
                                      return ExpansionTile(
                                        title: Text(entry.key),
                                        children: entry.value.map((subcategory) {
                                          return ListTile(
                                            title: Text(subcategory),
                                            onTap: () {
                                              Navigator.of(context).pop({
                                                'categoria': entry.key,
                                                'subcategoria': subcategory
                                              });
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
                          
                          if (result != null) {
                            setState(() {
                              categoriaController.text = result['categoria'];
                              subcategoriaController.text = result['subcategoria'];
                              formChanged = true;
                            });
                          }
                        },
                      ),
                      const Divider(height: 1),

                      // Campo de Marca
                      ListTile(
                        title: Text(
                          'Marca',
                          style: ArmarioTheme.profileUsernameTextStyle,
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController brandController = TextEditingController(text: marcaController.text);
                                return AlertDialog(
                                  title: const Text('Ingresar marca'),
                                  content: TextField(
                                    controller: brandController,
                                    decoration: const InputDecoration(
                                      hintText: 'Ejemplo: Zara, H&M, etc.',
                                    ),
                                    autofocus: true,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(brandController.text.trim());
                                      },
                                      child: const Text('Guardar'),
                                    ),
                                  ],
                                );
                              },
                            );
                            
                            if (result != null && result is String) {
                              setState(() {
                                marcaController.text = result;
                                formChanged = true;
                              });
                            }
                          },
                          child: Text(
                            marcaController.text.isEmpty ? 'Agregar' : marcaController.text,
                            style: TextStyle(
                              color: marcaController.text.isEmpty ? Colors.pink[300] : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1),

                      // Campo de Estación
                      ListTile(
                        title: Text(
                          'Estación',
                          style: ArmarioTheme.profileUsernameTextStyle,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              estacionController.text.isNotEmpty ? estacionController.text : 'Seleccionar',
                              style: TextStyle(
                                color: estacionController.text.isEmpty ? Colors.grey[600] : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right, color: Colors.grey[400]),
                          ],
                        ),
                        onTap: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Seleccionar estación'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: estaciones.map((season) {
                                      return ListTile(
                                        title: Text(season),
                                        onTap: () {
                                          Navigator.of(context).pop(season);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                          
                          if (result != null) {
                            setState(() {
                              estacionController.text = result;
                              formChanged = true;
                            });
                          }
                        },
                      ),
                      const Divider(height: 1),

                      // Campo de Colores
                      ListTile(
                        title: Text(
                          'Colores',
                          style: ArmarioTheme.profileUsernameTextStyle,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () async {
                            List<String> selectedColors = coloresController.text.split(', ').where((c) => c.isNotEmpty).toList();
                            
                            final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Seleccionar colores'),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: coloresDisponibles.map((color) {
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
                                                value: selectedColors.contains(color),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      selectedColors.add(color);
                                                    } else {
                                                      selectedColors.remove(color);
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
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(selectedColors);
                                          },
                                          child: const Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                            
                            if (result != null) {
                              setState(() {
                                coloresController.text = result.join(', ');
                                formChanged = true;
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: coloresController.text.split(', ').where((c) => c.isNotEmpty).map((color) => _buildColorChip(color)).toList(),
                        ),
                      ),
                      const Divider(height: 1),

                      // Campo de Etiquetas
                      ListTile(
                        title: Text(
                          'Etiquetas',
                          style: ArmarioTheme.profileUsernameTextStyle,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () async {
                            List<String> selectedTags = etiquetasController.text.split(', ').where((t) => t.isNotEmpty).toList();
                            
                            final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Seleccionar etiquetas'),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: etiquetasDisponibles.map((tag) {
                                              return CheckboxListTile(
                                                title: Text(tag),
                                                value: selectedTags.contains(tag),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      selectedTags.add(tag);
                                                    } else {
                                                      selectedTags.remove(tag);
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
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(selectedTags);
                                          },
                                          child: const Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                            
                            if (result != null) {
                              setState(() {
                                etiquetasController.text = result.join(', ');
                                formChanged = true;
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: etiquetasController.text.split(', ').where((t) => t.isNotEmpty).map((tag) => _buildTagChip(tag)).toList(),
                        ),
                      ),
                      const Divider(height: 1),

                     // Imagen
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            if (imagenUrl != null)
                              Image.network(
                                imagenUrl, 
                                height: 150, 
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => prenda != null 
                                    ? Image.asset(defaultImagePath, height: 150, fit: BoxFit.cover)
                                    : Container(
                                        height: 150,
                                        width: 150,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.photo, size: 50),
                                      ),
                              )
                            else if (_imagenSeleccionada != null)
                              Image.file(_imagenSeleccionada!, height: 150, fit: BoxFit.cover)
                            else
                              prenda != null
                                  ? Image.asset(defaultImagePath, height: 150, fit: BoxFit.cover)
                                  : Container(
                                      height: 150,
                                      width: 150,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.photo, size: 50),
                                    ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                await _seleccionarImagen();
                                setState(() {
                                  formChanged = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Seleccionar Imagen'),
                            ),
                          ],
                        ),
                      ),
                                            const SizedBox(height: 20),

                      // Botones de acción
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancelar',
                              style: ArmarioTheme.profileUsernameTextStyle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: formChanged || prenda == null
                                ? () {
                                    final data = {
                                      'categoria': categoriaController.text,
                                      'subcategoria': subcategoriaController.text,
                                      'marca': marcaController.text,
                                      'estacion': estacionController.text,
                                      'colores': coloresController.text.split(', ').where((c) => c.isNotEmpty).toList(),
                                      'etiquetas': etiquetasController.text.split(', ').where((t) => t.isNotEmpty).toList(),
                                      'favorito': prenda?['favorito'] ?? false,
                                      'usuarioId': widget.usuario.id,
                                      'fechaCreacion': prenda?['fechaCreacion'] ?? Timestamp.now(),
                                      'rutasImagenes': _imagenSeleccionada != null
                                          ? ['file://${_imagenSeleccionada!.path}']
                                          : imagenUrl != null ? [imagenUrl] : [],
                                    };

                                    if (prenda == null) {
                                      prendasRef.add(data).then((_) {
                                        _loadPrendas();
                                      });
                                    } else {
                                      prendasRef.doc(prenda.id).update(data).then((_) {
                                        _loadPrendas();
                                      });
                                    }

                                    Navigator.pop(context);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCCFF00),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text(
                              'Guardar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// Función auxiliar para convertir HEX a Color
Color _hexToColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor'; // Agregar opacidad si no está presente
  }
  return Color(int.parse(hexColor, radix: 16));
}

// Widget para mostrar chips de colores
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
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

// Widget para mostrar chips de etiquetas
Widget _buildTagChip(String tag) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: Chip(
      label: Text(tag),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArmarioTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con foto de perfil
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: ArmarioTheme.headerDecoration,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 46,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 44,
                                      backgroundImage: NetworkImage(
                                        "https://images.unsplash.com/photo-1718345641213-80cfe1424084?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.usuario.id,
                                style: ArmarioTheme.profileNameTextStyle,
                              ),
                              Text(
                                "@${widget.usuario.email.split('@')[0]}",
                                style: ArmarioTheme.profileUsernameTextStyle,
                              ),
                            ],
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 24),
                            onSelected: (value) {
                              if (value == 'logout') {
                                Navigator.of(context).pushReplacementNamed('/login');
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'logout',
                                child: Text('Cerrar sesión'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIconButton(Icons.bookmark_border),
                        const SizedBox(width: 36),
                        _buildIconButton(Icons.grid_view),
                        const SizedBox(width: 36),
                        _buildIconButton(Icons.bar_chart),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Estadísticas y filtros
              Container(
                decoration: ArmarioTheme.statsContainerDecoration,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(_prendas.length.toString(), "Prendas"),
                          _buildStatItem("0", "Atuendos"),
                          _buildStatItem("0", "Lookbooks"),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: ArmarioTheme.dividerColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFilterCategory("Todo", _currentFilter == 'Todo', "assets/jacket.png", () => _applyFilter('Todo')),
                          _buildFilterCategory("Mono", _currentFilter == 'Mono', "assets/dress.png", () => _applyFilter('Mono')),
                          _buildFilterCategory("Prendas\nexteriores", _currentFilter == 'Prendas exteriores', "assets/jacket.png", () => _applyFilter('Prendas exteriores')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Lista de prendas en grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _prendas.isEmpty
                        ? _buildEmptyState()
                        : GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            children: _prendas
                                .where((prenda) => (prenda['rutasImagenes'] as List).isNotEmpty)
                                .map((prenda) => _buildClothingItem(prenda))
                                .toList(),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarFormulario(),
        backgroundColor: const Color(0xFFD94A64),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: ArmarioTheme.bottomNavigationBarTheme.type,
        selectedItemColor: ArmarioTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: ArmarioTheme.bottomNavigationBarTheme.unselectedItemColor,
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Armario",
          ),
        ],
      ),
    );
  }

 Widget _buildClothingItem(DocumentSnapshot prenda) {
  final data = prenda.data() as Map<String, dynamic>;
  final imageUrl = (data['rutasImagenes'] as List).isNotEmpty 
      ? data['rutasImagenes'].first 
      : null;
  
  // Obtener el índice basado en la posición de la prenda en la lista (1-6)
  final prendaIndex = _prendas.indexOf(prenda) % 6 + 1;
  final defaultImagePath = 'assets/ROPA/$prendaIndex.png';

  return GestureDetector(
    onTap: () => _showPrendaDetails(context, prenda),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        defaultImagePath,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      defaultImagePath,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.visibility, size: 20, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                data['favorito'] ?? false ? Icons.favorite : Icons.favorite_border,
                color: data['favorito'] ?? false ? Colors.red : Colors.white,
              ),
              onPressed: () {
                cambiarFavoritoPrenda(prenda.id, !(data['favorito'] ?? false));
                setState(() {});
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showPrendaDetails(BuildContext context, DocumentSnapshot prenda) async {
  final data = prenda.data() as Map<String, dynamic>;
  final imageUrl = (data['rutasImagenes'] as List).isNotEmpty 
      ? data['rutasImagenes'].first 
      : null;
  
  // Obtener el índice basado en la posición de la prenda en la lista (1-6)
  final prendaIndex = _prendas.indexOf(prenda) % 6 + 1;
  final defaultImagePath = 'assets/ROPA/$prendaIndex.png';

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "${data['categoria']} - ${data['subcategoria']}",
        style: ArmarioTheme.profileNameTextStyle,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        defaultImagePath,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      defaultImagePath,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Categoría', '${data['categoria']} > ${data['subcategoria']}'),
            _buildDetailRow('Marca', data['marca'] ?? 'No especificada'),
            _buildDetailRow('Estación', data['estacion'] ?? 'No especificada'),
            _buildDetailRow('Colores', (data['colores'] as List<dynamic>).join(', ')),
            _buildDetailRow('Etiquetas', (data['etiquetas'] as List<dynamic>).join(', ')),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pop(context);
            mostrarFormulario(prenda: prenda);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            eliminarPrenda(prenda.id);
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: ArmarioTheme.iconButtonDecoration,
      child: Icon(icon, size: 24),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: ArmarioTheme.statCountTextStyle,
        ),
        Text(
          label,
          style: ArmarioTheme.statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildFilterCategory(String label, bool isSelected, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: ArmarioTheme.filterCategoryDecoration(isSelected),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[200],
              child: Icon(isSelected ? Icons.check : Icons.add, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay prendas guardadas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona el botón + para agregar una',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}