import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venta_s_g/inventario_provider.dart';

class AnadirProductoScreen extends StatefulWidget {
  final int? index;
  final Map<String, dynamic>? producto;

  AnadirProductoScreen({this.index, this.producto});

  @override
  _AnadirProductoScreenState createState() => _AnadirProductoScreenState();
}

class _AnadirProductoScreenState extends State<AnadirProductoScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  String? tipoProducto;
  String? peso;
  bool pagado = false;
  bool entregado = false;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      // Si estamos en modo de edición, cargar los datos existentes
      nombreController.text = widget.producto!['nombre'];
      cantidadController.text = widget.producto!['cantidad'].toString();
      tipoProducto = widget.producto!['tipoProducto'];
      peso = widget.producto!['peso'];
      pagado = widget.producto!['pagado'];
      entregado = widget.producto!['entregado'];
    }
  }

  double _calcularPrecioTotal(int cantidad, String peso) {
    if (peso == '500 kg') {
      return cantidad * 3500.0;
    } else if (peso == '250 kg') {
      return cantidad * 1750.0;
    }
    return 0.0; // Por defecto
  }

  @override
  Widget build(BuildContext context) {
    final inventarioProvider =
        Provider.of<InventarioProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.producto != null ? 'Editar Producto' : 'Añadir Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: tipoProducto,
              hint: Text('Tipo de Producto'),
              items: [
                DropdownMenuItem(value: 'Grano', child: Text('Grano')),
                DropdownMenuItem(value: 'Molido', child: Text('Molido')),
              ],
              onChanged: (value) {
                setState(() {
                  tipoProducto = value;
                });
              },
            ),
            DropdownButton<String>(
              value: peso,
              hint: Text('Peso'),
              items: [
                DropdownMenuItem(value: '500 kg', child: Text('500 kg')),
                DropdownMenuItem(value: '250 kg', child: Text('250 kg')),
              ],
              onChanged: (value) {
                setState(() {
                  peso = value;
                });
              },
            ),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre de la Persona'),
            ),
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cantidad'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: pagado,
                      onChanged: (value) {
                        setState(() {
                          pagado = value!;
                        });
                      },
                    ),
                    Text('Pagado'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: entregado,
                      onChanged: (value) {
                        setState(() {
                          entregado = value!;
                        });
                      },
                    ),
                    Text('Entregado'),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                final cantidad = int.parse(cantidadController.text);
                final precioTotal = _calcularPrecioTotal(cantidad, peso!);

                final producto = {
                  'nombre': nombreController.text,
                  'cantidad': cantidad,
                  'tipoProducto': tipoProducto,
                  'peso': peso,
                  'pagado': pagado,
                  'entregado': entregado,
                  'precioTotal': precioTotal,
                };

                if (widget.index != null) {
                  // Modo edición
                  inventarioProvider.editarProductoPantalla1(
                      widget.index!, producto);
                } else {
                  // Modo añadir
                  inventarioProvider.agregarProductoPantalla1(producto);
                }

                Navigator.pop(context);
              },
              child: Text(widget.producto != null
                  ? 'Guardar Cambios'
                  : 'Añadir Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
