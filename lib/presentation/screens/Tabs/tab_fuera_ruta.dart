import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/cliente_ruta_model.dart';
import 'package:flutter_app_users/services/services.dart';
import 'package:flutter_app_users/utils/dialog_rutas.dart';

class TabFueraRuta extends StatefulWidget {
  const TabFueraRuta({super.key});

  @override
  State<TabFueraRuta> createState() => _TabFueraRutaState();
}

class _TabFueraRutaState extends State<TabFueraRuta> {
  //final HttpServices httpServices = HttpServices();

  final DioServices dioServices = DioServices();

  @override
  void initState() {
    dioServices.addInterceptor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: futureBuilderClienteFueraRutaDiaria(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF005854),
        foregroundColor: Colors.white,
        onPressed: () {
          showDialogBuscarClienteFueraRuta(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(6), // Personaliza el radio del borde
        ),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  FutureBuilder<List<ClienteRutaModel>> futureBuilderClienteFueraRutaDiaria() {
    return FutureBuilder(
      future: dioServices.listarClienteFueraRuta(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Listando...'),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Error',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${snapshot.error}'),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No se encontraron datos.'));
        } else if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No existen resultados.'));
        } else {
          return SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final clienteRutaItem = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: RectangularWidget(
                    backgroundIcon: IconAndColor(
                        iconData: Icons.person,
                        color: estadoPedido(clienteRutaItem)),
                    cornerIcons: [
                      IconAndColor(
                          iconData: Icons.map,
                          color: mostrarChannelMap(clienteRutaItem)),
                      IconAndColor(
                          iconData: Icons.radar,
                          color: mostrarCobertura(clienteRutaItem)),
                      IconAndColor(
                        iconData: Icons.photo_camera,
                        color: clienteRutaItem.conVisita == 1
                            ? const Color(0xFF35AFDB)
                            : const Color(0xFF888888),
                      ),
                      IconAndColor(
                        iconData: Icons.location_pin,
                        color: clienteRutaItem.latitud != ""
                            ? const Color(0xFFD83E2D)
                            : const Color(0xFF888888),
                      ),
                    ],
                  ),
                  title: Text(
                    clienteRutaItem.dCliente!,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: asignarColorDiasVencido(clienteRutaItem)),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clienteRutaItem.direccion!,
                        style: const TextStyle(fontSize: 9),
                      ),
                      Text(
                        clienteRutaItem.iPT!,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                    ],
                  ),
                  trailing: mostrarDiasFidelizado(clienteRutaItem),
/*                   onTap: () {
                    developer.log(
                        'clienteId: ${clienteRutaItem.sucursalId} - ${clienteRutaItem.prospectoId!}',
                        name: 'my.app.developer');
                    myShoDialogOpcionesRutas(context, clienteRutaItem);
                  }, */
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 0,
              ),
            ),
          );
        }
      },
    );
  }

  Color mostrarChannelMap(ClienteRutaModel clienteRutaItem) {
    int channelMap = clienteRutaItem.channelMap!;

    switch (channelMap) {
      case -1:
        return const Color(0xFF888888);
      case 0:
        return const Color(0xFFD8A920);
      case 1:
        return const Color(0xFF139F14);
      default:
        return const Color(0xFF888888);
    }
  }

  Color mostrarCobertura(ClienteRutaModel clienteRutaItem) {
    int cobertura = clienteRutaItem.coberturado!;

    switch (cobertura) {
      case 0:
        return const Color(0xFF888888);
      case 1:
        return const Color(0xFF139F14);
      case 2:
        return const Color(0xFF352BD8);
      case 3:
        return const Color(0xFFFF7627);
      default:
        return const Color(0xFF888888);
    }
  }

  Widget mostrarDiasFidelizado(ClienteRutaModel clienteRutaItem) {
    int value = clienteRutaItem.diasFidelidad!;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: CircleAvatar(
        radius: 11,
        backgroundColor:
            value >= 14 ? const Color(0xFF139F14) : const Color(0xFFD8322E),
        foregroundColor: Colors.white,
        child: value >= 0
            ? Text("$value", style: const TextStyle(fontSize: 9))
            : const Text("-0", style: TextStyle(fontSize: 9)),
      ),
    );
  }

  Color asignarColorDiasVencido(ClienteRutaModel clienteRutaItem) {
    int diasVencido = clienteRutaItem.diasVencido!;
    Color temp = const Color(0xFF000000);

    if (diasVencido > 0) {
      temp = const Color(0xFFC80000);
    }

    if (diasVencido > -7 && diasVencido <= 0) {
      temp = const Color(0xFFF09030);
    }

    return temp;
  }

  Color estadoPedido(ClienteRutaModel clienteRutaItem) {
    int pedido = clienteRutaItem.pedido!;
    String estado = clienteRutaItem.estado!;

    if (pedido != 0) {
      switch (estado) {
        case "":
          return const Color(0xFF388E3C);
        case "P":
          return const Color(0xFFFBC02D);
        case "R":
          return const Color(0xFFD32F2F);
        default:
          // Puedes manejar otros casos aquí
          return const Color(0xFF000000); // Por defecto
      }
    } else {
      return const Color(0xFFC6C6C6);
    }
  }
}

