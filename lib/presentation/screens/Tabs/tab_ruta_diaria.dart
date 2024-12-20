import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/cliente_ruta_model.dart';
import 'package:flutter_app_users/services/services.dart';
import 'dart:developer' as developer;

import 'package:flutter_app_users/utils/utils.dart';

class TabRutaDiaria extends StatefulWidget {
  const TabRutaDiaria({super.key});

  @override
  State<TabRutaDiaria> createState() => _TabRutaDiariaState();
}

class _TabRutaDiariaState extends State<TabRutaDiaria> {
  //final HttpServices httpServices = HttpServices();
  final DioServices dioServices = DioServices();
  late List<ClienteRutaModel> items;
  late List<ClienteRutaModel> filteredItems;
  TextEditingController searchController = TextEditingController();
  final Debouncer debouncer = Debouncer();
  String errorMessage = "";
  bool loading = true;

  @override
  void initState() {
    developer.log('InitState', name: 'my.app.developer');
    dioServices.addInterceptor();

    dioServices.listarClienteRutas("").then(
      (data) {
        setState(() {
          items = data;
          filteredItems = items;
          loading = false;
        });
      },
      onError: (error) {
        // Manejo de errores aquí
        setState(() {
          errorMessage = error.toString();
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    debouncer.dispose();
    searchController.dispose();
    super.dispose();
  }

  void onSearchTextChanged(String query) {
    debouncer.call(() {
      filterItems(query);
    });
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) =>
              item.dCliente!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: searchController,
          onChanged: (query) => onSearchTextChanged(query),
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.grey),
            hintText: 'Buscar cliente...',
            contentPadding: EdgeInsets.zero,
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.blue), // Cambia el color que desees
            ),
          ),
          onTapOutside: (event) {
            developer.log("onTapOutside RutaDiaria", name: 'my.app.developer');
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
        Expanded(
          child: errorMessage.isEmpty
              ? loading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Listando...'),
                          ],
                        ),
                      ),
                    )
                  : filteredItems.isNotEmpty
                      ? listarClientesRutaDiaria()
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No existen resultados.'),
                              ],
                            ),
                          ),
                        )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Error',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(errorMessage),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  SizedBox listarClientesRutaDiaria() {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final clienteRutaItem = filteredItems[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: RectangularWidget(
              backgroundIcon: IconAndColor(
                iconData: Icons.person,
                color: estadoPedido(clienteRutaItem),
              ),
              cornerIcons: [
                IconAndColor(
                  iconData: Icons.map,
                  color: mostrarChannelMap(clienteRutaItem),
                ),
                IconAndColor(
                  iconData: Icons.radar,
                  color: mostrarCobertura(clienteRutaItem),
                ),
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
                color: asignarColorDiasVencido(clienteRutaItem),
              ),
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
            onTap: () {
              developer.log(
                  'clienteId: ${clienteRutaItem.sucursalId} - ${clienteRutaItem.prospectoId!}',
                  name: 'my.app.developer');
              myShoDialogOpcionesRutas(context, clienteRutaItem);
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
          height: 0,
        ),
      ),
    );
  }

  FutureBuilder<List<ClienteRutaModel>> futureBuilderClienteRutaDiaria2(
      String nombreCliente) {
    return FutureBuilder(
      future: dioServices.listarClienteRutas(nombreCliente),
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
          items = snapshot.data!;
          filteredItems = items;

          if (searchController.text.isNotEmpty) {
            filteredItems = items
                .where((item) => item.dCliente!
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();
          }

          return SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final clienteRutaItem = filteredItems[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: RectangularWidget(
                    backgroundIcon: IconAndColor(
                      iconData: Icons.person,
                      color: estadoPedido(clienteRutaItem),
                    ),
                    cornerIcons: [
                      IconAndColor(
                        iconData: Icons.map,
                        color: mostrarChannelMap(clienteRutaItem),
                      ),
                      IconAndColor(
                        iconData: Icons.radar,
                        color: mostrarCobertura(clienteRutaItem),
                      ),
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
                      color: asignarColorDiasVencido(clienteRutaItem),
                    ),
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
                  onTap: () {
                    developer.log(
                        'clienteId: ${clienteRutaItem.sucursalId} - ${clienteRutaItem.prospectoId!}',
                        name: 'my.app.developer');
                    myShoDialogOpcionesRutas(context, clienteRutaItem);
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

  FutureBuilder<List<ClienteRutaModel>> futureBuilderClienteRutaDiaria(
      String nombreCliente) {
    return FutureBuilder(
      future: dioServices.listarClienteRutas(nombreCliente),
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
                      color: estadoPedido(clienteRutaItem),
                    ),
                    cornerIcons: [
                      IconAndColor(
                        iconData: Icons.map,
                        color: mostrarChannelMap(clienteRutaItem),
                      ),
                      IconAndColor(
                        iconData: Icons.radar,
                        color: mostrarCobertura(clienteRutaItem),
                      ),
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
                      color: asignarColorDiasVencido(clienteRutaItem),
                    ),
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
                  onTap: () {
                    developer.log(
                        'clienteId: ${clienteRutaItem.sucursalId} - ${clienteRutaItem.prospectoId!}',
                        name: 'my.app.developer');
                    myShoDialogOpcionesRutas(context, clienteRutaItem);
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
            ? Text(
                "$value",
                style: const TextStyle(fontSize: 9),
              )
            : const Text(
                "-0",
                style: TextStyle(fontSize: 9),
              ),
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
