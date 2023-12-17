import 'dart:convert';
import 'package:http/http.dart' as http;

class ClienteApi {
  final String baseUrl; // URL de tu backend

  ClienteApi(this.baseUrl);

  Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/api/users/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clientes');
    }
  }

  Future<Cliente> createCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/clientes/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );

    if (response.statusCode == 201) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create cliente');
    }
  }
}

class Cliente {
  final String nombre;
  final String correo;

  Cliente({required this.nombre, required this.correo});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nombre: json['first_name'] ?? '', // Ajusta según la estructura de tu respuesta
      correo: json['email'] ?? '', // Ajusta según la estructura de tu respuesta
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
    };
  }
}