Future<dynamic> showDialogBuscarClienteFueraRuta(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const DialogBusquedaClienteWidget();
    },
  );
}

class DialogBusquedaClienteWidget extends StatefulWidget {
  const DialogBusquedaClienteWidget({
    super.key,
  });

  @override
  State<DialogBusquedaClienteWidget> createState() =>
      _DialogBusquedaClienteWidgetState();
}

class _DialogBusquedaClienteWidgetState
    extends State<DialogBusquedaClienteWidget> {
  final HttpServices httpServices = HttpServices();
  TextEditingController tcBuscarProducto = TextEditingController(text: "");
  bool buscar = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: EdgeInsets.zero,
        child: Container(
          color: const Color(0xFF1976D2),
          padding: const EdgeInsets.only(top: 3, bottom: 3),
          child: const Text(
            'Buscar cliente',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      content: Container(
        padding: EdgeInsets.zero,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: Text(
                      'Cliente: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: tcBuscarProducto,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: 'Buscar',
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        buscar = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      //visualDensity: VisualDensity.compact,
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                color: const Color(0xFF1976D2),
                padding: const EdgeInsets.only(top: 3, bottom: 3),
                child: const Text(
                  'Clientes',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: buscar == false
                  ? const Center(child: Text(""))
                  : tcBuscarProducto.text.length >= 3
                      ? futureBuilderBuscarTodosClientesFueraRuta(
                          tcBuscarProducto.text)
                      : const Center(child: Text("")),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<ClienteRutaModel>>
      futureBuilderBuscarTodosClientesFueraRuta(String nombreCliente) {
    return FutureBuilder(
      future: httpServices.listarBuscarTodosClientesFueraRuta(nombreCliente),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Text('Cargando...'),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(maxHeight: 134),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Error',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${snapshot.error}'),
                  ],
                ),
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text('No se encontraron datos.'),
          );
        } else if (snapshot.data!.isEmpty) {
          return const SizedBox(
            width: double.maxFinite,
            height: 128,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No existen resultados.'),
              ),
            ),
          );
        } else {
          return SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final clienteFueraRutaItem = snapshot.data![index];
                return ListTile(
                  title: Text(
                    "${clienteFueraRutaItem.codigo!} [ ${clienteFueraRutaItem.nIT!} ]",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clienteFueraRutaItem.dCliente!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: asignarColorTipoCliente(clienteFueraRutaItem),
                        ),
                      ),
                      Text(
                        clienteFueraRutaItem.direccion!,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    myShoDialogOpcionesRutas(context, clienteFueraRutaItem);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 0,
              ),
            ),
          );
        }
      },
    );
  }

  Color asignarColorTipoCliente(ClienteRutaModel clienteRutaItem) {
    String tipoCliente = clienteRutaItem.tipo!;
    Color temp = const Color(0xFFE55410);

    if (tipoCliente == "Cliente" || tipoCliente == "C") {
      temp = const Color(0xFF000000);
    }

    return temp;
  }
}

class RectangularWidget extends StatelessWidget {
  final IconAndColor backgroundIcon;
  final List<IconAndColor> cornerIcons;

  const RectangularWidget({
    super.key,
    required this.backgroundIcon,
    required this.cornerIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46, // Alto del widget,
      padding: EdgeInsets.zero,
      // decoration: const BoxDecoration(
      //   color: Colors.blue, // Color de fondo del widget
      // ),
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: backgroundIcon.color,
              child: Icon(
                backgroundIcon.iconData,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Icon(
              cornerIcons[0].iconData,
              size: 20,
              color: cornerIcons[0].color,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              cornerIcons[1].iconData,
              size: 20,
              color: cornerIcons[1].color,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Icon(
              cornerIcons[2].iconData,
              size: 20,
              color: cornerIcons[2].color,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              cornerIcons[3].iconData,
              size: 20,
              color: cornerIcons[3].color,
            ),
          ),
        ],
      ),
    );
  }
}

class IconAndColor {
  final IconData iconData;
  final Color color;

  IconAndColor({
    required this.iconData,
    required this.color,
  });
}
