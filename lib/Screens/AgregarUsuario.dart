import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarUsuario extends StatefulWidget {
  const AgregarUsuario({Key? key}) : super(key: key);

  @override
  _AgregarUsuarioState createState() => _AgregarUsuarioState();
}

class _AgregarUsuarioState extends State<AgregarUsuario> {
  final _formKey = GlobalKey<FormState>();
  late String numEmpleado;
  late String nombre;
  late String contrasena;

  Future<void> agregarUsuario() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.7.140:5172/api/Usuario'), 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'numEmpleado': numEmpleado,
          'nombre': nombre,
          'contrasena': contrasena,
          'status': true, // Aquí se establece el status como true
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to add usuario. Response: ${response.body}');
        throw Exception('Failed to add usuario. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Número de Empleado'),
                onChanged: (value) {
                  setState(() {
                    numEmpleado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número de empleado';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
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
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
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
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    agregarUsuario();
                  }
                },
                child: Text('Agregar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
