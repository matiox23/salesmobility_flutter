import 'dart:async';
import 'dart:convert';

import 'package:flutter_app_users/models/busqueda_ubigeo_model.dart';
import 'package:flutter_app_users/models/channel_map_model.dart';
import 'package:flutter_app_users/models/cliente_ruta_model.dart';
import 'package:flutter_app_users/models/inventario_model.dart';
import 'package:flutter_app_users/models/linea_model.dart';
import 'package:flutter_app_users/models/marca_model.dart';
import 'package:flutter_app_users/models/models.dart';
import 'package:flutter_app_users/models/motivo_no_compra.dart';
import 'package:flutter_app_users/models/motivo_visita_model.dart';
import 'package:flutter_app_users/models/pedido_cliente_tab_model.dart';
import 'package:flutter_app_users/models/presentacion_model.dart';
import 'package:flutter_app_users/models/producto_model.dart';
import 'package:flutter_app_users/models/resumen_diario.dart';
import 'package:flutter_app_users/models/ruta_gps_model.dart';
import 'package:flutter_app_users/models/tipo_establecimiento_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';

class HttpServices {
  static String _urlBase = "";
  static String _token = "";

  HttpServices() {
    _urlBase = 'https://services.salesmobilitytools.com/api/v1/';
    _token = '';
  }

  Future<List<LineaModel>> getAllBusinessLine() async {
    List<LineaModel> defaultBusinessLine = [
      LineaModel(lineaId: 1, dLinea: 'PVL'),
      LineaModel(lineaId: 2, dLinea: 'CVL'),
      LineaModel(lineaId: 3, dLinea: 'MCO')
    ];

    return defaultBusinessLine;
  }

  Future<List<LineaModel>> listarLineasNegocios() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('AccessToken') ?? '';
    //developer.log('listarLineasNegocios: $_token', name: 'my.app.developer');

    final response = await http
        .get(Uri.parse('$_urlBase/tomas/producto/linea?canalId=1'), headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json; charset=UTF-8'
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => LineaModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<TipoEstablecimientoModel>> listarTipoEstablecimiento() async {
/*     try {
 */
    final prefs = await SharedPreferences.getInstance();
    /* .then((value) {
      _token = value.getString('code') ?? '';
      developer.log('token_code: $_token', name: 'my.app.developer');
    }); */
    _token = prefs.getString('AccessToken') ?? '';
    //developer.log('token_code: $_token', name: 'my.app.developer');

    final response = await http
        .get(Uri.parse('$_urlBase/tomas/tipoestablecimiento'), headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json; charset=UTF-8'
    });

/*     response.request!.headers.forEach((key, value) {
      developer.log('key: $key - value: $value', name: 'my.app.developer');
    }); */

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData
            .map((tipoEstablecimientoItem) =>
                TipoEstablecimientoModel.fromJson(tipoEstablecimientoItem))
            .toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
/*     } catch (e) {
      // Captura cualquier excepción que ocurra durante la llamada a la API
      // Puedes lanzar una excepción personalizada o manejar el error de otra manera según tus necesidades.
      throw Exception('Status Code Server: $e');
    } */
  }

  Future<List<BusquedaUbigeoModel>> listarDepartamento() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    //developer.log('token_code: $_token', name: 'my.app.developer');

