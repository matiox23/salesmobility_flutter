import 'dart:convert';
//import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_users/models/channel_map_model.dart';
import 'package:flutter_app_users/models/pass_channel_map_model.dart';
import 'dart:developer' as developer;

import 'package:flutter_app_users/services/services.dart';
import 'package:uuid/uuid.dart';

class ChannelMapScreen extends StatefulWidget {
  static String routeName = 'channel_map_screen';

  const ChannelMapScreen({super.key});

  @override
  State<ChannelMapScreen> createState() => _ChannelMapScreenState();
}

class _ChannelMapScreenState extends State<ChannelMapScreen> {
  final HttpServices httpServices = HttpServices();

  final ValueNotifier<String> ultimoChannel = ValueNotifier<String>("--");
  String itemUltimoChannel = "";
  final ValueNotifier<int> totalGalones = ValueNotifier<int>(0);
  final ValueNotifier<int> totalMarcas = ValueNotifier<int>(0);
  TextEditingController tcComentario = TextEditingController(text: "");
  Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PassChannelMapModel;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Channel Map',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF1976D2),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'guardar',
                    child: Text('Guardar'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'desactivar',
                    child: Text('Desactivar PDV'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'guardar') {
                    guardarChannelMap(context, args);
                  }
                  developer.log('opcion seleccionada: $value',
                      name: 'my.app.developer');
                },
              ),
            ]),
        body: info(context, args),
      ),
    );
  }

  void guardarChannelMap(BuildContext context, PassChannelMapModel args) {
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
              'Guardar Registro',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          content: const Text('Estas seguro que desea guardar el registro?'),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(24),
          actionsPadding: EdgeInsets.zero,
          actions: [
            TextButton(
              onPressed: () {
                bool isValidNumber = true;

                for (int i = 0; i < marcaPresentaciones.length; i++) {
                  MarcaPresentacion presentacion = marcaPresentaciones[i];

                  developer.log(
                      'Nombre: ${i + 1} - ${presentacion.content.nombre}',
                      name: 'my.app.developer');
                  developer.log('tcCLV: ${presentacion.tcCLV.text}',
                      name: 'my.app.developer');
                  developer.log('tcPVL: ${presentacion.tcPVL.text}',
                      name: 'my.app.developer');
                  developer.log('tcMCO:  ${presentacion.tcMCO.text}',
                      name: 'my.app.developer');
                  developer.log('tcIND: ${presentacion.tcIND.text}',
                      name: 'my.app.developer');
                }

                List<Map<String, dynamic>> detalles = [];

                for (int i = 0; i < marcaPresentaciones.length; i++) {
                  MarcaPresentacion presentacion = marcaPresentaciones[i];

                  int? numberTcCLV = tryParseInt(presentacion.tcCLV.text);
                  int? numberTcPVL = tryParseInt(presentacion.tcPVL.text);
                  int? numberTcMCO = tryParseInt(presentacion.tcMCO.text);
                  int? numberTcIND = tryParseInt(presentacion.tcIND.text);

                  if (numberTcCLV != null &&
                      numberTcPVL != null &&
                      numberTcMCO != null &&
                      numberTcIND != null) {
                    developer.log('true', name: 'my.app.developer');

                    if (numberTcPVL >= 0) {
                      Map<String, dynamic> nuevoDetalle = {
                        "marcaId": presentacion.content.marcaId,
                        "lobId": 1,
                        "galones": numberTcPVL,
                      };

                      detalles.add(nuevoDetalle);
                    }
                    if (numberTcCLV >= 0) {
                      Map<String, dynamic> nuevoDetalle = {
                        "marcaId": presentacion.content.marcaId,
                        "lobId": 2,
                        "galones": numberTcCLV,
                      };

                      detalles.add(nuevoDetalle);
                    }
                    if (numberTcMCO >= 0) {
                      Map<String, dynamic> nuevoDetalle = {
                        "marcaId": presentacion.content.marcaId,
                        "lobId": 3,
                        "galones": numberTcMCO,
                      };

                      detalles.add(nuevoDetalle);
                    }
                    if (numberTcIND >= 0) {
                      Map<String, dynamic> nuevoDetalle = {
                        "marcaId": presentacion.content.marcaId,
                        "lobId": 4,
                        "galones": numberTcIND,
                      };

                      detalles.add(nuevoDetalle);
                    }
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
                  Map<String, dynamic> tomaChannelMap = {
                    "latitud": "",
                    "longitud": "",
                    "uriFoto": "",
                    "Observacion": tcComentario.text,
                    "detalles": detalles,
                  };

                  final clienteSucursalId = <String, dynamic>{
                    "clienteSucursalId": args.clienteRutaModel!.sucursalId
                  };
                  final prospectoClienteId = <String, dynamic>{
                    "prospectoClienteId": args.clienteRutaModel!.prospectoId
                  };

                  if (!args.esClienteProspecto!) {
                    tomaChannelMap.addEntries(clienteSucursalId.entries);
                  } else {
                    tomaChannelMap.addEntries(prospectoClienteId.entries);
                  }

                  String jsonTomaChannelMap = jsonEncode(tomaChannelMap);

                  developer.log('Enviar - ${jsonTomaChannelMap.toString()}',
                      name: 'my.app.developer');
                  showDialogGuardarTomaChannelMap(
                      context, jsonTomaChannelMap, uuid.v4());
                }
              },
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

  Future<dynamic> showDialogGuardarTomaChannelMap(
      BuildContext context, String json, String uuid) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 6),
          title: const Text(
            'Registro ChannelMap',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: futureBuilderGuardarTomaChannel(json, uuid),
        );
      },
    );
  }

  FutureBuilder<bool> futureBuilderGuardarTomaChannel(
      String json, String uuid) {
    return FutureBuilder(
      future: httpServices.guardarChannelMap(json, uuid),
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

  int? tryParseInt(String numeroString) {
    try {
      // La conversión fue exitosa
      return int.parse(numeroString);
    } catch (e) {
      // La conversión falló
      return null;
    }
  }

  Container info(BuildContext context, PassChannelMapModel args) {
    return Container(
      padding: EdgeInsets.zero,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // center Ver.
              children: [
                Text(
                  args.clienteRutaModel!.dCliente!,
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  args.clienteRutaModel!.direccion!,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            color: const Color(0xFF1976D2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'INGRESO DE DATOS',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
                // Text(
                //   "--",
                //   style: TextStyle(fontSize: 11, color: Colors.yellow[700]),
                // ),
                ValueListenableBuilder(
                  valueListenable: ultimoChannel,
                  builder: (BuildContext context, String value, Widget? child) {
                    return Text(
                      ultimoChannel.value,
                      style: TextStyle(fontSize: 11, color: Colors.yellow[700]),
                    );
                  },
                )
              ],
            ),
          ),
          Container(
            color: const Color(0xFF645E5E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ValueListenableBuilder(
                        valueListenable: totalMarcas,
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return Text(
                            "# Marcas: ${totalMarcas.value}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ValueListenableBuilder(
                        valueListenable: totalGalones,
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return Text(
                            "# Galones: ${totalGalones.value}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: onTapCalcularGalonesMarcas,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: const Color(0xFF645E5E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ingresarComentario();
                        developer.log('onTap - comment',
                            name: 'my.app.developer');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: const Color(0xFF645E5E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.comment,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: InkWell(
                    //     onTap: onTapCalcularGalonesMarcas,
                    //     child: const Icon(
                    //       Icons.refresh,
                    //       size: 28,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: InkWell(
                    //     onTap: () {
                    //       ingresarComentario();
                    //       developer.log('onTap - comment',
                    //           name: 'my.app.developer');
                    //     },
                    //     child: const Icon(
                    //       Icons.comment,
                    //       size: 28,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          developer.log('onTap - camera',
                              name: 'my.app.developer');
                        },
                        child: const Icon(
                          Icons.photo_camera,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: futureBuilderChannelMapMarcas(
                  args.esClienteProspecto!
                      ? 0
                      : args.clienteRutaModel!.sucursalId!,
                  args.esClienteProspecto!
                      ? args.clienteRutaModel!.prospectoId!
                      : 0))
        ],
      ),
    );
  }

  void ingresarComentario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          title: Container(
            color: const Color(0xFF1976D2),
            padding: EdgeInsets.zero,
            child: const Text(
              'Comentario',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(16),
          actionsPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 300, // Ancho del área de texto
            height: 200, // Altura del área de texto
            child: ListView(
              children: [
                TextFormField(
                  controller: tcComentario,
                  maxLines: null, // Permite múltiples líneas
                  decoration: const InputDecoration(
                    label: Text('Escribe aquí'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cerrar', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void onTapCalcularGalonesMarcas() {
    int tGalon = 0, tMarca = 0;

    if (itemUltimoChannel != "") {
      ultimoChannel.value = itemUltimoChannel;
    }

    for (int i = 0; i < marcaPresentaciones.length; i++) {
      MarcaPresentacion presentacion = marcaPresentaciones[i];
      int tcCLV = int.parse(presentacion.tcCLV.text);
      int tcPVL = int.parse(presentacion.tcPVL.text);
      int tcMCO = int.parse(presentacion.tcMCO.text);
      int tcIND = int.parse(presentacion.tcIND.text);

      int suma = tcCLV + tcPVL + tcMCO + tcIND;

      tGalon += suma;

      if (suma > 0) {
        tMarca++;
      }

      developer.log('Marca: ${presentacion.content.nombre}',
          name: 'my.app.developer');
      developer.log('CVL: ${presentacion.tcCLV.text}',
          name: 'my.app.developer');
      developer.log('PVL: ${presentacion.tcPVL.text}',
          name: 'my.app.developer');
      developer.log('MCO: ${presentacion.tcMCO.text}',
          name: 'my.app.developer');
      developer.log('IND: ${presentacion.tcIND.text}',
          name: 'my.app.developer');
    }

    totalGalones.value = tGalon;
    totalMarcas.value = tMarca;

    developer.log('onTap - refresh', name: 'my.app.developer');
  }

  FutureBuilder<List<ChannelMapModel>> futureBuilderChannelMapMarcas(
      int clienteSucurcalId, int prospectoClienteId) {
    return FutureBuilder(
      future: httpServices.listarChannelMapMarcas(
          clienteSucurcalId, prospectoClienteId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Listando...'),
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
          return const Text('No se encontraron datos.');
        } else {
          marcaPresentaciones.clear();
          return SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                ),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final channelmapItem = snapshot.data![index];

                  if (channelmapItem.ultimaOla != null) {
                    itemUltimoChannel =
                        "${channelmapItem.ultimaOla} -> ${channelmapItem.ultimaFecha}";
                  }
                  final marcaPre = MarcaPresentacion(content: channelmapItem);
                  marcaPresentaciones.add(marcaPre);
                  return marcaPre;
                },
              ),
            ),
          );
        }
      },
    );
  }
}

List<MarcaPresentacion> marcaPresentaciones = [];
//TextEditingController tcComentario = TextEditingController(text: "");

class MarcaPresentacion extends StatelessWidget {
  final ChannelMapModel content;
  final TextEditingController tcCLV = TextEditingController();
  final TextEditingController tcPVL = TextEditingController();
  final TextEditingController tcMCO = TextEditingController();
  final TextEditingController tcIND = TextEditingController();

  MarcaPresentacion({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    tcCLV.text = content.cvl.toString();
    tcPVL.text = content.pvl.toString();
    tcMCO.text = content.mco.toString();
    tcIND.text = content.ind.toString();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyImageWidget(imageUrl: content.imagen!),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 50,
                  height: 46,
                  child: MarcaTextFormField(
                      controllerText: tcCLV,
                      labelTipo: 'CLV',
                      valorInicial: content.cvl!),
                ),
                SizedBox(
                  width: 50,
                  height: 46,
                  child: MarcaTextFormField(
                      controllerText: tcPVL,
                      labelTipo: 'PVL',
                      valorInicial: content.pvl!),
                )
              ],
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 50,
                  height: 46,
                  child: MarcaTextFormField(
                      controllerText: tcMCO,
                      labelTipo: 'MCO',
                      valorInicial: content.mco!),
                ),
                SizedBox(
                  width: 50,
                  height: 46,
                  child: MarcaTextFormField(
                      controllerText: tcIND,
                      labelTipo: 'IND',
                      valorInicial: content.ind!),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MarcaTextFormField extends StatelessWidget {
  final TextEditingController controllerText;
  final String labelTipo;
  final int valorInicial;
  const MarcaTextFormField({
    super.key,
    required this.controllerText,
    required this.labelTipo,
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
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: controllerText,
      style: const TextStyle(
          color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: labelTipo,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
        contentPadding: const EdgeInsets.all(4),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onTap: () {
        controllerText.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controllerText.text.length,
        );
        developer.log('enter onTap: ${controllerText.text}',
            name: 'my.app.developer');
      },
      onChanged: (value) {
        if (value.isEmpty) {
          controllerText.text = '0';
          controllerText.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controllerText.text.length,
          );
        } else {
          controllerText.text = value;
        }
        developer.log('enter onChange: ${controllerText.text}',
            name: 'my.app.developer');
      },
    );
  }
}

class MyImageWidget extends StatelessWidget {
  final String imageUrl;

  const MyImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
        color: Color(0xFF1976D2),
      )),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 32),
      fit: BoxFit.scaleDown,
      width: 120,
      height: 56,
    );
  }
}
