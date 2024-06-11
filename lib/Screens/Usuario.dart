import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AgregarUsuario.dart';
import 'ActualizarUsuario.dart';

class Usuarios extends StatefulWidget {
  @override
  _UsuariosState createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
  }

  Future<void> fetchUsuarios() async {
    final response = await http.get(Uri.parse('http://192.168.7.140:5172/api/Usuario'));

    if (response.statusCode == 200) {
      final List<dynamic> usuariosList = json.decode(response.body);
      print('Usuarios list fetched: $usuariosList'); // Debug print

      // Print each user to verify the structure
      usuariosList.forEach((usuario) {
        print('Usuario fetched: $usuario');
      });

      setState(() {
        usuarios = usuariosList.where((usuario) => usuario['status'] == true).toList();
      });
    } else {
      throw Exception('Failed to load usuarios');
    }
  }

  Future<void> deleteUsuario(int id) async {
    try {
      final response = await _putWithTimeout(
        Uri.parse('http://192.168.7.140:5172/api/Usuario/inactivar/$id'),
        duration: const Duration(seconds: 60),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        setState(() {
          final index = usuarios.indexWhere((usuario) => usuario['idusuario'] == id);
          if (index != -1) {
            usuarios[index]['status'] = false;
          } else {
            throw Exception('Failed to find usuario with id $id');
          }
        });
      } else {
        throw Exception('Failed to delete usuario. Status code: ${response.statusCode}, Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete usuario: $e');
    }
  }

  Future<http.Response> _putWithTimeout(Uri url, {Duration duration = const Duration(seconds: 5)}) {
    return http.put(url).timeout(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          if (usuario['status'] == false) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text('ID Usuario: ${usuario['idusuario']}'), // Campo idUsuario
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NumEmpleado: ${usuario['numEmpleado']}', // Verificar nombre del campo
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Nombre: ${usuario['nombre']}', // Verificar nombre del campo
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Contrasena: ${usuario['contrasena']}', // Verificar nombre del campo
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
                            builder: (context) => ActualizarUsuario(usuario: usuario),
                          ),
                        ).then((value) => fetchUsuarios());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteUsuario(usuario['idusuario']),
                    ),
                  ],
                ),
              ),
              if (usuario['status'] == true)
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
            MaterialPageRoute(builder: (context) => const AgregarUsuario()),
          ).then((value) => fetchUsuarios());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

