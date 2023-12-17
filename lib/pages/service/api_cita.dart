import 'dart:convert';
import 'package:http/http.dart' as http;

class CitaApi {
  final String baseUrl; // URL de tu backend

  CitaApi(this.baseUrl);

  Future<List<Cita>> getCitas() async {
    final response = await http.get(Uri.parse('$baseUrl/citas/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cita.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load citas');
    }
  }

  Future<Cita> createCita(Cita cita) async {
    final response = await http.post(
      Uri.parse('$baseUrl/citas/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cita.toJson()),
    );

    if (response.statusCode == 201) {
      return Cita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create cita');
    }
  }
}

class Cita {
  final String fecha;
  final String hora;
  final int mascotaId; // Asegúrate de tener la estructura correcta según tu backend

  Cita({required this.fecha, required this.hora, required this.mascotaId});

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      fecha: json['fecha'],
      hora: json['hora'],
      mascotaId: json['mascota_id'], // Ajusta según tu backend
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha,
      'hora': hora,
      'mascota_id': mascotaId,
    };
  }
}
