import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActualizarProveedor extends StatefulWidget {
  final Map<String, dynamic> proveedor;

  const ActualizarProveedor({Key? key, required this.proveedor}) : super(key: key);

  @override
  _ActualizarProveedorState createState() => _ActualizarProveedorState();
}

class _ActualizarProveedorState extends State<ActualizarProveedor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _telefonoController;
  late TextEditingController _administradorController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.proveedor['nombre']);
    _telefonoController = TextEditingController(text: widget.proveedor['telefono']);
    _administradorController = TextEditingController(text: widget.proveedor['administrador']);
  }

  Future<void> _actualizarProveedor() async {
    if (_formKey.currentState!.validate()) {
      final String nombre = _nombreController.text;
      final String telefono = _telefonoController.text;
      final String administrador = _administradorController.text;
      final int id = widget.proveedor['idProveedor'];

      final response = await http.put(
        Uri.parse('http://10.0.0.119:5172/api/Proveedor/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idProveedor': id,
          'Nombre': nombre,
          'Telefono': telefono,
          'Administrador': administrador,
          'Status': widget.proveedor['status'], // Mantiene el estado original
        }),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        Navigator.pop(context); // Regresar a la lista de proveedores después de actualizar el proveedor
      } else {
        throw Exception('Failed to update proveedor');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _administradorController,
                decoration: InputDecoration(labelText: 'Administrador'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un administrador';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _actualizarProveedor,
                child: Text('Actualizar Proveedor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

