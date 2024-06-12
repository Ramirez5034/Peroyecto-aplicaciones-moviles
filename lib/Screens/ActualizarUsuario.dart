import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActualizarUsuario extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const ActualizarUsuario({super.key, required this.usuario});

  @override
  _ActualizarUsuarioState createState() => _ActualizarUsuarioState();
}

class _ActualizarUsuarioState extends State<ActualizarUsuario> {
  final _formKey = GlobalKey<FormState>();
  late int numEmpleado;
  late String nombre;
  late String contrasena;
  late int idUsuario;

  @override
  void initState() {
    super.initState();
    idUsuario = widget.usuario['idusuario'];
    numEmpleado = widget.usuario['numEmpleado'] as int; 
    nombre = widget.usuario['nombre'];
    contrasena = widget.usuario['contrasena'];
  }

  Future<void> actualizarUsuario() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.7.140:5172/api/Usuario/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idUsuario': idUsuario,
          'numEmpleado': numEmpleado,
          'nombre': nombre,
          'contrasena': contrasena,
          'status': true,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to edit usuario. Response: ${response.body}');
        throw Exception('Failed to edit usuario. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: numEmpleado.toString(), // Convert to string
                decoration: InputDecoration(labelText: 'NumEmpleado'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    numEmpleado = int.tryParse(value) ?? 0; // Convert to int
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número de empleado';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    nombre = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: contrasena,
                decoration: InputDecoration(labelText: 'Contrasena'),
                onChanged: (value) {
                  setState(() {
                    contrasena = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    actualizarUsuario();
                  }
                },
                child: Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

