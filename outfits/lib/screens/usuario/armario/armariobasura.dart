import 'package:flutter/material.dart';
import 'package:outfits/screens/usuario/armario/prendas/agregar.dart';
import 'package:outfits/theme/armario_theme.dart';
import 'package:outfits/LOGIN/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Armario extends StatefulWidget {
  final Usuario usuario;

  const Armario({super.key, required this.usuario});

  @override
  State<Armario> createState() => _ArmarioState();
}

class _ArmarioState extends State<Armario> {
  List<String> _localImagePaths = [];
  bool _isLoading = true;
  final Map<String, Map<String, dynamic>> _prendasData = {};

  @override
  void initState() {
    super.initState();
    _loadLocalImages();
  }

  Future<void> _loadLocalImages() async {
    try {
      // Consulta modificada para evitar necesidad de índice compuesto
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('PRENDAS')
          .where('usuarioId', isEqualTo: widget.usuario.id)
          .get();

      // Ordenar localmente por fecha de creación
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      docs.sort((a, b) {
        final aDate = a['fechaCreacion'] as Timestamp? ?? Timestamp.now();
        final bDate = b['fechaCreacion'] as Timestamp? ?? Timestamp.now();
        return bDate.compareTo(aDate); // Orden descendente
      });

      List<String> localPaths = [];
      for (var doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> rutas = data['rutasImagenes'] ?? [];
        localPaths.addAll(rutas.cast<String>());
        
        if (rutas.isNotEmpty) {
          _prendasData[rutas.first] = data;
        }
      }

      setState(() {
        _localImagePaths = localPaths;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error cargando imágenes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArmarioTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              Container(
                decoration: ArmarioTheme.statsContainerDecoration,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem("2", "Prendas"),
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
                          _buildFilterCategory("Todo", true, "assets/jacket.png"),
                          _buildFilterCategory("Mono", false, "assets/dress.png"),
                          _buildFilterCategory("Prendas\nexteriores", false, "assets/jacket.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _localImagePaths.isEmpty
                        ? _buildEmptyState()
                        : GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            children: _localImagePaths
                                .map((path) => _buildClothingItem(path))
                                .toList(),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AgregarPrendaFoto()),
    );

    if (result != null && result is List<String>) {
      // Actualizar la lista de imágenes
      setState(() {
        _localImagePaths.insertAll(0, result);
      });
    }
  },
  backgroundColor: const Color(0xFFD94A64),
  child: const Icon(Icons.add, color: Colors.black),
),
      bottomNavigationBar: BottomNavigationBar(
        type: ArmarioTheme.bottomNavigationBarTheme.type,
        selectedItemColor: const Color(0xFFD94A64),
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

  Widget _buildFilterCategory(String label, bool isSelected, String imagePath) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: ArmarioTheme.filterCategoryDecoration(isSelected),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[200],
            child: Icon(isSelected ? Icons.access_alarm : Icons.add, size: 24),
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

 Widget _buildClothingItem(String imageName) {
    return GestureDetector(
      onTap: () => _showPrendaDetails(context, imageName),
      child: FutureBuilder<File>(
        future: _getImageFile(imageName),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.photo, color: Colors.white, size: 40),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return Container(
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
                      child: Image.file(
                        snapshot.data!,
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
                ],
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Future<File> _getImageFile(String imageName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    return File('${appDocDir.path}/$imageName');
  }

  Future<void> _showPrendaDetails(BuildContext context, String imageName) async {
    final prendaData = _prendasData[imageName];
    if (prendaData == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles de la Prenda'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<File>(
                future: _getImageFile(imageName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.file(snapshot.data!, fit: BoxFit.cover),
                    );
                  }
                  return Container(
                    height: 200,
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Categoría', '${prendaData['categoria']} > ${prendaData['subcategoria']}'),
              _buildDetailRow('Marca', prendaData['marca'] ?? 'No especificada'),
              _buildDetailRow('Estación', prendaData['estacion'] ?? 'No especificada'),
              _buildDetailRow('Colores', (prendaData['colores'] as List<dynamic>).join(', ')),
              _buildDetailRow('Etiquetas', (prendaData['etiquetas'] as List<dynamic>).join(', ')),
            ],
          ),
        ),
        actions: [
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
}