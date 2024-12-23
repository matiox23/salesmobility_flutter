import 'dart:async';

import 'package:flutter_app_users/blocs/blocs.dart';
import 'package:flutter_app_users/blocs/internet_connection/bloc/internet_bloc.dart';
import 'package:flutter_app_users/models/parametros_agente_model.dart';
import 'package:flutter_app_users/presentation/screens/ClienteProspecto/cliente_prospecto_screen.dart';
import 'package:flutter_app_users/presentation/screens/Tabs/tab_fuera_ruta.dart';
import 'package:flutter_app_users/presentation/screens/Tabs/tab_inventario.dart';
import 'package:flutter_app_users/presentation/screens/Tabs/tab_map.dart';
import 'package:flutter_app_users/presentation/screens/Tabs/tab_pedidos.dart';
import 'package:flutter_app_users/presentation/screens/Tabs/tab_resumen_diario.dart';
import 'package:flutter_app_users/presentation/screens/screens.dart';
import 'package:flutter_app_users/services/dio.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  static String routeName = 'main_screen';
  static String fullName = "";
  static String userName = "";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late SharedPreferences prefs;
  final DioServices dioServices = DioServices();

  @override
  void initState() {
    super.initState();

    dioServices.addInterceptor();

    cargarSharedPreferences();

    dioServices.obtenerParametrosAgente().then(
      (data) {
        if (data != null) {
          guardarParametrosAgente(data);
        }
      },
      onError: (error) {
        developer.log("Main: $error", name: 'my.app.developer');
      },
    );
  }

  Future<void> guardarParametrosAgente(ParametrosAgenteModel data) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('DISTRIBUIDORID', data.distribuidorId!);
    await prefs.setString('NOMBRE', data.nombre!);
    await prefs.setString('PAIS', data.pais!);
    await prefs.setBool('USADESCUENTO', data.usaDescuento!);
    await prefs.setBool('OBLIGAFOTOVISITA', data.obligaFotoVisita!);
    await prefs.setBool('SELECCIONATIPOCREDITO', data.seleccionaTipoCredito!);
    await prefs.setBool('SELECCIONATIPOCONTADO', data.seleccionaTipoContado!);
    await prefs.setBool('VERTODOSCLIENTES', data.verTodosClientes!);
    await prefs.setBool(
        'REQUIEREAPROBACIONPEDIDO', data.requiereAprobacionPedido!);
    await prefs.setBool('USARRUTA', data.usarRuta!);
    await prefs.setBool(
        'VERPROGAMADOPLANIFICADO', data.verProgamadoPlanificado!);
    await prefs.setBool('PRECIOCONIVA', data.precioConIVA!);
    await prefs.setBool('EDITAPRECIO', data.editaPrecio!);
    await prefs.setBool('SOLOCHANNELMAP', data.soloChannelMap!);
    await prefs.setBool('PRECIOSESCALA', data.preciosEscala!);
    await prefs.setBool('VALIDASTOCK', data.validaStock!);
    await prefs.setBool('VENTASPERDIDAS', data.ventasPerdidas!);
    await prefs.setBool('VERFIDELIZADORUTA', data.verFidelizadoRuta!);
    await prefs.setBool('VERPRECIOCONIVAENAPP', data.verPrecioConIVAenApp!);
    await prefs.setBool('CALCULAESCALAGLOBAL', data.calculaEscalaGlobal!);
    await prefs.setBool('PRECIOCONFORMAPAGO', data.precioconFormaPago!);
    await prefs.setBool('PRECIOCONTIPOPAGO', data.precioconTipoPago!);
    await prefs.setBool('VISITALLAMADA', data.visitaLlamada!);
  }

  Future<void> cargarSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    MainScreen.fullName = prefs.getString('DUsuario') ?? '';
    MainScreen.userName = prefs.getString('NombreUsuario') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Inicio',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF1976D2),
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: TabBar(
              isScrollable: true,
              onTap: (value) {
                switch (value) {
                  case 0:
                    developer.log('value: $value', name: 'my.app.developer');
                    break;
                  case 1:
                    developer.log('value: $value', name: 'my.app.developer');
                    break;
                  case 2:
                    developer.log('value: $value', name: 'my.app.developer');
                    break;
                  case 3:
                    developer.log('value: $value', name: 'my.app.developer');
                    break;
                  case 4:
                    developer.log('value: $value', name: 'my.app.developer');
                    break;
                  case 5:
                    developer.log('value: $value', name: 'my.app.developer');
                    break;
                }
              },
              tabs: const [
                Tab(text: 'HOY'),
                Tab(text: 'RUTA'),
                Tab(text: 'INVENTARIO'),
                Tab(text: 'MAPA'),
                Tab(text: 'FUERA DE RUTA'),
                Tab(text: 'PEDIDO'),
              ],
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
            ),
            actions: <Widget>[
              BlocBuilder<InternetBloc, InternetState>(
                builder: (context, state) {
                  if (state is ConnectedState) {
                    return IconButton(
                        color: const Color(0xFF00FF0A),
                        icon: const Icon(Icons.wifi),
                        onPressed: () {
                          // Agregar lógica para manejar el primer ícono adicional
                        });
                  } else {
                    return IconButton(
                      color: const Color(0xFFFF0600),
                      icon: const Icon(Icons.wifi_off),
                      onPressed: () {
                        // Agregar lógica para manejar el primer ícono adicional
                      },
                    );
                  }
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'cerrar_sesion',
                    child: Text('Cerrar sesión'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'acerca_de',
                    child: Text('Acerca de'),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'cerrar_sesion') {
                    developer.log('opcion seleccionada: $value',
                        name: 'my.app.developer');

                    logOut(context);
                  }
                },
              ),
            ],
          ),
          body: const TabBarView(
            // Impide el desplazamiento horizontal
            // physics: NeverScrollableScrollPhysics(),
            children: [
              TabResumenDiario(),
              TabRutaDiaria(),
              TabInventario(),
              TabMap(),
              TabFueraRuta(),
              TabPedidos(),
            ],
          ),
          drawer: const MyNavigationDrawer(),
        ),
      ),
    );
  }

  void logOut(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          title: Container(
            color: const Color(0xFF1976D2),
            padding: EdgeInsets.zero,
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          content: const Text('¿Estás seguro de querer cerrar la sesión?'),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(24),
          actionsPadding: EdgeInsets.zero,
          actions: [
            TextButton(
              onPressed: () {
                saveDataAndNavigate();
              },
              /* onPressed: () async {
                await prefs.setString('AccessToken', 'tokenId');
                await prefs.setBool('StatusLogin', false);

                // Verifica si el widget aún está en el árbol de widgets
                if (!mounted) {
                  return;
                }

                Navigator.pushReplacementNamed(
                  context,
                  LoginScreen.routeName,
                );
              }, */
              child: const Text(
                'Si',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> saveDataAndNavigate() async {
    // Guardar datos en SharedPreferences
    await saveDataToSharedPreferences();

    // Verificar si el widget sigue montado antes de navegar
    if (mounted) {
      Navigator.pop(context);
      // Navigator.pushNamed(context, LoginScreen.routeName);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      // También podrías considerar Navigator.pushReplacementNamed si deseas reemplazar la pantalla actual en la pila
    }
  }

  Future<void> saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('AccessToken', 'tokenId');
    await prefs.setBool('StatusLogin', false);
  }
}

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({super.key});

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  int _selectedIndex = 0; // Índice del elemento seleccionado
  void _onItemTapped(int index, String routeName) {
    setState(() {
      _selectedIndex = index; // Actualiza el índice seleccionado
    });

    Navigator.pop(context); // Cierra el Drawer
    Navigator.pushNamed(context, routeName); // Navega a la ruta seleccionada
  }

  @override
  Widget build(BuildContext context) {
    // Implement your custom navigation drawer UI here
    return Drawer(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _myHeader(context),
          _myMenuItems(context),
        ],
      )),
    );
  }

  Widget _myHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF1976D2),
      padding: EdgeInsets.only(
        top: 32 + MediaQuery.of(context).padding.top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 6.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFFfc1404),
              radius: 32,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
                shadows: [
                  Shadow(
                    color: Color(0xFF535353),
                    offset: Offset(2, 2),
                    blurRadius: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 0.0),
                child: Text(
                  MainScreen.fullName.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 6.0),
                child: Text(
                  MainScreen.userName,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _myMenuItems(BuildContext context) {
    // Índice del elemento seleccionado

    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.home_filled,
            color: _selectedIndex == 0 ? Colors.blueAccent : Colors.black,
          ),
          title: Text(
            'Inicio',
            style: TextStyle(
                color: _selectedIndex == 0 ? Colors.blue : Colors.black),
          ),
          onTap: () {
            _onItemTapped(0, MainScreen.routeName);
            // Navigator.pop(context);
            // Navigator.pushNamed(context, MainScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: _selectedIndex == 1 ? Colors.blueAccent : Colors.black,
          ),
          title: Text('Cliente / Prospecto',
              style: TextStyle(
                  color:
                      _selectedIndex == 1 ? Colors.blueAccent : Colors.black)),
          onTap: () {
            _onItemTapped(1, ClienteProspectoScreen.routeName);
            // Navigator.pop(context);
            // Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          leading: const Icon(
            Icons.calendar_month_outlined,
            color: Colors.red,
          ),
          title: const Text('Planifica Ruta'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.history,
            color: Color.fromARGB(255, 17, 0, 255),
          ),
          title: const Text('Historico de Movilidad'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.monetization_on,
            color: Colors.green,
          ),
          title: const Text(
            'Módulo de Precios',
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.account_balance_wallet,
            color: Colors.deepOrange,
          ),
          title: const Text('Estado de Cuenta'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.folder,
            color: Colors.amber,
          ),
          title: const Text('Mi Espacio'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          leading: const Icon(
            Icons.settings,
            color: Colors.grey,
          ),
          title: const Text('Configuración'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
      ],
    );
  }
}
