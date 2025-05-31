import 'dart:io';
import 'package:http/http.dart' as http;

class ImagenService {
  Future<String?> subirImagen(File imagen) async {
    final uri = Uri.parse('http://10.0.2.2:3000/api/imagenes/subir'); // Usa 10.0.2.2 en emulador Android
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      return body; // o decodifica si necesitas la URL
    } else {
      return null;
    }
  }
}

