import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/busqueda_ubigeo_model.dart';
import 'package:flutter_app_users/models/linea_model.dart';
import 'package:flutter_app_users/models/models.dart';
import 'package:flutter_app_users/models/pass_model.dart';
import 'package:flutter_app_users/presentation/screens/screens.dart';
import 'package:flutter_app_users/services/services.dart';
import 'dart:developer' as developer;

class HomeScreen extends StatefulWidget {
  static String routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: const Text(
            'Precios',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFFfc1404),
          //actions: guardarPreciosButton(context),
        ),
        body: const Center(
          child: _MyColumn(enabled: true),
        ),
      ),
    );
  }
}

class _MyColumn extends StatefulWidget {
  final bool enabled;
  const _MyColumn({required this.enabled});

  @override
  State<_MyColumn> createState() => _MyColumnState();
}

class _MyColumnState extends State<_MyColumn> {
  int? lineaId;
  String? lineaNombre;
  int? tipoEstablecimientoId;
  String? tipoEstablecimientoNombre;
  int? ubigeoId;
  String? ubigeoNombre;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Centrar verticalmente
      crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente
      children: <Widget>[
        _MyRow(
          icon: Icons.list_alt_rounded,
          label: 'Línea de Negocio',
          enabled: true,
          nameApiCall: 'LineaNegocio',
          onSelect: (valueInt, valueStr) {
            developer.log('data linea Negocio final: $valueStr - $valueInt',
                name: 'my.app.developer');
            lineaId = valueInt;
            lineaNombre = valueStr;
          },
        ),
        _MyRow(
          icon: Icons.home,
          label: 'Establecimiento',
          enabled: true,
          nameApiCall: 'Establecimiento',
          onSelect: (valueInt, valueStr) {
            developer.log('data Establecimiento final: $valueStr - $valueInt',
                name: 'my.app.developer');
            tipoEstablecimientoId = valueInt;
            tipoEstablecimientoNombre = valueStr;
          },
        ),
        _MyRow(
          icon: Icons.location_on,
          label: 'Ubicación',
          enabled: true,
          nameApiCall: 'Ubicacion',
          onSelect: (valueInt, valueStr) {
            developer.log('data Ubicacion final: $valueStr - $valueInt',
                name: 'my.app.developer');
            ubigeoId = valueInt;
            ubigeoNombre = valueStr;
          },
        ),
        ElevatedButton(
          onPressed: () {
            developer.log(
                'data ingresar final: $lineaId, $lineaNombre, $tipoEstablecimientoId, $tipoEstablecimientoNombre, $ubigeoId, $ubigeoNombre',
                name: 'my.app.developer');
            Navigator.pushNamed(context, PrecioScreen.routeName,
                arguments: PassModel(
                    lineaId: lineaId,
                    lineaNombre: lineaNombre,
                    tipoEstablecimientoId: tipoEstablecimientoId,
                    tipoEstablecimientoNombre: tipoEstablecimientoNombre,
                    ubigeoId: ubigeoId,
                    ubigeoNombre: ubigeoNombre));
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFfc1404),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(6), // Ajusta el radio como desees
            ),
          ),
          child: const Text('Ingresar'),
        ),
      ],
    );
  }
}

class _MyRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final String nameApiCall;
  final void Function(int valueInt, String valueStr) onSelect;

  const _MyRow({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.nameApiCall,
    required this.onSelect,
  });

  @override
  State<_MyRow> createState() => _MyRowState();
}

class _MyRowState extends State<_MyRow> {
  String _itemSelected = '';
  int _itemSelectedId = -1;
  String ubigeoNombreDep = '';
  int? ubigeoIddep;
  String ubigeoProvinciaNombre = '';

  final HttpServices httpServices = HttpServices();
  //final ValueNotifier<bool> _enabledProvincia = ValueNotifier<bool>(false);
  final MyNotifier myNotifier = MyNotifier(BusquedaUbigeoModel());

