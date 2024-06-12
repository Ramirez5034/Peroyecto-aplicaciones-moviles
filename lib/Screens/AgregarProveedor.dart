import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgregarProveedor extends StatefulWidget {
  @override
  _AgregarProveedorState createState() => _AgregarProveedorState();
}

class _AgregarProveedorState extends State<AgregarProveedor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _administradorController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  Future<void> _agregarProveedor() async {
    if (_formKey.currentState!.validate()) {
      final String nombre = _nombreController.text;
      final String telefono = _telefonoController.text;
      final String administrador = _administradorController.text;
      final String status = _statusController.text;
      
      try {
        bool statusBool = status == 1 ? true : false;

        final response = await http.post(
          Uri.parse('http://10.0.0.119:5172/api/Proveedor'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'Nombre': nombre,
            'Telefono': telefono,
            'Administrador': administrador,
            'Status': statusBool,
          }),
        );

        if (response.statusCode == 201) {
          Navigator.pop(context); 
        } else {
          throw Exception('Error al agregar proveedor: Status code: ${response.statusCode}, Response body: ${response.body}');
        }
      } catch (e) {
        throw Exception('Error al agregar proveedor: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _administradorController,
                decoration: const InputDecoration(labelText: 'Administrador'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un administrador';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarProveedor,
                child: const Text('Agregar Proveedor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
