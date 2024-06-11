import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AgregarProveedor.dart';
import 'ActualizarProveedor.dart';

class Proveedores extends StatefulWidget {
  @override
  _ProveedoresState createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  List<dynamic> proveedores = [];

  @override
  void initState() {
    super.initState();
    fetchProveedores();
  }

  Future<void> fetchProveedores() async {
    final response = await http.get(Uri.parse('http://10.0.0.119:5172/api/Proveedor'));

    if (response.statusCode == 200) {
      setState(() {
        // Filtra los proveedores para mostrar solo los activos
        proveedores = json.decode(response.body).where((proveedor) => proveedor['status'] == true).toList();
      });
    } else {
      throw Exception('Failed to load proveedores');
    }
  }

  Future<void> deleteProveedor(int id) async {
    try {
      final response = await _putWithTimeout(
        Uri.parse('http://10.0.0.119:5172/api/Proveedor/inactivar/$id'),
        duration: const Duration(seconds: 60), // Establece el tiempo de espera aquí
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        setState(() {
          final index = proveedores.indexWhere((proveedor) => proveedor['idProveedor'] == id);
          if (index != -1) {
            proveedores[index]['status'] = false;
          } else {
            throw Exception('Failed to find proveedor with id $id');
          }
        });
      } else {
        throw Exception('Failed to delete proveedor. Status code: ${response.statusCode}, Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete proveedor: $e');
    }
  }

  Future<http.Response> _putWithTimeout(Uri url, {Duration duration = const Duration(seconds: 5)}) {
    return http.put(url).timeout(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Proveedores'),
      ),
      body: ListView.builder(
        itemCount: proveedores.length,
        itemBuilder: (context, index) {
          final proveedor = proveedores[index];
          if (proveedor['status'] == false) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text('ID Proveedor: ${proveedor['idProveedor']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${proveedor['nombre']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Teléfono: ${proveedor['telefono']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Administrador: ${proveedor['administrador']}',
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
                            builder: (context) => ActualizarProveedor(proveedor: proveedor),
                          ),
                        ).then((value) => fetchProveedores());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteProveedor(proveedor['idProveedor']),
                    ),
                  ],
                ),
              ),
              if (proveedor['status'] == true)
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
            MaterialPageRoute(builder: (context) => AgregarProveedor()),
          ).then((value) => fetchProveedores());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

