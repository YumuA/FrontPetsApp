import 'dart:convert';
import 'package:http/http.dart' as http;

class DuenoApi {
  final String baseUrl; // URL de tu backend

  DuenoApi(this.baseUrl);

  Future<List<Dueno>> getDuenos() async {
    final response = await http.get(Uri.parse('$baseUrl/api/dueños/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Dueno.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load duenos');
    }
  }

  Future<Dueno> createDueno(Dueno dueno) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/duenos/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dueno.toJson()),
    );

    if (response.statusCode == 201) {
      return Dueno.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create dueno');
    }
  }
}

class Dueno {
  final int idDueno;
  final String nombre;
  final String contacto;

  Dueno({
    required this.idDueno,
    required this.nombre,
    required this.contacto,
  });

  factory Dueno.fromJson(Map<String, dynamic> json) {
    return Dueno(
      idDueno: json['id_dueño'] ?? 0,
      nombre: json['nombre'] ?? '',
      contacto: json['contacto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_dueno': idDueno,
      'nombre': nombre,
      'contacto': contacto,
    };
  }
}
