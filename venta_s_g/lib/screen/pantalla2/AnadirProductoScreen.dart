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
    switch (peso) {
      case 'Dedos':
        return cantidad * 100.0;
      case 'Kilos':
        return cantidad * 2500.0;
      case 'Rollos':
        return cantidad * 500.0;
      case 'Unidad':
        return cantidad * 500.0;
      case 'Pollo Asado':
        return cantidad * 3000.0;
      default:
        return 0.0; // Valor predeterminado en caso de error
    }
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
                DropdownMenuItem(value: 'Lechuga', child: Text('Lechuga')),
                DropdownMenuItem(value: 'Culantro', child: Text('Culantro')),
                DropdownMenuItem(value: 'Pollo', child: Text('Pollo')),
                DropdownMenuItem(value: 'Cancho', child: Text('Cancho')),
                DropdownMenuItem(value: 'Platanos', child: Text('Plátanos')),
                DropdownMenuItem(value: 'Pollo Asado', child: Text('Pollo Asado')),
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
                DropdownMenuItem(value: 'Dedos', child: Text('Dedos')),
                DropdownMenuItem(value: 'Kilos', child: Text('Kilos')),
                DropdownMenuItem(value: 'Rollos', child: Text('Rollos')),
                DropdownMenuItem(value: 'Unidad', child: Text('Unidad')),
                DropdownMenuItem(value: 'Pollo Asado', child: Text('Pollo Asado')),
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
                  'precioTotal': precioTotal, // Guardar el precio total
                };

                if (widget.index != null) {
                  // Modo edición
                  inventarioProvider.editarProductoPantalla2(
                      widget.index!, producto);
                } else {
                  // Modo añadir
                  inventarioProvider.agregarProductoPantalla2(producto);
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
