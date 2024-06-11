import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AgregarProducto.dart';
import 'ActualizarProducto.dart';

class Productos extends StatefulWidget {
  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  List<dynamic> productos = [];

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    final response = await http.get(Uri.parse('http://192.168.7.140:5172/api/Producto'));

    if (response.statusCode == 200) {
      setState(() {
        // Filtra los productos para mostrar solo los activos
        productos = json.decode(response.body).where((producto) => producto['status'] == true).toList();
      });
    } else {
      throw Exception('Failed to load productos');
    }
  }

  Future<void> deleteProducto(int id) async {
    try {
      final response = await _putWithTimeout(
        Uri.parse('http://192.168.7.140:5172/api/Producto/inactivar/$id'),
        duration: const Duration(seconds: 60), // Establece el tiempo de espera aquí
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        setState(() {
          final index = productos.indexWhere((producto) => producto['idProducto'] == id);
          if (index != -1) {
            productos[index]['status'] = false;
          } else {
            throw Exception('Failed to find producto with id $id');
          }
        });
      } else {
        throw Exception('Failed to delete producto. Status code: ${response.statusCode}, Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete producto: $e');
    }
  }

  Future<http.Response> _putWithTimeout(Uri url, {Duration duration = const Duration(seconds: 5)}) {
    return http.put(url).timeout(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          if (producto['status'] == false) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text('ID Producto: ${producto['idProducto']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clave: ${producto['clave']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Nombre: ${producto['nombre']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Precio: ${producto['precio']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Cantidad: ${producto['cantidad']}',
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
                            builder: (context) => ActualizarProducto(producto: producto),
                          ),
                        ).then((value) => fetchProductos());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteProducto(producto['idProducto']),
                    ),
                  ],
                ),
              ),
              if (producto['status'] == true)
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
            MaterialPageRoute(builder: (context) => const AgregarProducto()),
          ).then((value) => fetchProductos());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
