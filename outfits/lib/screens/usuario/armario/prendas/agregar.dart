import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:outfits/screens/screens.dart';
import 'package:transparent_image/transparent_image.dart';


class AgregarPrendaFoto extends StatefulWidget {
  const AgregarPrendaFoto({Key? key}) : super(key: key);

  @override
  State<AgregarPrendaFoto> createState() => _AgregarPrendaFotoState();
}

class _AgregarPrendaFotoState extends State<AgregarPrendaFoto> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imagenesOriginales = [];
  List<Uint8List> _imagenesProcesadas = [];
  bool _procesando = false;
  String _error = '';

  // Configura tu API key de Remove.bg aquí
  static const String REMOVE_BG_API_KEY = '29Pg3PzksCe8TwGFwB5aLxPA';
  static const String REMOVE_BG_API_URL = 'https://api.remove.bg/v1.0/removebg';

  Future<void> _mostrarPopupPermiso({
    required String titulo,
    required VoidCallback onAceptar,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Permitir'),
              onPressed: () {
                Navigator.of(context).pop();
                onAceptar();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _seleccionarImagenesGaleriaConPermiso() async {
    await _mostrarPopupPermiso(
      titulo: '¿Permitir acceso a la galería?',
      onAceptar: _seleccionarImagenesGaleria,
    );
  }

  Future<void> _tomarFotoConPermiso() async {
    await _mostrarPopupPermiso(
      titulo: '¿Permitir acceso a la cámara?',
      onAceptar: _tomarFoto,
    );
  }

  Future<void> _seleccionarImagenesGaleria() async {
    try {
      final List<XFile>? imagenesSeleccionadas = await _picker.pickMultiImage();
      if (imagenesSeleccionadas != null && imagenesSeleccionadas.isNotEmpty) {
        setState(() {
          _procesando = true;
          _error = '';
          _imagenesOriginales.addAll(imagenesSeleccionadas);
        });

        for (var imagen in imagenesSeleccionadas) {
          await _procesarImagenConRemoveBg(imagen);
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Error al seleccionar imágenes: ${e.toString()}';
      });
    } finally {
      setState(() {
        _procesando = false;
      });
    }
  }

  Future<void> _tomarFoto() async {
    try {
      final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
      if (foto != null) {
        setState(() {
          _procesando = true;
          _error = '';
          _imagenesOriginales.add(foto);
        });

        await _procesarImagenConRemoveBg(foto);
      }
    } catch (e) {
      setState(() {
        _error = 'Error al tomar foto: ${e.toString()}';
      });
    } finally {
      setState(() {
        _procesando = false;
      });
    }
  }

  Future<void> _procesarImagenConRemoveBg(XFile imagen) async {
    try {
      final bytes = await imagen.readAsBytes();
      
      var request = http.MultipartRequest('POST', Uri.parse(REMOVE_BG_API_URL))
        ..headers['X-Api-Key'] = REMOVE_BG_API_KEY
        ..files.add(http.MultipartFile.fromBytes(
          'image_file',
          bytes,
          filename: 'prenda.jpg',
          contentType: MediaType('image', 'jpg'),
        ))
        ..fields['size'] = 'auto';

      final response = await request.send();

      if (response.statusCode == 200) {
        final pngBytes = await response.stream.toBytes();
        
        setState(() {
          _imagenesProcesadas.add(pngBytes);
        });

        // Redirigir cuando todas las imágenes estén procesadas
        if (_imagenesProcesadas.length == _imagenesOriginales.length) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DatosPrenda(imagenes: _imagenesProcesadas),
            ),
          );
        }
      } else {
        final errorBody = await response.stream.bytesToString();
        throw Exception('Error ${response.statusCode}: $errorBody');
      }
    } catch (e) {
      setState(() {
        _error = 'Error al procesar imagen: ${e.toString()}';
      });
      debugPrint('Error en Remove.bg: $e');
    }
  }

  Widget _buildOpcion(IconData icono, String texto, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icono, size: 40, color: Colors.blue),
          const SizedBox(height: 8),
          Text(texto, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar prendas'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          if (_procesando) ...[
            const LinearProgressIndicator(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Procesando imágenes...'),
            ),
          ],
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOpcion(Icons.photo_library, 'Rollo fotográfico', _seleccionarImagenesGaleriaConPermiso),
                _buildOpcion(Icons.camera_alt, 'Tomar foto', _tomarFotoConPermiso),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _imagenesProcesadas.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera, size: 50, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No hay imágenes seleccionadas'),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _imagenesProcesadas.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey[200], // Fondo para ver la transparencia
                        ),
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: MemoryImage(_imagenesProcesadas[index]),
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}