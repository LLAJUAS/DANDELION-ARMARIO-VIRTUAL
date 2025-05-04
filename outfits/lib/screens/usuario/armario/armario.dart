import 'package:flutter/material.dart';
import 'package:outfits/screens/usuario/armario/prendas/agregar.dart';

class Armario extends StatelessWidget {
  const Armario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Column(
            children: [
             
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(186, 217, 74, 100),
              const Color.fromARGB(164, 242, 135, 41),
            ],
          ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Profile section
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
                              const Text(
                                "Alejandra",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "@llajuas",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 24),
                            onSelected: (value) {
                              if (value == 'logout') {
                                // Implementar la lógica de cerrar sesión
                                Navigator.of(context).pushReplacementNamed('/login'); // Redirige a la pantalla de inicio de sesión
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

                    // Icons row
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

              // Stats section
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
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
                      color: Colors.grey[300],
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

              // Clothing grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true, // <-- Important to allow GridView to fit within the scroll
                  physics: const NeverScrollableScrollPhysics(), // <-- Prevent internal scrolling
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildClothingItem("https://via.placeholder.com/200x300/123456", "Dress"),
                    _buildClothingItem("https://via.placeholder.com/200x300/662244", "Jacket"),
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 24),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterCategory(String label, bool isSelected, String imagePath) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[200],
            // Using placeholder for now, you should replace with your actual assets
            // child: Image.asset(imagePath, width: 30, height: 30),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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
              decoration: const BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.visibility, size: 20),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}