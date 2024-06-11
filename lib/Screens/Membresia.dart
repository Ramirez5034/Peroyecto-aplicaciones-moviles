// ignore_for_file: use_key_in_widget_constructors, avoid_print, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AgregarMembresia.dart';
import 'ActualizarMembresia.dart';

class Membresias extends StatefulWidget {
  @override
  _MembresiasState createState() => _MembresiasState();
}

class _MembresiasState extends State<Membresias> {
  List<dynamic> membresias = [];

  @override
  void initState() {
    super.initState();
    fetchMembresias();
  }

  Future<void> fetchMembresias() async {
    final response = await http.get(Uri.parse('http://192.168.7.140:5172/api/Membresia'));

    if (response.statusCode == 200) {
      setState(() {
        // Filtra las membresías para mostrar solo las activas
        membresias = json.decode(response.body).where((membresia) => membresia['status'] == true).toList();
      });
    } else {
      throw Exception('Failed to load membresias');
    }
  }

  Future<void> deleteMembresia(int id) async {
    try {
      final response = await _putWithTimeout(
        Uri.parse('http://192.168.7.140:5172/Membresia/inactivar/$id'),
        duration: const Duration(seconds: 60), // Establece el tiempo de espera aquí
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        setState(() {
          final index = membresias.indexWhere((membresia) => membresia['idmembresia'] == id);
          if (index != -1) {
            membresias[index]['status'] = false;
          } else {
            throw Exception('Failed to find membresia with id $id');
          }
        });
      } else {
        throw Exception('Failed to delete membresia. Status code: ${response.statusCode}, Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete membresia: $e');
    }
  }

  Future<http.Response> _putWithTimeout(Uri url, {Duration duration = const Duration(seconds: 5)}) {
    return http.put(url).timeout(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Membresías'),
      ),
      body: ListView.builder(
        itemCount: membresias.length,
        itemBuilder: (context, index) {
          final membresia = membresias[index];
          if (membresia['status'] == false) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text('ID Membresía: ${membresia['idmembresia']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número: ${membresia['numero']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Tipo: ${membresia['tipo']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Premia: ${membresia['premia']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActualizarMembresia(membresia: membresia),
                          ),
                        ).then((value) => fetchMembresias());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteMembresia(membresia['idmembresia']),
                    ),
                  ],
                ),
              ),
              if (membresia['status'] == true)
                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 163, 163, 165),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarMembresia()),
          ).then((value) => fetchMembresias());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
