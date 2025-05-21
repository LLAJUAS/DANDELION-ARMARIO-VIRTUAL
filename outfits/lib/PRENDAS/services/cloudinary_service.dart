import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryUploadService {
  static const String cloudName = 'dzqaik9jd';  // Nombre de tu Cloudinary
  static const String uploadPreset = 'ml_default'; // Asegúrate de que este preset esté correctamente configurado
  static const String apiKey = '771926963979614';  // Reemplaza con tu API Key correcta

  static Future<String> subirImagen(Uint8List imageBytes) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..fields['api_key'] = apiKey  // API Key incluida
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'prenda_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonData = jsonDecode(respStr);
        return jsonData['secure_url'];  // Devuelve la URL segura de la imagen subida
      } else {
        final respStr = await response.stream.bytesToString();
        final errorData = jsonDecode(respStr);
        throw Exception('Error al subir imagen: ${errorData['error']['message']}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
