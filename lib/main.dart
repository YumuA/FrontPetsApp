import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Local {
  int idLocal;
  String nombre;
  String direccion;

  Local({
    required this.idLocal,
    required this.nombre,
    required this.direccion,
  });

  factory Local.fromJson(Map<String, dynamic> json) {
    return Local(
      idLocal: json['id_local'],
      nombre: json['nombre'],
      direccion: json['direccion'],
    );
  }
}

class LocalApi {
  final String apiUrl;

  LocalApi({required this.apiUrl});

  Future<List<Local>> getLocales() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Local> locales = data.map((json) => Local.fromJson(json)).toList();

        return locales;
      } else {
        throw Exception('Error en la solicitud HTTP');
      }
    } catch (error) {
      print('Error loading locales: $error');
      rethrow;
    }
  }
}

class MyHomePage extends StatefulWidget {
  final LocalApi localApi;

  const MyHomePage({super.key, required this.localApi});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Local>> futureLocales;

  @override
  void initState() {
    super.initState();
    futureLocales = widget.localApi.getLocales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Locales'),
      ),
      body: FutureBuilder(
        future: futureLocales,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Local> locales = snapshot.data as List<Local>;
            return ListView.builder(
              itemCount: locales.length,
              itemBuilder: (context, index) {
                Local local = locales[index];
                return ListTile(
                  title: Text(local.nombre),
                  subtitle: Text('Dirección: ${local.direccion}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LocalApi localApi = LocalApi(apiUrl: 'http://192.168.56.1/api/api/locales/');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(localApi: localApi),
    );
  }
}
