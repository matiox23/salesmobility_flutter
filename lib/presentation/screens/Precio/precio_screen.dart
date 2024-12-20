import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_app_users/models/marca_model.dart';
import 'package:flutter_app_users/models/pass_model.dart';
import 'package:flutter_app_users/models/presentacion_model.dart';
import 'package:flutter_app_users/models/producto_model.dart';
import 'package:flutter_app_users/services/services.dart';
import 'dart:developer' as developer;

class PrecioScreen extends StatefulWidget {
  static String routeName = 'precios_screen';

  const PrecioScreen({super.key});

  @override
  State<PrecioScreen> createState() => _PrecioScreenState();
}

class _PrecioScreenState extends State<PrecioScreen> {
  final HttpServices httpServices = HttpServices();
  Uuid uuid = const Uuid();
  int _marcaId = 0;
  int _productoId = 0;
  final ValueNotifier<String> _marcaNombre = ValueNotifier<String>('');
  final ValueNotifier<String> _productoNombre = ValueNotifier<String>('');
  final ValueNotifier<String> _lineaProductoNombre = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PassModel;
    /* setState(() {
      selectedItems.clearItems();
    }); */
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: const Text(
            'Registro de Precios',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFFfc1404),
          actions: guardarPreciosButton(context, args),
        ),
        body: info(context, args),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF005854),
          foregroundColor: Colors.white,
          onPressed: () {
            setState(() {
              selectedItems.clearItems();
            });

            showDialogBusquedaPresentacion(context, args);
          },
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(6), // Personaliza el radio del borde
          ),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }

  Container info(BuildContext context, PassModel args) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, //center Hor.
            crossAxisAlignment: CrossAxisAlignment.center, // center Ver.
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    icon: const Icon(Icons.home),
                    onPressed: () {},
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
                  minimumSize: const Size(200, 40),
                ),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    args.tipoEstablecimientoNombre!,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centrar horizontalmente
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centrar verticalmente
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    icon: const Icon(Icons.location_on),
                    onPressed: () {},
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
                  minimumSize: const Size(200, 40),
                ),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    args.ubigeoNombre!,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              selectedItems.clearItems();
              showDialogBusquedaProducto(context, args);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1976D2),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(6), // Ajusta el radio como desees
              ),
              minimumSize: const Size(200, 40),
            ),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - 64,
              child: ValueListenableBuilder(
                valueListenable: _lineaProductoNombre,
                builder: (BuildContext context, String value, Widget? child) {
                  return Text(
                    value.isEmpty ? 'Datos' : value,
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: ValueListenableBuilder(
                  valueListenable: selectedItems,
                  builder: (BuildContext context, List<Presentaciones> value,
                      Widget? child) {
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: listaProductoPresentaciones(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> listaProductoPresentaciones() {
/*     List<Widget> temp = selectedItems.value.map(
      (item) {
        ProductoPresentacion temp = ProductoPresentacion(content: item);
        productoPresentaciones.add(temp);
        return temp;
      },
    ).toList(); */

    productoPresentaciones.clear();
    return selectedItems.value.map(
      (item) {
        ProductoPresentacion temp = ProductoPresentacion(content: item);
        productoPresentaciones.add(temp);
        return temp;
      },
    ).toList();
  }

  Future<dynamic> showDialogBusquedaPresentacion(
      BuildContext context, PassModel args) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 6),
          //titleTextStyle: TextStyle(backgroundColor: Colors.amber),
          title: const Text(
            'Búsqueda de Presentación',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: futureBuilderPresentaciones(args),
/*           actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
          actions: [
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

  FutureBuilder<List<PresentacionModel>> futureBuilderPresentaciones(
      PassModel args) {
    return FutureBuilder(
      future: httpServices.listarPresentaciones(
          args.lineaId!, _marcaId, _productoId),
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
                  child: const Text('Cerrar'),
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Text('No se encontraron datos.');
        } else {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index].presentaciones;
                      return itemPresentacion(item);
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      },
    );
  }

  //bool _isSelect = false;

  Widget itemPresentacion(List<Presentaciones> item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center, // center Ver.
        children: item.map((content) {
          return ItemPresentacion(itemPresentacion: content);
          /*  CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(content.dPresentacion),
            value: true,
            onChanged: (value) {
              developer.log('onTap - $value', name: 'my.app.developer');

              setState(() {});
            },
          ); */
        }).toList(),
      ),
    );
  }

  Future<dynamic> showDialogBusquedaProducto(
      BuildContext context, PassModel args) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 6),
          //titleTextStyle: TextStyle(backgroundColor: Colors.amber),
          title: const Text(
            'Búsqueda de Producto',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // El alto minimo
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //center Hor.
                crossAxisAlignment: CrossAxisAlignment.center, // center Ver.
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showDialogBuscarMarca(context, args);
                    },
                  ),
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size(200, 40),
                      maximumSize: const Size(200, 200),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _marcaNombre,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Text(
                          value.isEmpty ? 'Marca' : value,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrar horizontalmente
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centrar verticalmente
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showDialogBuscarProductos(context, args);
                    },
                  ),
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size(200, 40),
                      maximumSize: const Size(200, 200),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _productoNombre,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Text(
                          value.isEmpty ? 'Producto' : value,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          actionsPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          actions: [
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
          ],
        );
      },
    );
  }

  Future<dynamic> showDialogBuscarMarca(BuildContext context, PassModel args) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Buscar Marca',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: futureBuilderListarMarcas(args),
        );
      },
    );
  }

  FutureBuilder<List<MarcaModel>> futureBuilderListarMarcas(PassModel args) {
    return FutureBuilder(
      future: httpServices.listarMarcas(args.lineaId!),
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
                  child: const Text('Cerrar'),
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No se encontraron datos.'));
        } else if (snapshot.data!.isEmpty) {
          return SizedBox(
            width: double.maxFinite,
            height: 128,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(maxHeight: 134),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No existen resultados.'),
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
                      child: const Text('Cerrar',
                          style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
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
                final marcaItem = snapshot.data![index];
                return ListTile(
                  title: Text(marcaItem.dMarca!),
                  trailing: const Icon(Icons.radio_button_off_outlined),
                  onTap: () {
                    developer.log(
                        'onTap - ${marcaItem.marcaId!} - ${marcaItem.dMarca!}',
                        name: 'my.app.developer');
                    setState(() {
                      _marcaNombre.value = marcaItem.dMarca!;
                      _marcaId = marcaItem.marcaId!;
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

  Future<dynamic> showDialogBuscarProductos(
      BuildContext context, PassModel args) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Buscar Producto',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: futureBuilderListarProductos(args, _marcaId),
        );
      },
    );
  }

  FutureBuilder<List<ProductoModel>> futureBuilderListarProductos(
      PassModel args, int marcaId) {
    return FutureBuilder(
      future: httpServices.listarProductos(args.lineaId!, marcaId),
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
                  child: const Text('Cerrar'),
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No se encontraron datos.'));
        } else if (snapshot.data!.isEmpty) {
          return SizedBox(
            width: double.maxFinite,
            height: 128,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(maxHeight: 134),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No existen resultados.'),
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
                      child: const Text('Cerrar',
                          style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
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
                final item = snapshot.data![index];
                return itemProducto(item, args);
/*                 ListTile(
                  title: Text(item.nombre!),
                  trailing: const Icon(Icons.radio_button_off_outlined),
                  onTap: () {
                    developer.log(
                        'onTap - ${item.productoId!} - ${item.dMarca!}',
                        name: 'my.app.developer');
                    setState(() {
                      _marcaNombre.value = item.dMarca!;
                    });
                    Navigator.of(context).pop();
                  },
                ); */
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

  Widget itemProducto(ProductoModel item, PassModel args) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          developer.log('onTap - ${item.productoId!} - ${item.nombre!}',
              name: 'my.app.developer');
          setState(() {
            _lineaProductoNombre.value = '${args.lineaNombre} - ${item.nombre}';
            _productoNombre.value = '${item.nombre}';
            _productoId = item.productoId!;
          });
          Navigator.of(context).pop();
        },
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center, // center Ver.
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, //center Hor.
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    item.nombre!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFfc1404),
                    ),
                  ),
                ),
                Text(
                  item.viscosidad!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, //center Hor.
              children: [
                Text(
                  item.dTipoAceite!,
                  style: const TextStyle(fontSize: 9),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    item.dUsoAceite!,
                    style: const TextStyle(fontSize: 9),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> guardarPreciosButton(BuildContext context, PassModel args) {
    return [
      IconButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                title: const Text('Guardar Registro'),
                content:
                    const Text('Estas seguro que desea guardar el registro?'),
                contentPadding: const EdgeInsets.all(24),
                actionsPadding: EdgeInsets.zero,
                actions: [
                  TextButton(
                    onPressed: () {
                      bool isValidNumber = true;

                      for (int i = 0; i < productoPresentaciones.length; i++) {
                        ProductoPresentacion presentacion =
                            productoPresentaciones[i];

                        developer.log(
                            'Precio compra: ${i + 1} - ${presentacion.tcPrecioCompra.text} \n Precio venta : ${i + 1} - ${presentacion.tcPrecioVenta.text}',
                            name: 'my.app.developer');
                      }

                      List<Map<String, dynamic>> detalles = [];

                      for (int i = 0; i < selectedItems.value.length; i++) {
                        Presentaciones presentacion = selectedItems.value[i];
                        ProductoPresentacion presController =
                            productoPresentaciones[i];

                        double? numeroPrecioCompra =
                            tryParseDouble(presController.tcPrecioCompra.text);
                        double? numeroPrecioVenta =
                            tryParseDouble(presController.tcPrecioVenta.text);

                        if (numeroPrecioCompra != null &&
                            numeroPrecioVenta != null) {
                          developer.log('true', name: 'my.app.developer');
                          Map<String, dynamic> nuevoDetalle = {
                            "productoId": presentacion.productoId,
                            "presentacionId": presentacion.presentacionId,
                            "precioCompra": numeroPrecioCompra,
                            "precioVenta": numeroPrecioVenta,
                            "uriFoto": ""
                          };

                          detalles.add(nuevoDetalle);
                        } else {
                          developer.log('false', name: 'my.app.developer');
                          isValidNumber = false;
                          break;
                        }
                      }

                      Navigator.pop(context);

                      if (isValidNumber == false) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error de conversión'),
                              content: const Text('Precio no válido.'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              contentPadding: const EdgeInsets.all(24),
                              actionsPadding: EdgeInsets.zero,
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (detalles.isNotEmpty) {
                        Map<String, dynamic> tomaPrecios = {
                          "tipoEstablecimientoId": args.tipoEstablecimientoId,
                          "ubigeoId": args.ubigeoId,
                          "clienteId": 0,
                          "tipoPrecio": 0,
                          "detalles": detalles,
                        };

                        String jsonTomaPrecios = jsonEncode(tomaPrecios);

                        developer.log('Enviar - ${jsonTomaPrecios.toString()}',
                            name: 'my.app.developer');
                        showDialogGuardarTomaPrecio(
                            context, jsonTomaPrecios, uuid.v4());
                      }
                    },
                    child: const Text('Si'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No'),
                  )
                ],
              );
            },
          );
        },
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      )
    ];
  }

  /*  double? tryParseDouble(String numeroString) {
    try {
      // La conversión fue exitosa
      return double.parse(numeroString);
    } catch (e) {
      // La conversión falló
      return null;
    }
  } */

  Future<dynamic> showDialogGuardarTomaPrecio(
      BuildContext context, String json, String uuid) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 6),
          title: const Text(
            'Registro Precios',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: futureBuilderGuardarTomaPrecio(json, uuid),
        );
      },
    );
  }

  FutureBuilder<bool> futureBuilderGuardarTomaPrecio(String json, String uuid) {
    return FutureBuilder(
      future: httpServices.guardarPrecios(json, uuid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Text('Guardando...'),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.only(right: 8.0),
            constraints: const BoxConstraints(maxHeight: 134),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                  child: const Text('Cerrar'),
                )
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Text('No se encontraron datos.');
        } else {
          bool data = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(maxHeight: 134),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        data ? 'Éxito' : 'Error',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data
                              ? const Color(0xFF009632)
                              : const Color(0xFFfc1404),
                        ),
                      ),
                      Text(data
                          ? 'Registro guardado con éxito.'
                          : 'Ocurrió un problema al guardar.'),
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
                  child: const Text('Cerrar'),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

