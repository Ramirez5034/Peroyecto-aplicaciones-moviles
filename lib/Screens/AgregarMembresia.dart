// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarMembresia extends StatefulWidget {
  const AgregarMembresia({Key? key}) : super(key: key);

  @override
  _AgregarMembresiaState createState() => _AgregarMembresiaState();
}

class _AgregarMembresiaState extends State<AgregarMembresia> {
  final _formKey = GlobalKey<FormState>();
  String numero = '';
  String tipo = '';
  bool? premia; 
  int status = 1;

  Future<void> agregarMembresia() async {
    try {
       bool statusBool = status == 1 ? true : false;

      final response = await http.post(
        Uri.parse('http://192.168.7.140:5172/api/Membresia'), 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'numero': numero,
          'tipo': tipo,
          'premia': premia,
          'status': statusBool,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to add membresia. Response: ${response.body}');
        throw Exception('Failed to add membresia. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Membresía'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Número'),
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
              Row(
                children: [
                  Text('Premia: '),
                  Checkbox(
                    value: premia,
                    tristate: true,
                    onChanged: (value) {
                      setState(() {
                        premia = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    agregarMembresia();
                  }
                },
                child: Text('Agregar Membresía'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
