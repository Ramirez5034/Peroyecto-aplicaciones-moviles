// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActualizarMembresia extends StatefulWidget {
  final Map<String, dynamic> membresia;

  const ActualizarMembresia({super.key, required this.membresia});

  @override
  // ignore: library_private_types_in_public_api
  _ActualizarMembresiaState createState() => _ActualizarMembresiaState();
}

class _ActualizarMembresiaState extends State<ActualizarMembresia> {
  final _formKey = GlobalKey<FormState>();
  late String numero;
  late String tipo;
  late bool premia; // Cambio aquí para asegurar que es booleano

  @override
  void initState() {
    super.initState();
    numero = widget.membresia['numero'].toString(); // Asegurar que es una cadena
    tipo = widget.membresia['tipo'];
    premia = widget.membresia['premia'] == 1; // Convertir de int a bool si es necesario
  }

  Future<void> actualizarMembresia() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.7.140:5172/api/Membresia/${widget.membresia['idmembresia']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idmembresia': widget.membresia['idmembresia'],
          'numero': numero,
          'tipo': tipo,
          'premia': premia,
        
        }),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        print('Failed to edit membresia. Response: ${response.body}');
        throw Exception('Failed to edit membresia. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Membresía'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: numero,
                decoration: InputDecoration(labelText: 'Número'),
                keyboardType: TextInputType.number, // Para asegurar que solo se ingresen números
                onChanged: (value) {
                  setState(() {
                    numero = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: tipo,
                decoration: InputDecoration(labelText: 'Tipo'),
                onChanged: (value) {
                  setState(() {
                    tipo = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el tipo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Premia'),
                value: premia,
                onChanged: (value) {
                  setState(() {
                    premia = value ?? false;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    actualizarMembresia();
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
