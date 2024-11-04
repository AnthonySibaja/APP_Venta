import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venta_s_g/inventario_provider.dart';
import 'AnadirProductoScreen.dart';

class Pantalla3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inventarioProvider = Provider.of<InventarioProvider>(context);

    final totalPrecio = inventarioProvider.productosPantalla3.fold<double>(
      0,
      (sum, producto) => sum + (producto['precioTotal'] ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Precio: \$${totalPrecio.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inventarioProvider.productosPantalla3.length,
              itemBuilder: (context, index) {
                final producto = inventarioProvider.productosPantalla3[index];
                return ListTile(
                  title: Text(producto['nombre']),
                  subtitle: Text(
                      'Cantidad: ${producto['cantidad']} - Precio Total: \$${producto['precioTotal']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnadirProductoScreen(
                                index: index,
                                producto: producto,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirmar Eliminación'),
                                content: Text(
                                    '¿Estás seguro de que deseas eliminar este producto?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cerrar el diálogo
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      inventarioProvider
                                          .eliminarProductoPantalla3(index);
                                      Navigator.of(context)
                                          .pop(); // Cerrar el diálogo
                                    },
                                    child: Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnadirProductoScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}