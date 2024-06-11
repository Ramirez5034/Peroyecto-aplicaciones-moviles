import 'package:flutter/material.dart';
import 'Usuario.dart';
import 'Producto.dart';
import 'Proveedor.dart';
import 'Membresia.dart';


class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Usuarios()),
                );
              },
              child: Text('Usuarios'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Productos()),
                );
              },
              child: Text('Productos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Proveedores()),
                );
              },
              child: Text('Proveedores'),
            ),
             ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Membresias()),
                );
              },
              child: Text('Membresias'),
            ),
  
          ],
        ),
      ),
    );
  }
}
