import 'package:flutter/material.dart';
import 'package:outfits/screens/usuario/armario/prendas/agregar.dart';
import 'package:outfits/theme/armario_theme.dart';
import 'package:outfits/LOGIN/models/user_model.dart'; // Importa el modelo Usuario

class Armario extends StatelessWidget {
  final Usuario usuario; // Agrega un parámetro para el usuario

  const Armario({super.key, required this.usuario}); // Constructor actualizado

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
                                usuario.id, // Muestra el nombre del usuario
                                style: ArmarioTheme.profileNameTextStyle,
                              ),
                              Text(
                                "@${usuario.email.split('@')[0]}", // Muestra el nombre de usuario basado en el email
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
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildClothingItem("https://plus.unsplash.com/premium_photo-1664304951108-c04911c42fbd?q=80&w=1073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", "Dress"),
                    _buildClothingItem("https://plus.unsplash.com/premium_photo-1664304951108-c04911c42fbd?q=80&w=1073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", "Jacket"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarPrendaFoto()),
          );
        },
        backgroundColor: Colors.cyan,
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

  Widget _buildClothingItem(String imageUrl, String type) {
    return Container(
      decoration: ArmarioTheme.clothingItemDecoration,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: ArmarioTheme.clothingActionDecoration,
              child: const Icon(Icons.visibility, size: 20),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: ArmarioTheme.clothingActionDecoration,
              child: const Icon(Icons.favorite_border, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}