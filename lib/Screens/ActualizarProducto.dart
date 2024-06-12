// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActualizarProducto extends StatefulWidget {
  final Map<String, dynamic> producto;

  const ActualizarProducto({super.key, required this.producto});

  @override
  _ActualizarProductoState createState() => _ActualizarProductoState();
}

class _ActualizarProductoState extends State<ActualizarProducto> {
  final _formKey = GlobalKey<FormState>();
  late String clave;
  late String nombre;
  late int precio;
  late int cantidad;

  @override
  void initState() {
    super.initState();
    
    clave = widget.producto['clave'].toString();
    nombre = widget.producto['nombre'];
    precio = widget.producto['precio'];
    cantidad = widget.producto['cantidad'];
  }

  Future<void> actualizarProducto() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.7.140:5172/api/Producto/${widget.producto['idProducto']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idProducto': widget.producto['idProducto'],
          'clave': clave,
          'nombre': nombre,
          'precio': precio,
          'cantidad': cantidad,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to edit producto. Response: ${response.body}');
        throw Exception('Failed to edit producto. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Producto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: clave,
                decoration: InputDecoration(labelText: 'Clave'),
                onChanged: (value) {
                  setState(() {
                    clave = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la clave';
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
                initialValue: precio.toString(),
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    precio = int.tryParse(value) ?? precio;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: cantidad.toString(),
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cantidad = int.tryParse(value) ?? cantidad;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    actualizarProducto();
                  }
                },
                child: Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
