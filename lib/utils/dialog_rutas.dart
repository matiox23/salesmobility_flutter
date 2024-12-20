import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/cliente_ruta_model.dart';
import 'package:flutter_app_users/models/pass_channel_map_model.dart';
import 'dart:developer' as developer;

import 'package:flutter_app_users/presentation/screens/screens.dart';

Future<dynamic> myShoDialogOpcionesRutas(
    BuildContext context, ClienteRutaModel clienteRutaModel) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(6),
        )),
        contentPadding: const EdgeInsets.all(3),
        titlePadding: EdgeInsets.zero,
        title: Padding(
          padding: EdgeInsets.zero,
          child: Container(
            color: const Color(0xFF1976D2),
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: const Text(
              'Opciones de ruta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              clienteRutaModel.dCliente!,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              clienteRutaModel.direccion!,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2, // Dos columnas
                          shrinkWrap: true,
                          children: [
                            CardWidget(
                              id: 1,
                              iconOpcionRuta: Icons.shopping_cart,
                              labelOpcionRuta: "Pedido",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 2,
                              iconOpcionRuta: Icons.photo_camera_rounded,
                              labelOpcionRuta: "Visita",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 3,
                              iconOpcionRuta: Icons.file_copy_outlined,
                              labelOpcionRuta: "Historial",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 4,
                              iconOpcionRuta: Icons.dashboard,
                              labelOpcionRuta: "Dashboard",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 5,
                              iconOpcionRuta: Icons.request_quote,
                              labelOpcionRuta: "Estado cuenta",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 6,
                              iconOpcionRuta: Icons.map,
                              labelOpcionRuta: "Channel map",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 7,
                              iconOpcionRuta: Icons.edit_location_alt_sharp,
                              labelOpcionRuta: "Actualiza cliente",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 8,
                              iconOpcionRuta: Icons.payment,
                              labelOpcionRuta: "Cobranza",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 9,
                              iconOpcionRuta: Icons.notification_important,
                              labelOpcionRuta: "Notas incidentes",
                              clienteRuta: clienteRutaModel,
                            ),
                            CardWidget(
                              id: 10,
                              iconOpcionRuta: Icons.receipt,
                              labelOpcionRuta: "Marketing",
                              clienteRuta: clienteRutaModel,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

class CardWidget extends StatelessWidget {
  final int id;
  final String labelOpcionRuta;
  final IconData iconOpcionRuta;
  final ClienteRutaModel? clienteRuta;
  const CardWidget({
    super.key,
    required this.id,
    required this.labelOpcionRuta,
    required this.iconOpcionRuta,
    this.clienteRuta,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        developer.log('onTap - $id - $labelOpcionRuta',
            name: 'my.app.developer');
        if (id == 6) {
          Navigator.pushNamed(
            context,
            ChannelMapScreen.routeName,
            arguments: PassChannelMapModel(
                clienteRutaModel: clienteRuta, esClienteProspecto: false),
          );
        } else if (id == 2) {
          Navigator.pushNamed(
            context,
            VisitaScreen.routeName,
            arguments: PassChannelMapModel(
                clienteRutaModel: clienteRuta, esClienteProspecto: false),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconOpcionRuta, size: 32),
            Text(
              labelOpcionRuta,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
