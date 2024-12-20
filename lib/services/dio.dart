import 'package:dio/dio.dart';
import 'package:flutter_app_users/models/channel_map_model.dart';
import 'package:flutter_app_users/models/cliente_ruta_model.dart';
import 'package:flutter_app_users/models/parametros_agente_model.dart';
import 'package:flutter_app_users/models/resumen_diario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../models/inventario_model.dart';
import '../models/pedido_cliente_tab_model.dart';
import '../models/ruta_gps_model.dart';

class DioServices {
  static const String _urlBase =
      'https://services.salesmobilitytools.com/api/v1/';

  static const String clientId = "SalesMobilityApp";
  static const String addressUrl =
      "https://accounts.salesmobilitytools.com/connect/token";

  Dio dio = Dio(
    BaseOptions(
      baseUrl: _urlBase,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );

  void addInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          String token = prefs.getString('AccessToken') ?? '';

          // Add the access token to the request header
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final prefsUpdate = await SharedPreferences.getInstance();
          String refreshTokenId = prefsUpdate.getString('RefreshToken') ?? '';

          if (e.response?.statusCode == 401) {
            // If a 401 response is received, refresh the access token
            Map<String, dynamic>? jsonToken =
                await refreshToken(refreshTokenId);

            if (jsonToken != null) {
              String tokenId = jsonToken['access_token'];
              String refreshTokenId = jsonToken['refresh_token'];

              prefsUpdate.setString('AccessToken', tokenId);
              prefsUpdate.setString('RefreshToken', refreshTokenId);
              // Update the request header with the new access token
              e.requestOptions.headers['Authorization'] = 'Bearer $tokenId';

              // Repeat the request with the updated header
              return handler.resolve(await dio.fetch(e.requestOptions));
            } else {
              handler.reject(DioException(
                  error:
                      'La solicitud de actualización de token no se completó.',
                  response: e.response,
                  requestOptions: e.requestOptions));
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> refreshToken(String refreshTokenId) async {
    try {
      Response response = await dio.post(
        addressUrl,
        data: {
          "client_id": clientId,
          "grant_type": "refresh_token",
          "refresh_token": refreshTokenId,
        },
        options: Options(
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        developer.log('Response: $response', name: 'my.app.developer');
      }
    } on DioException catch (e) {
      developer.log('Dio Ex: $e', name: 'my.app.developer');
    } catch (e) {
      developer.log('Ex: $e', name: 'my.app.developer');
    }

    return null;
  }

  Future<List<ResumenDiarioModel>> listarResumenDiario() async {
    try {
      Response response = await dio.get(
        '/reportes/vendedor/avance',
        options: Options(
          headers: {
            //'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
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
    } on DioException {
      // Manejar errores de Dio
      throw 'Error de conexión. Por favor, verifica tu conexión a internet.';
    }
  }

  Future<List<ClienteRutaModel>> listarClienteRutas(
      String nombreCliente) async {
    developer.log('API Listar Clientes Rutas', name: 'my.app.developer');
    try {
      final response = await dio.get(
        '/vendedores/ruta/diaria?nombre=$nombreCliente',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        if (jsonData.isNotEmpty) {
          return jsonData
              .map((item) => ClienteRutaModel.fromJson(item))
              .toList();
        } else {
          // Manejar la respuesta vacía aquí
          return [];
        }
      } else {
        // Manejar el código de estado de respuesta no exitoso aquí
        throw 'Status Code Server: ${response.statusCode}';
      }
    } on DioException {
      // Manejar errores de Dio
      throw 'Error de conexión. Por favor, verifica tu conexión a internet.';
    }
  }

  Future<List<InventarioModel>> listarInventariosProductos(
      String nombreProducto) async {
    try {
      final response = await dio.get(
        '/productos/productostockprecio?nombre=$nombreProducto&listaprecio=0',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        if (jsonData.isNotEmpty) {
          return jsonData
              .map((item) => InventarioModel.fromJson(item))
              .toList();
        } else {
          // Manejar la respuesta vacía aquí
          return [];
        }
      } else {
        // Manejar el código de estado de respuesta no exitoso aquí
        throw 'Status Code Server: ${response.statusCode}';
      }
    } on DioException {
      // Manejar errores de Dio
      throw 'Error de conexión. Por favor, verifica tu conexión a internet.';
    }
  }

  Future<List<RutaGpsModel>> listarRutaGps() async {
    try {
      final response = await dio.get(
        '/vendedores/ruta/diariagps',
        options: Options(
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
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
    } on DioException {
      // Manejar errores de Dio
      throw 'Error de conexión. Por favor, verifica tu conexión a internet.';
    }
  }

  Future<List<ClienteRutaModel>> listarClienteFueraRuta() async {
    try {
      final response = await dio.get(
        'vendedores/ruta/fueraruta',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        if (jsonData.isNotEmpty) {
          return jsonData
              .map((item) => ClienteRutaModel.fromJson(item))
              .toList();
        } else {
          // Manejar la respuesta vacía aquí
          return [];
        }
      } else {
        // Manejar el código de estado de respuesta no exitoso aquí
        throw 'Status Code Server: ${response.statusCode}';
      }
    } on DioException {
      // Manejar errores de Dio
      throw 'Error de conexión. Por favor, verifica tu conexión a internet.';
    }
  }

  Future<List<PedidoClienteTabModel>> listarTabPedidosClientes(
      String fechaInicial, String fechaFinal) async {
    try {
      final response = await dio.get(
        '/pedidos/pedidoscliente?clienteId=0&desde=$fechaInicial&hasta=$fechaFinal',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
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
    } on DioException {
      // Manejar errores de Dio
      throw 'Error de conexión. Por favor, verifica tu conexión a internet.';
    }
  }

  Future<List<ChannelMapModel>> listarChannelMapMarcas(
      int clienteSucurcalId, int prospectoClienteId) async {
    developer.log(
        'http - listarChannelMapMarcas: $clienteSucurcalId - $prospectoClienteId',
        name: 'my.app.developer');

    final response = await dio.get(
      '$_urlBase/marcas/parachannelmap?ClienteSucursalId=$clienteSucurcalId&ProspectoClienteId=$prospectoClienteId',
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
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

  Future<ParametrosAgenteModel?> obtenerParametrosAgente() async {
    developer.log('dio - obtenerParametrosAgente', name: 'my.app.developer');

    final response = await dio.get(
      '$_urlBase/agentes/parametros',
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    if (response.statusCode == 200) {
      if (response.data != null && response.data.isNotEmpty) {
        // Parsear la respuesta JSON a un objeto AgenteModel
        ParametrosAgenteModel agente = ParametrosAgenteModel.fromJson(response.data);

        // Manejar los datos recibidos (por ejemplo, imprimirlos)
        developer.log('Nombre: ${agente.distribuidorId}, Edad: ${agente.nombre}', name: 'my.app.developer');
        return agente;
      } else {
        // Manejar el caso donde response.data está vacío o null
        return null;
      }
    } else {
      // Manejar el código de estado de respuesta no exitoso aquí
      throw 'Status Code Server: ${response.statusCode}';
    }
  }
}