    final response =
        await http.get(Uri.parse('$_urlBase/agentes/departamentos'), headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json; charset=UTF-8'
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData
            .map((busquedaUbigeoModelItem) =>
                BusquedaUbigeoModel.fromJson(busquedaUbigeoModelItem))
            .toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<BusquedaUbigeoModel>> listarProvincia(
      String codigoDepartamento) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log('http - codigoDepartamento: $codigoDepartamento',
        name: 'my.app.developer');

    final response = await http.get(
        Uri.parse(
            '$_urlBase/agentes/provincias?codigodepartamento=$codigoDepartamento'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData
            .map((busquedaUbigeoModelItem) =>
                BusquedaUbigeoModel.fromJson(busquedaUbigeoModelItem))
            .toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<MarcaModel>> listarMarcas(int lineaId) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log('http - lineaId: $lineaId', name: 'my.app.developer');

    final response = await http.get(
        Uri.parse('$_urlBase/tomas/lineaMarca?lineaId=$lineaId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => MarcaModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<ProductoModel>> listarProductos(int lineaId, int marcaId) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log('http - lineaId: $lineaId - marcaId: $marcaId',
        name: 'my.app.developer');

    final response = await http.get(
        Uri.parse(
            '$_urlBase/tomas/producto/listar?nombre=&Linea_Id=$lineaId&Marca_Id=$marcaId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => ProductoModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<PresentacionModel>> listarPresentaciones(
      int lineaId, int marcaId, int productoId) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    //_token = '';

    developer.log(
        'http - lineaId: $lineaId - marcaId: $marcaId - productoId: $productoId',
        name: 'my.app.developer');

    final response = await http.get(
        Uri.parse(
            '$_urlBase/tomas/producto?lineaId=$lineaId&usoAceiteId=0&tipoAceiteId=0&marcaId=$marcaId&productoId=$productoId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData
            .map((item) => PresentacionModel.fromJson(item))
            .toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<bool> guardarPrecios(String json, String uuid) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';

    final response = await http.post(Uri.parse('$_urlBase/tomas/precios'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8',
          'x-requestid': uuid
        },
        body: json);

    if (response.statusCode == 200) {
      developer.log('Respuesta del Post: ${response.body}',
          name: 'my.app.developer');
      return true;
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<bool> guardarChannelMap(String json, String uuid) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';

    final response =
        await http.post(Uri.parse('$_urlBase/olaschannelmap/tomas'),
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json; charset=UTF-8',
              'x-requestid': uuid
            },
            body: json);

    if (response.statusCode == 201) {
      developer.log('Respuesta del Post: ${response.body}',
          name: 'my.app.developer');
      return true;
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<ClienteRutaModel>> listarClienteRutas(
      String nombreCliente) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log('http - listarClienteRutas: $nombreCliente',
        name: 'my.app.developer');

    final response = await http.get(
        Uri.parse('$_urlBase/vendedores/ruta/diaria?nombre=$nombreCliente'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => ClienteRutaModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<ClienteRutaModel>> listarClienteFueraRuta() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log('http - listarClienteFueraRuta', name: 'my.app.developer');

    final response = await http
        .get(Uri.parse('$_urlBase/vendedores/ruta/fueraruta'), headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json; charset=UTF-8'
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => ClienteRutaModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<ClienteRutaModel>> listarBuscarTodosClientesFueraRuta(
      String nombreCliente) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log('http - listarClienteFueraRuta', name: 'my.app.developer');

    final response = await http.get(
        Uri.parse('$_urlBase/clientes?nombre=$nombreCliente&todosClientes=0'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => ClienteRutaModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<ResumenDiarioModel>> listarResumenDiario() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';

    final response = await http
        .get(Uri.parse('$_urlBase/reportes/vendedor/avance'), headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json; charset=UTF-8'
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData
            .map((item) => ResumenDiarioModel.fromJson(item))
            .toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<ChannelMapModel>> listarChannelMapMarcas(
      int clienteSucurcalId, int prospectoClienteId) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log(
        'http - listarChannelMapMarcas: $clienteSucurcalId - $prospectoClienteId',
        name: 'my.app.developer');

    final response = await http.get(
        Uri.parse(
            '$_urlBase/marcas/parachannelmap?ClienteSucursalId=$clienteSucurcalId&ProspectoClienteId=$prospectoClienteId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => ChannelMapModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<InventarioModel>> listarInventariosProductos(
      String nombreProducto) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log('http - listarInventariosProductos: $nombreProducto',
        name: 'my.app.developer');

    final response = await http.get(
        Uri.parse(
            '$_urlBase/productos/productostockprecio?nombre=$nombreProducto&listaprecio=0'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => InventarioModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<Position> getCoordinates() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 90),
      );
      return position;
    } on TimeoutException {
      // Se lanza cuando la obtención de la ubicación lleva demasiado tiempo.
      throw 'Tiempo de espera agotado al obtener la ubicación.';
    } on LocationServiceDisabledException {
      // Se lanza cuando los servicios de ubicación del dispositivo están desactivados.
      throw 'Los servicios de ubicación están desactivados.';
    } catch (e) {
      // Otras excepciones generales.
      throw 'Error al obtener la ubicación: $e';
    }
  }

  Future<List<RutaGpsModel>> listarRutaGps() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log('http - listarRutaGps', name: 'my.app.developer');

    final response = await http
        .get(Uri.parse('$_urlBase/vendedores/ruta/diariagps'), headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json; charset=UTF-8'
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map((item) => RutaGpsModel.fromJson(item)).toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<PedidoClienteTabModel>> listarTabPedidosClientes(
      String fechaInicial, String fechaFinal) async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';
    developer.log(
        'http - listarTabPedidosClientes - $fechaInicial - $fechaFinal',
        name: 'my.app.developer');

    final response = await http.get(
        Uri.parse(
            '$_urlBase/pedidos/pedidoscliente?clienteId=0&desde=$fechaInicial&hasta=$fechaFinal'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData
            .map((item) => PedidoClienteTabModel.fromJson(item))
            .toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

  Future<List<MotivoVisitaModel>> listarMotivoVisita() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';

    final response = await http
        .get(Uri.parse('$_urlBase/visitas/motivosvisita'), headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json; charset=UTF-8'
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData
            .map((item) => MotivoVisitaModel.fromJson(item))
            .toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }

    Future<List<MotivoNoCompraModel>> listarMotivoNoCompra() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('AccessToken') ?? '';

    final response = await http
        .get(Uri.parse('$_urlBase/visitas/motivosnocompra'), headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json; charset=UTF-8'
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData
            .map((item) => MotivoNoCompraModel.fromJson(item))
            .toList();
      } else {
        // Manejar la respuesta vacía aquí
        return [];
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }
}