double? tryParseDouble(String numeroString) {
  try {
    // La conversión fue exitosa
    return double.parse(numeroString);
  } catch (e) {
    // La conversión falló
    return null;
  }
}

class ProductoPresentacion extends StatelessWidget {
  final Presentaciones content;
  final TextEditingController tcPrecioVenta = TextEditingController();
  final TextEditingController tcPrecioCompra = TextEditingController();

  ProductoPresentacion({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    tcPrecioVenta.text = content.precioVenta.toString();
    tcPrecioCompra.text = content.precioCompra.toString();

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF1976D2),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                selectImageProducto(content.dPresentacion),
                Text(
                  content.dPresentacion,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  // textAlign: TextAlign.center,
                ),
                SizedBox(
                  //width: 140,
                  child: Text(
                    content.detalle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 140,
                      //height: 100,
                      child: CustomTextFormField(
                          controllerText: tcPrecioCompra,
                          labelTipoPrecio: 'Precio Compra',
                          valorInicial: content.precioCompra),
                    ),
                    SizedBox(
                      width: 140,
                      //height: 100,
                      child: CustomTextFormField(
                          controllerText: tcPrecioVenta,
                          labelTipoPrecio: 'Precio Venta',
                          valorInicial: content.precioCompra),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SvgPicture selectImageProducto(String imageNombre) {
    String pathImage = 'images/no_image.svg';

    if (imageNombre == 'Bal' || imageNombre == 'Tam') {
      pathImage = 'images/ic_balde.svg';
    } else if (imageNombre == 'Gal' ||
        imageNombre == 'Gra' ||
        imageNombre == 'Pin') {
      pathImage = 'images/ic_galon_02.svg';
    } else if (imageNombre == 'Lit' || imageNombre == 'Cua') {
      pathImage = 'images/ic_litro_03.svg';
    }

    return SvgPicture.asset(
      pathImage,
      width: 64,
      height: 64,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controllerText;
  final String labelTipoPrecio;
  final double valorInicial;
  const CustomTextFormField({
    super.key,
    required this.controllerText,
    required this.labelTipoPrecio,
    required this.valorInicial,
  });

  @override
  Widget build(BuildContext context) {
    controllerText.addListener(
      () {
        final text = controllerText.text;
        if (text.contains(',')) {
          final updatedText = text.replaceAll(',', '.');
          controllerText.value = controllerText.value.copyWith(
            text: updatedText,
            selection: TextSelection.collapsed(offset: updatedText.length),
          );
        }
      },
    );

    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: controllerText,
      style: const TextStyle(color: Colors.white),
      //controller: textController1,
      decoration: InputDecoration(
        labelText: labelTipoPrecio,
        labelStyle: const TextStyle(color: Colors.white),
        contentPadding: const EdgeInsets.all(4),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFfc1404),
      ),
/*      onChanged: (value) {
        if (value.isNotEmpty) {
          double? number = tryParseDouble(controllerText.text);

          if (number != null) {
            number > 5.5
                ? developer.log('number mayor: $number',
                    name: 'my.app.developer')
                : developer.log('number menor:: $number',
                    name: 'my.app.developer');
          }
        }
      },
       onFieldSubmitted: (value) {
        developer.log('enter: ${controllerText.text}',
            name: 'my.app.developer');
      },
      onEditingComplete: () {
        developer.log('editing: ${controllerText.text}',
            name: 'my.app.developer');
      }, */
    );
  }
}

//List<String> selectedItems = [];
MyListNotifier<Presentaciones> selectedItems =
    MyListNotifier<Presentaciones>([]);

List<ProductoPresentacion> productoPresentaciones = [];

class ItemPresentacion extends StatefulWidget {
  final Presentaciones itemPresentacion;

  const ItemPresentacion({
    super.key,
    required this.itemPresentacion,
  });

  @override
  State<ItemPresentacion> createState() => _ItemPresentacionState();
}

class _ItemPresentacionState extends State<ItemPresentacion> {
  bool _isSelect = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.itemPresentacion.dPresentacion),
      value: _isSelect,
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (_isSelect) {
            return const Color(0xFF1976D2);
          } else {
            return Colors.transparent;
          }
        },
      ),
      onChanged: (value) {
        developer.log(
            'onTap - $value - ${widget.itemPresentacion.dPresentacion}',
            name: 'my.app.developer');

        setState(() {
          Presentaciones namePresentacion = widget.itemPresentacion;
          final itemExistsList = selectedItems.value.contains(namePresentacion);

          if (value == true) {
            _isSelect = true;

            if (itemExistsList == false) {
              // selectedItems.value.add(namePresentacion);
              // selectedItems.notifyListeners();
              selectedItems.addItem(namePresentacion);
            }
          } else {
            _isSelect = false;

            if (itemExistsList == true) {
              // selectedItems.value.remove(namePresentacion);
              selectedItems.removeItem(namePresentacion);
            }
          }

          developer.log(
              'Lista: ${selectedItems.value.map((item) {
                return item;
              })}',
              name: 'my.app.developer');
        });
      },
    );
  }
}

class MyListNotifier<T> extends ValueNotifier<List<T>> {
  MyListNotifier(super.initialValue);

  void addItem(T item) {
    value.add(item);
    notifyListeners();
  }

  void removeItem(T item) {
    value.remove(item);
    notifyListeners();
  }

  void clearItems() {
    value.clear();
    notifyListeners();
  }
}
