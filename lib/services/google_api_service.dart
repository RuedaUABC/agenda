import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tarea.dart';

class GoogleApiService {
  final String endpoint = "https://script.google.com/macros/s/.../exec";

  Future<List<Tarea>> fetchTareas() async {
    final response = await http.get(Uri.parse(endpoint));
    final data = jsonDecode(response.body);
    return (data as List).map((json) => Tarea(
      titulo: json['titulo'],
      fecha: DateTime.parse(json['fecha']),
    )).toList();
  }
}