  void actualizarUbigeo(int? ubigeoId, String codigo, String nombre) {
    setState(() {
      myNotifier.changeMyData(ubigeoId, codigo, nombre);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final VoidCallback? onPressed = widget.enabled ? () {} : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centrar horizontalmente
      crossAxisAlignment: CrossAxisAlignment.center, // Centrar verticalmente
      children: <Widget>[
/*         IconButton(
          icon: Icon(widget.icon),
          onPressed: onPressed,
        ), */
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1976D2), // Color de fondo blanco
            ),
            child: IconButton(
              iconSize: 20,
              color: Colors.white,
              icon: Icon(widget.icon),
              onPressed: () {
                myShowDialog(context);
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            disabledForegroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF1976D2),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(6), // Ajusta el radio como desees
            ),
            minimumSize: const Size(160, 40),
          ),
          child: SizedBox(
            width: 200,
            child: Text(
              _itemSelected.isEmpty ? widget.label : _itemSelected,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> myShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 6),
          title: (widget.nameApiCall == 'LineaNegocio')
              ? const Text(
                  'Línea de Negocio',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              : (widget.nameApiCall == 'Establecimiento')
                  ? const Text(
                      'Tipo de Establecimiento',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      'Buscar Ubigeo',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: (widget.nameApiCall == 'LineaNegocio')
              ? futureBuilderBusinessLine()
              : (widget.nameApiCall == 'Establecimiento')
                  ? futureBuilderEstablecimiento()
                  : ValueListenableBuilder<BusquedaUbigeoModel>(
                      builder: (BuildContext context, BusquedaUbigeoModel value,
                          Widget? child) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UbigeoWidget(
                                label: 'Departamento',
                                onSelectUbigeo: (ubigeoId, codigo, nombre) {
                                  actualizarUbigeo(ubigeoId, codigo, nombre);
                                  developer.log(
                                      'data onSelect Departamento:  $ubigeoId - $codigo - $nombre',
                                      name: 'my.app.developer');
                                  ubigeoIddep = ubigeoId;
                                  ubigeoNombreDep = nombre;
                                },
                                enabled: true,
                              ),
                              const SizedBox(height: 16),
                              UbigeoWidget(
                                label: 'Provincia',
                                onSelectUbigeo: (ubigeoId, codigo, nombre) {
                                  developer.log(
                                      'data Provincia: $ubigeoId - $codigo - $nombre',
                                      name: 'my.app.developer');
                                  setState(() {
                                    _itemSelected = '$ubigeoNombreDep, $nombre';
                                  });
                                  widget.onSelect(
                                      ubigeoId!, '$ubigeoNombreDep, $nombre');
                                },
                                enabled: myNotifier.value.codigo != null,
                                codigo: myNotifier.value.codigo,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Ok',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
/*                                    const SizedBox(width: 16),
                                     ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ) */
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      valueListenable: myNotifier,
                    ),
          actionsPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
/*          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ], */
        );
      },
    );
  }

  FutureBuilder<List<LineaModel>> futureBuilderBusinessLine() {
    return FutureBuilder(
      future: httpServices.listarLineasNegocios(),
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
          return Container(
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(maxHeight: 134),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Error',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${snapshot.error}'),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                )
              ],
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
                LineaModel lineaModel = snapshot.data![index];
                return ListTile(
                  title: Text(lineaModel.dLinea!),
                  trailing: const Icon(Icons.radio_button_off_outlined),
                  onTap: () {
                    setState(() {
                      _itemSelected = lineaModel.dLinea!;
                      _itemSelectedId = lineaModel.lineaId!;
                      widget.onSelect(_itemSelectedId, _itemSelected);
                    });
                    Navigator.of(context).pop();
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

  FutureBuilder<List<TipoEstablecimientoModel>> futureBuilderEstablecimiento() {
    return FutureBuilder(
      future: httpServices.listarTipoEstablecimiento(),
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
          return Container(
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(maxHeight: 134),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Error',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${snapshot.error}'),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Text('No se encontraron datos.');
        } else {
          return SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final tipoEstablecimientoItem = snapshot.data![index];
                return ListTile(
                  title: Text(tipoEstablecimientoItem.dTipoEstablecimiento!),
                  trailing: const Icon(Icons.radio_button_off_outlined),
                  onTap: () {
                    setState(() {
                      _itemSelectedId =
                          tipoEstablecimientoItem.tipoEstablecimientoId!;
                      _itemSelected =
                          tipoEstablecimientoItem.dTipoEstablecimiento!;
                      widget.onSelect(_itemSelectedId, _itemSelected);
                    });
                    Navigator.of(context).pop();
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
}

class MyNotifier extends ValueNotifier<BusquedaUbigeoModel> {
  MyNotifier(super.value);

  void changeMyData(int? ubigeoId, String codigo, String nombre) {
    value.ubigeoId = ubigeoId;
    value.codigo = codigo;
    value.nombre = nombre;
    notifyListeners();
  }
}

class UbigeoWidget extends StatefulWidget {
  final String label;
  final String? codigo;
  final bool enabled;
  final bool? reset;
  final void Function(int? ubigeoId, String codigo, String nombre)
      onSelectUbigeo;

  const UbigeoWidget(
      {super.key,
      required this.label,
      required this.onSelectUbigeo,
      this.codigo,
      required this.enabled,
      this.reset});

  @override
  State<UbigeoWidget> createState() => _UbigeoWidgetState();
}

class _UbigeoWidgetState extends State<UbigeoWidget> {
  final HttpServices httpServices = HttpServices();
  int? _itemSelectedUbigeoId;
  String _itemSelectedCodigo = '';
  String _itemSelectedNombre = '';

  @override
  Widget build(BuildContext context) {
    developer.log('data Ubigeo codigo : ${widget.label}- ${widget.codigo}',
        name: 'my.app.developer');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: widget.enabled
              ? () {
                  showDialogUbigeo(context);
                }
              : null,
        ),
        ElevatedButton(
          onPressed: () {},
/*           onPressed: widget.enabled
              ? () {
                  showDialogUbigeo(context);
                }
              : null, */
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF1976D2),
            minimumSize: const Size(160, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: SizedBox(
            width: 160,
            child: Text(
              _itemSelectedNombre.isEmpty ? widget.label : _itemSelectedNombre,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> showDialogUbigeo(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Buscar ${widget.label}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: (widget.label == 'Departamento')
              ? futureBuilderDepartamento()
              : (widget.label == 'Provincia')
                  ? futureBuilderProvincia(widget.codigo ?? '')
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Distrito'),
                    ),
        );
      },
    );
  }

  FutureBuilder<List<BusquedaUbigeoModel>> futureBuilderProvincia(
      String codigo) {
    return FutureBuilder(
      future: httpServices.listarProvincia(codigo),
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
          return Container(
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(maxHeight: 134),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Error',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${snapshot.error}'),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Text('No se encontraron datos.');
        } else {
          return SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final busquedaUbigeoItem = snapshot.data![index];
                return ListTile(
                  title: Text(busquedaUbigeoItem.nombre!),
                  trailing: const Icon(Icons.radio_button_off_outlined),
                  onTap: () {
                    setState(() {
                      _itemSelectedUbigeoId = busquedaUbigeoItem.ubigeoId;
                      _itemSelectedCodigo = busquedaUbigeoItem.codigo!;
                      _itemSelectedNombre = busquedaUbigeoItem.nombre!;
                      widget.onSelectUbigeo(_itemSelectedUbigeoId,
                          _itemSelectedCodigo, _itemSelectedNombre);
                    });
                    Navigator.of(context).pop();
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

  FutureBuilder<List<BusquedaUbigeoModel>> futureBuilderDepartamento() {
    return FutureBuilder(
      future: httpServices.listarDepartamento(),
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
          return Container(
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(maxHeight: 134),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Error',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${snapshot.error}'),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Text('No se encontraron datos.');
        } else {
          return SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final busquedaUbigeoItem = snapshot.data![index];
                return ListTile(
                  title: Text(busquedaUbigeoItem.nombre!),
                  trailing: const Icon(Icons.radio_button_off_outlined),
                  onTap: () {
                    setState(() {
                      _itemSelectedUbigeoId = busquedaUbigeoItem.ubigeoId;
                      _itemSelectedCodigo = busquedaUbigeoItem.codigo!;
                      _itemSelectedNombre = busquedaUbigeoItem.nombre!;
                      widget.onSelectUbigeo(busquedaUbigeoItem.ubigeoId,
                          _itemSelectedCodigo, _itemSelectedNombre);
                    });
                    Navigator.of(context).pop();
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
}
