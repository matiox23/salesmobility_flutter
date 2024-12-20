import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/ruta_gps_model.dart';
import 'package:flutter_app_users/services/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'dart:developer' as developer;

class TabMap extends StatefulWidget {
  const TabMap({super.key});

  @override
  State<TabMap> createState() => _TabMapState();
}

class _TabMapState extends State<TabMap> {
  HttpServices httpServices = HttpServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Position>(
        future: httpServices.getCoordinates(),
        builder: (context, positionSnapshot) {
          if (positionSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Color(0xFF1976D2),
            );
          } else if (positionSnapshot.hasError) {
            return Center(
              child: Text(
                '${positionSnapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!positionSnapshot.hasData) {
            return const Center(child: Text('No se pudo obtener la posición.'));
          } else {
            Position position = positionSnapshot.data!;
            return InfoMap(httpServices: httpServices, position: position);
          }
        },
      ),
    );
  }
}

class InfoMap extends StatefulWidget {
  final HttpServices httpServices;
  final Position position;

  const InfoMap({
    super.key,
    required this.httpServices,
    required this.position,
  });

  @override
  State<InfoMap> createState() => _InfoMapState();
}

class _InfoMapState extends State<InfoMap> {
  //late GoogleMapController mapController;
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  //HttpServices httpServices = HttpServices();
  final Set<Marker> _markers = {};
/*  final Map<String, Marker> _markers = {};

   @override
  void initState() {
    super.initState();
    setState(() {
      _markers.clear();
      _markers["current_location"] = Marker(
        markerId: const MarkerId("current_location"),
        position: LatLng(widget.position.altitude, widget.position.longitude),
        infoWindow: const InfoWindow(
          title: "Mi Ubicación",
          snippet: "Descripción de mi ubicación",
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
    });
  } */

  final DioServices dioServices = DioServices();

  @override
  void initState() {
    dioServices.addInterceptor();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    //mapController = controller;
    mapController.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<RutaGpsModel>>(
        future: dioServices.listarRutaGps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Color(0xFF1976D2),
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
            List<RutaGpsModel> rutaGpsModel = snapshot.data!;
            _markers.clear();

            _markers.add(
              Marker(
                markerId: const MarkerId("current_location"),
                position:
                    LatLng(widget.position.latitude, widget.position.longitude),
                infoWindow: const InfoWindow(
                  title: "Mi Ubicación",
                  snippet: "Descripción de mi ubicación.",
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
              ),
            );
            for (int i = 0; i < rutaGpsModel.length; i++) {
              RutaGpsModel rutaGPS = rutaGpsModel[i];
              // developer.log('value: ${rutaGPS.dCliente}',
              //     name: 'my.app.developer');
              if (rutaGPS.latitud != null &&
                  rutaGPS.longitud != null &&
                  rutaGPS.latitud != "" &&
                  rutaGPS.longitud != "") {
                if (rutaGPS.conVisita == 1) {
                  _markers.add(
                    Marker(
                      markerId: MarkerId("${rutaGPS.clienteId}-$i"),
                      position: LatLng(tryParseDouble(rutaGPS.latitud!),
                          tryParseDouble(rutaGPS.longitud!)),
                      infoWindow: InfoWindow(
                        title: "${rutaGPS.orden}: ${rutaGPS.dCliente}",
                        snippet: "${rutaGPS.direccion}",
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueYellow),
                    ),
                  );
                } else {
                  _markers.add(
                    Marker(
                      markerId: MarkerId("${rutaGPS.clienteId}-$i"),
                      position: LatLng(tryParseDouble(rutaGPS.latitud!),
                          tryParseDouble(rutaGPS.longitud!)),
                      infoWindow: InfoWindow(
                        title: "${rutaGPS.dCliente}",
                        snippet: "${rutaGPS.direccion}",
                      ),
                    ),
                  );
                }
              }
            }

            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(widget.position.latitude, widget.position.longitude),
                zoom: 11.0,
              ),
              markers: _markers,

              /* {
                Marker(
                  markerId: const MarkerId("current_location"),
                  position: LatLng(
                      widget.position.latitude, widget.position.longitude),
                  infoWindow: InfoWindow(
                      title: "Mi Ubicación",
                      snippet: "Descripción de mi ubicación",
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Mi Ubicación"),
                                content: Text(
                                    "Lat: ${widget.position.latitude} - Lon: ${widget.position.longitude}"),
                              );
                            });
                      }),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                )
              }, */
            );
          }
        },
      ),
    );
  }

  double tryParseDouble(String numeroString) {
    try {
      // La conversión fue exitosa
      return double.parse(numeroString);
    } catch (e) {
      // La conversión falló
      return 0;
    }
  }
}
