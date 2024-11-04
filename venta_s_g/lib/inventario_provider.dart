import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventarioProvider with ChangeNotifier {
  List<Map<String, dynamic>> _productosPantalla1 = [];
  List<Map<String, dynamic>> _productosPantalla2 = [];
  List<Map<String, dynamic>> _productosPantalla3 = [];

  List<Map<String, dynamic>> get productosPantalla1 => _productosPantalla1;
  List<Map<String, dynamic>> get productosPantalla2 => _productosPantalla2;
  List<Map<String, dynamic>> get productosPantalla3 => _productosPantalla3;

  InventarioProvider() {
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    final prefs = await SharedPreferences.getInstance();
    final productosString1 = prefs.getString('productos_pantalla1');
    final productosString2 = prefs.getString('productos_pantalla2');
    final productosString3 = prefs.getString('productos_pantalla3');

    if (productosString1 != null) {
      _productosPantalla1 =
          List<Map<String, dynamic>>.from(json.decode(productosString1));
    }

    if (productosString2 != null) {
      _productosPantalla2 =
          List<Map<String, dynamic>>.from(json.decode(productosString2));
    }

    if (productosString3 != null) {
      _productosPantalla3 =
          List<Map<String, dynamic>>.from(json.decode(productosString3));
    }

    notifyListeners();
  }

  Future<void> _guardarProductos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('productos_pantalla1', json.encode(_productosPantalla1));
    prefs.setString('productos_pantalla2', json.encode(_productosPantalla2));
    prefs.setString('productos_pantalla3', json.encode(_productosPantalla3));
  }

  void agregarProductoPantalla1(Map<String, dynamic> producto) {
    _productosPantalla1.add(producto);
    _guardarProductos();
    notifyListeners();
  }

  void agregarProductoPantalla2(Map<String, dynamic> producto) {
    _productosPantalla2.add(producto);
    _guardarProductos();
    notifyListeners();
  }

  void agregarProductoPantalla3(Map<String, dynamic> producto) {
    _productosPantalla3.add(producto);
    _guardarProductos();
    notifyListeners();
  }

  void editarProductoPantalla1(int index, Map<String, dynamic> nuevoProducto) {
    _productosPantalla1[index] = nuevoProducto;
    _guardarProductos();
    notifyListeners();
  }

  void editarProductoPantalla2(int index, Map<String, dynamic> nuevoProducto) {
    _productosPantalla2[index] = nuevoProducto;
    _guardarProductos();
    notifyListeners();
  }

  void editarProductoPantalla3(int index, Map<String, dynamic> nuevoProducto) {
    _productosPantalla3[index] = nuevoProducto;
    _guardarProductos();
    notifyListeners();
  }

  void eliminarProductoPantalla1(int index) {
    _productosPantalla1.removeAt(index);
    _guardarProductos();
    notifyListeners();
  }

  void eliminarProductoPantalla2(int index) {
    _productosPantalla2.removeAt(index);
    _guardarProductos();
    notifyListeners();
  }

  void eliminarProductoPantalla3(int index) {
    _productosPantalla3.removeAt(index);
    _guardarProductos();
    notifyListeners();
  }
}
