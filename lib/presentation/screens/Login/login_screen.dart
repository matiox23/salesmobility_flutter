import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_users/presentation/screens/Login/ios_web_resource_error.dart';
import 'package:flutter_app_users/presentation/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'dart:developer' as developer;

class LoginScreen extends StatefulWidget {
  static String routeName = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //bool isLoading = true;
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(true);
  //String _code = '';

  Future<bool> _saveAccessToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    bool stateAccessToken = false, stateRefreshToken = false;
    setState(() {
      //_code = prefs.getString('code') ?? '';
      /* developer.log('_ACCESS_TK: $accessToken', name: 'my.app.developer');
      developer.log('_REFRESH_TK: $refreshToken', name: 'my.app.developer'); */

      prefs.setString('accessToken', accessToken).then((value) {
        if (value) stateAccessToken = true;
        developer.log('stateAccessToken: $stateAccessToken',
            name: 'my.app.developer');
      });

      prefs.setString('refreshToken', refreshToken).then((value) {
        if (value) stateRefreshToken = true;
        developer.log('stateRefreshToken: $stateRefreshToken',
            name: 'my.app.developer');
      });
    });

    return stateAccessToken && stateRefreshToken;
  }

  Future<bool> setTokens(
      String accessToken, String refreshToken, String tokenId) async {
    final jwt = JWT.decode(tokenId);
    Map<String, dynamic> payload = jwt.payload;

    final prefs = SharedPreferences.getInstance();

    final accessTokenFuture =
        prefs.then((prefs) => prefs.setString('AccessToken', accessToken));

    final refreshTokenFuture =
        prefs.then((prefs) => prefs.setString('RefreshToken', refreshToken));

    final fullNameFuture =
        prefs.then((prefs) => prefs.setString('DUsuario', payload["name"]));

    final userNameFuture = prefs
        .then((prefs) => prefs.setString('NombreUsuario', payload["username"]));

    final userIdFuture =
        prefs.then((prefs) => prefs.setString('UsuarioId', payload["sub"]));

    final userRoleFuture =
        prefs.then((prefs) => prefs.setString('Rol', payload["role"]));

    final userEmailFuture =
        prefs.then((prefs) => prefs.setString('Email', payload["email"]));

    final statusLoginFuture =
        prefs.then((prefs) => prefs.setBool('StatusLogin', true));

    final results = await Future.wait([
      accessTokenFuture,
      refreshTokenFuture,
      fullNameFuture,
      userNameFuture,
      userIdFuture,
      userRoleFuture,
      userEmailFuture,
      statusLoginFuture
    ]);

    final stateAccessToken = results[0];
    final stateRefreshToken = results[1];
    final stateFullName = results[2];
    final stateUserName = results[3];
    final stateUserId = results[4];
    final stateUserRole = results[5];
    final stateUserEmail = results[6];
    final stateStatusLogin = results[7];

/*     developer.log('stateAccessToken: $stateAccessToken',
        name: 'my.app.developer');
    developer.log('stateRefreshToken: $stateRefreshToken',
        name: 'my.app.developer');
    developer.log('stateFullName: $stateFullName', name: 'my.app.developer');
    developer.log('stateUserName: $stateUserName', name: 'my.app.developer');
    developer.log('stateUserId: $stateUserId', name: 'my.app.developer');
    developer.log('stateUserRole: $stateUserRole', name: 'my.app.developer');
    developer.log('stateUserEmail: $stateUserEmail', name: 'my.app.developer');
    developer.log('stateStatusLogin: $stateStatusLogin',
        name: 'my.app.developer'); */

    bool state = stateAccessToken &&
        stateRefreshToken &&
        stateFullName &&
        stateUserName &&
        stateUserId &&
        stateUserRole &&
        stateUserEmail &&
        stateStatusLogin;

    return state;
  }

  Future<bool> _performTokenExchange(String code) async {
    try {
      final urlToken =
          Uri.parse('https://accounts.salesmobilitytools.com/connect/token');
      final response = await http.post(
        urlToken,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'code': code,
          'client_id': 'SalesMobilityApp',
          'redirect_uri': 'salesmobilityapp://',
          'grant_type': 'authorization_code'
        },
      );

      if (response.statusCode == 200) {
        // developer.log('Response Object: ${response.body}', name: 'my.app');
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String accessToken = jsonResponse['access_token'];
        String refreshToken = jsonResponse['refresh_token'];
        String tokenId = jsonResponse['id_token'];

        return setTokens(accessToken, refreshToken, tokenId);
        // Luego puedes navegar a la siguiente pantalla si es necesario
      } else {
        // Maneja el código de estado de respuesta no exitoso aquí
        developer.log('Error en la solicitud POST: ${response.body}',
            name: 'my.app');
        return false;
      }
    } catch (e) {
      // Maneja cualquier excepción que pueda ocurrir
      developer.log('Error en la solicitud POST: $e', name: 'my.app');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            // developer.log('Started: $url', name: 'my.app.salesMobility');
          },
          onPageFinished: (String url) {
            if (Platform.isAndroid) {
              isLoadingNotifier.value = false;
              if (url.contains("?code=")) {
                isLoadingNotifier.value = true;
                final code = Uri.parse(url).queryParameters['code'];
                developer.log('Code: $code', name: 'my.app.salesMobility');

                _performTokenExchange(code ?? '').then((value) {
                  isLoadingNotifier.value = false;
                  if (value) {
                    developer.log('login Android Change Main Screen',
                        name: 'my.app.salesMobility');
                    Navigator.pop(context);
                    Navigator.pushNamed(context, MainScreen.routeName);
                  }
                });
              }
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (Platform.isIOS) {
              final iosError = IOSWebResourceError.fromWebResourceError(
                error,
                domain:
                    "salesmobilitytools.com", // Aquí puedes obtener el valor real del dominio si está disponible.
              );
              developer.log(
                  'iOS Error: ${iosError.description}, Domain: ${iosError.domain}, ErrorCode: ${iosError.errorCode} - ${iosError.errorType}, Url: ${iosError.url}',
                  name: 'my.app.salesMobility');
            } else {
              developer.log('Error: ${error.description}',
                  name: 'my.app.salesMobility');
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('salesmobilityapp://?code=')) {
              return NavigationDecision.prevent;
            } else {
              if (request.url.startsWith(
                  'https://accounts.salesmobilitytools.com/oauth/v2/recovery')) {
                return NavigationDecision.prevent;
              }
            }

            developer.log(
                'onNavigationRequest: ${NavigationDecision.navigate.name}',
                name: 'my.app.salesMobility');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            /* developer.log('url change to ${change.url}',
                name: 'my.app.salesMobility');  */
            if (Platform.isIOS) {
              isLoadingNotifier.value = false;
              if (change.url != null) {
                if (change.url!.contains("?code=")) {
                  isLoadingNotifier.value = true;

                  final code = Uri.parse(change.url!).queryParameters['code'];
                  developer.log('Code: $code', name: 'my.app.salesMobility');

                  _performTokenExchange(code ?? '').then((value) {
                    isLoadingNotifier.value = false;

                    if (value) {
                      developer.log('login iOS Change Main Screen',
                          name: 'my.app.salesMobility');
                      Navigator.pop(context);
                      Navigator.pushNamed(context, MainScreen.routeName);
                    }
                  });
                }
              }
            }
          },
          onHttpAuthRequest: (request) {
            developer.log('onHttpAuthRequest to ${request.host}',
                name: 'my.app.salesMobility');
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://accounts.salesmobilitytools.com/oauth/v2/?client_id=SalesMobilityApp&response_type=code&redirect_uri=salesmobilityapp://'));

    return SafeArea(
      child: Scaffold(
        /* appBar: AppBar(
          title: const Text('Web Auth 2.0'),
        ), */
        body: Stack(
          children: <Widget>[
            WebViewWidget(controller: controller),
            ValueListenableBuilder<bool>(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return Stack(
                    children: [
                      Container(
                        color: Colors.grey.withOpacity(0.5),
                        child: const SizedBox.expand(),
                      ),
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1976D2),
                        ),
                      )
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
