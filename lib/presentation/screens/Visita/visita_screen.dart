//import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'package:flutter_app_users/blocs/blocs.dart';
import 'package:flutter_app_users/blocs/internet_connection/bloc/internet_bloc.dart';
import 'package:flutter_app_users/presentation/screens/Visita/utils/custom_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:custom_timer/custom_timer.dart';
import 'package:flutter_app_users/models/cliente_ruta_model.dart';
import 'package:flutter_app_users/models/motivo_no_compra.dart';
import 'package:flutter_app_users/models/motivo_visita_model.dart';
import 'package:flutter_app_users/models/pass_channel_map_model.dart';
import 'package:flutter_app_users/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

String horaInicioVisita = "";

class VisitaScreen extends StatefulWidget {
  static String routeName = 'visita_screen';

  const VisitaScreen({super.key});

  @override
  State<VisitaScreen> createState() => _VisitaScreenState();
}

class _VisitaScreenState extends State<VisitaScreen> {
  final HttpServices httpServices = HttpServices();
  TextEditingController tcComentario = TextEditingController(text: "");
  Uuid uuid = const Uuid();
  //String horaInicioVisita = "";
  int idMotivoVisita = -1;
  int idMotivoNoCompra = -1;
  File? photoFirst;
  File? photoSecond;
  bool isRequiredPhoto = false;
  Position? currentPosition;
  String latitudPDV = "";
  String longitudPDV = "";

  @override
  void initState() {
    loadConfigVisita();
    obtenerUbicacion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    developer.log('Building Visita', name: 'my.app.developer');
    final args =
        ModalRoute.of(context)!.settings.arguments as PassChannelMapModel;

    latitudPDV = args.clienteRutaModel!.latitud! != ""
        ? args.clienteRutaModel!.latitud!
        : "";
    longitudPDV = args.clienteRutaModel!.longitud! != ""
        ? args.clienteRutaModel!.longitud!
        : "";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Visita',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1976D2),
          iconTheme: const IconThemeData(color: Colors.white),
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
                  value: 'guardar',
                  child: Text('Guardar Visita'),
                ),
                const PopupMenuItem<String>(
                  value: 'GeoCerca',
                  child: Text('Verificar GeoCerca'),
                ),
              ],
              onSelected: (value) {
                if (value == 'guardar') {
                  //guardarChannelMap(context, args);
                  guardarVisita(context, args);
                }
              },
            ),
          ],
        ),
        body: info(context, args),
      ),
    );
  }

  void guardarVisita(BuildContext context, PassChannelMapModel args) {
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
          content: const Text('¿Estás seguro de querer guardar el registro?'),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(24),
          actionsPadding: EdgeInsets.zero,
          actions: [
            BlocBuilder<InternetBloc, InternetState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () async {
                    //Navigator.pop(context);
                    /* showDialogGuardarTomaChannelMap(
                        context, jsonTomaChannelMap, uuid.v4()); */
                    // developer.log('Before $currentPosition', name: 'my.app.developer');
                    Navigator.pop(context);

                    if (horaInicioVisita.isEmpty) {
                      showDialogWarning(
                        "Guardar Registro",
                        "Debe iniciar la hora de la visita.",
                        context,
                      );
                      return;
                    }

                    if (idMotivoVisita == -1) {
                      showDialogWarning(
                        "Guardar Registro",
                        "Debe seleccionar un motivo de visita.",
                        context,
                      );
                      return;
                    }

                    if (isRequiredPhoto) {
                      if (photoFirst == null && photoSecond == null) {
                        showDialogWarning(
                          "Guardar Registro",
                          "Es necesario incluir al menos una foto durante la visita.",
                          context,
                        );

                        return;
                      }
                    }

                    developer.log('Comentario Visita: ${tcComentario.text}',
                        name: 'my.app.developer');

                    if (tryParseDouble(latitudPDV) == null ||
                        tryParseDouble(longitudPDV) == null) {
                      showDialogWarning(
                        "Guardar Registro",
                        "El PDV no tiene georeferencia.",
                        context,
                      );

                      return;
                    }

                    if (state is ConnectedState) {
                      if (currentPosition != null) {
                        double radio = meterDistanceBetweenPoints(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                          double.parse(latitudPDV),
                          double.parse(longitudPDV),
                        );

                        if (radio > 200) {
                          showDialogWarning(
                            "Guardar Registro",
                            "El PDV no se encuentra dentro de la zona de cobertura.",
                            context,
                          );

                          return;
                        } else {
                          developer.log('Distancia hasta el PDV: $radio',
                              name: 'my.app.developer');
                        }

                        developer.log('Guardando Visita...',
                              name: 'my.app.developer');
                      }
                    } else {
                      developer.log(
                          'Current Position Offline: $currentPosition',
                          name: 'my.app.developer');
                    }
                  },
                  child: const Text(
                    'Si',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
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

  double? tryParseDouble(String numeroString) {
    try {
      // La conversión fue exitosa
      return double.parse(numeroString);
    } catch (e) {
      // La conversión falló
      return null;
    }
  }

  double meterDistanceBetweenPoints(
      double latActual, double lngActual, double latPDV, double lngPDV) {
    // Convertir grados a radianes
    double pk = 180 / pi;

    double a1 = latActual / pk;
    double a2 = lngActual / pk;
    double b1 = latPDV / pk;
    double b2 = lngPDV / pk;

    // Calcular los términos del coseno
    double t1 = cos(a1) * cos(a2) * cos(b1) * cos(b2);
    double t2 = cos(a1) * sin(a2) * cos(b1) * sin(b2);
    double t3 = sin(a1) * sin(b1);

    // Calcular el ángulo central entre los puntos
    double tt = acos(t1 + t2 + t3);

    // Radio de la Tierra en metros
    const double earthRadius = 6366000;

    // Calcular la distancia
    return earthRadius * tt;
  }

  Future<void> loadConfigVisita() async {
    final prefVisita = await SharedPreferences.getInstance();
    isRequiredPhoto = prefVisita.getBool('OBLIGAFOTOVISITA') ?? false;
    developer.log('Visita required photo: $isRequiredPhoto',
        name: 'my.app.developer');
  }

  Future<void> obtenerUbicacion() async {
    try {
      Position position = await httpServices.getCoordinates();

      currentPosition = position;

      developer.log(
          'Ubicación actual: ${position.latitude}, ${position.longitude}',
          name: 'my.app.developer');
    } catch (error) {
      developer.log('Error al obtener la ubicación: $error',
          name: 'my.app.developer');
      currentPosition = null;
    }
  }

  Future<PositionData> getPosition() async {
    try {
      Position position = await httpServices.getCoordinates();

/*       developer.log(
          'Current Position: ${position.latitude}, ${position.longitude}',
          name: 'my.app.developer'); */
      return PositionData(position: position, error: '');
    } catch (error) {
/*       developer.log('Error Position: $error', name: 'my.app.developer');
 */
      return PositionData(position: null, error: error.toString());
    }
  }

  Container info(BuildContext context, PassChannelMapModel args) {
    return Container(
      padding: EdgeInsets.zero,
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
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
                    style: const TextStyle(fontSize: 11),
                  ),
                  Text(
                    args.clienteRutaModel!.direccion!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
            ),
            Cronometro(
              clienteRutaModel: args.clienteRutaModel!,
              onSelect: (valueStrCrono) {
                developer.log('Inicio de Visita: $valueStrCrono',
                    name: 'my.app.developer');
                horaInicioVisita = valueStrCrono;
              },
            ),
            MotivoVisita(
              clienteRutaModel: args.clienteRutaModel!,
              onSelect: (valueIdMotivo) {
                developer.log('Id Motivo Visita: $valueIdMotivo',
                    name: 'my.app.developer');
                idMotivoVisita = valueIdMotivo;
              },
            ),
            MotivoNoCompra(
              clienteRutaModel: args.clienteRutaModel!,
              onSelect: (valueIdNoCompra) {
                developer.log('Id No Compra Visita: $valueIdNoCompra',
                    name: 'my.app.developer');
                idMotivoNoCompra = valueIdNoCompra;
              },
            ),
            PickerPhotoCamera(
              clienteRutaModel: args.clienteRutaModel!,
              onSelect: (File? photoBase, int position) {
                assignPhoto(photoBase, position);
              },
            ),
            ComentarioVisita(
                clienteRutaModel: args.clienteRutaModel!,
                tcComentario: tcComentario),
          ],
        ),
      ),
    );
  }

  void assignPhoto(File? photoBase, int position) {
    if (position == 1) {
      if (photoBase != null) {
        developer.log('Photo First Base: ${photoBase.path}',
            name: 'my.app.developer');
        photoFirst = photoBase;
      } else {
        photoFirst = photoBase;
      }
    } else if (position == 2) {
      if (photoBase != null) {
        developer.log('Photo Second Base: ${photoBase.path}',
            name: 'my.app.developer');
        photoSecond = photoBase;
      } else {
        photoSecond = null;
      }
    }
  }
}

class ComentarioVisita extends StatefulWidget {
  final ClienteRutaModel clienteRutaModel;
  final TextEditingController tcComentario;
  const ComentarioVisita({
    super.key,
    required this.clienteRutaModel,
    required this.tcComentario,
  });

  @override
  State<ComentarioVisita> createState() => _ComentarioVisitaState();
}

class _ComentarioVisitaState extends State<ComentarioVisita> {
  int _currentSucursalId = -1;
  @override
  void initState() {
    super.initState();

    getComentarioData().then((value) {
      _currentSucursalId = widget.clienteRutaModel.sucursalId!;
      if (value.comentarioVisita.isNotEmpty &&
          _currentSucursalId == value.sucursalIdComentario) {
        widget.tcComentario.text = value.comentarioVisita;
      }
    });

    // Agregar un listener al controlador
    widget.tcComentario.addListener(() {
      String text = widget.tcComentario.text;
      developer.log('Comentario Visita: $text', name: 'my.app.developer');
      saveComentarioVisita(text, widget.clienteRutaModel);
    });
  }

  Future<ComentarioData> getComentarioData() async {
    final prefs = await SharedPreferences.getInstance();

    String comentarioVisita = prefs.getString('ComentarioVisita') ?? "";
    int sucursalIdComentario = prefs.getInt('SucursalIdComentario') ?? -1;

    return ComentarioData(
      comentarioVisita: comentarioVisita,
      sucursalIdComentario: sucursalIdComentario,
    );
  }

  void saveComentarioVisita(
      String comentario, ClienteRutaModel clienteRutaModel) async {
    final prefs = SharedPreferences.getInstance();

    final comentariovisitaFuture =
        prefs.then((prefs) => prefs.setString('ComentarioVisita', comentario));

    final clienteSucursalIdFuture = prefs.then((prefs) =>
        prefs.setInt('SucursalIdComentario', clienteRutaModel.sucursalId!));

    final results =
        await Future.wait([comentariovisitaFuture, clienteSucursalIdFuture]);

    final stateComentariovisita = results[0];
    final stateClienteSucursalId = results[1];

    if (stateComentariovisita && stateClienteSucursalId) {
      developer.log("Save comentario Visita - true", name: 'my.app.developer');
      //return;
    } else {
      developer.log("Save comentario Visita - false", name: 'my.app.developer');
      //return;
    }
  }

  @override
  void dispose() {
    widget.tcComentario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: const Color(0xFF1976D2),
            child: const Text(
              'Comentario',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 120,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                TextFormField(
                  controller: widget.tcComentario,
                  maxLines: null, // Permite múltiples líneas
                  decoration: const InputDecoration(
                    labelText: 'Escribe aquí', // Cambiado de label a labelText
                  ),
                  onFieldSubmitted: (value) {
                    // Aquí se ejecuta cuando se envía el formulario (presionando Enter) o se cambia el foco fuera del campo
                    developer.log("Valor ingresado: $value",
                        name: 'my.app.developer');
                  },
                  onTapOutside: (event) {
                    developer.log("onTapOutside TextFormField",
                        name: 'my.app.developer');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PickerPhotoCamera extends StatefulWidget {
  final ClienteRutaModel clienteRutaModel;
  final void Function(File? photoBase, int position) onSelect;

  const PickerPhotoCamera(
      {super.key, required this.onSelect, required this.clienteRutaModel});

  @override
  State<PickerPhotoCamera> createState() => _PickerPhotoCameraState();
}

class _PickerPhotoCameraState extends State<PickerPhotoCamera> {
  File? _selectedPhotoFirst, _selectedPhotoSecond;
  //String _base64ImageSecond = "", _base64ImageFirst = "";
  int _currentSucursalId = -1;

  @override
  void initState() {
    super.initState();
    getPhotoData().then((value) {
      _currentSucursalId = widget.clienteRutaModel.sucursalId!;

      if (value.photoFirstPath.isNotEmpty &&
          _currentSucursalId == value.sucursalIdPhoto) {
        setState(() {
          _selectedPhotoFirst = File(value.photoFirstPath);
          widget.onSelect(_selectedPhotoFirst, 1);
          developer.log("Init image One: ${_selectedPhotoFirst!.path}",
              name: 'my.app.developer');
        });
      }
      if (value.photoSecondPath.isNotEmpty &&
          _currentSucursalId == value.sucursalIdPhoto) {
        setState(() {
          _selectedPhotoSecond = File(value.photoSecondPath);
          widget.onSelect(_selectedPhotoSecond, 2);
          developer.log("Init image Two: ${_selectedPhotoSecond!.path}",
              name: 'my.app.developer');
        });
      }
    });
  }

  Future<PhotoData> getPhotoData() async {
    final prefs = await SharedPreferences.getInstance();

    String photoFirstPath = prefs.getString('PhotoFirstPath') ?? "";
    String photoSecondPath = prefs.getString('PhotoSecondPath') ?? "";
    int sucursalIdPhoto = prefs.getInt('SucursalIdPhoto') ?? -1;

    return PhotoData(
      photoFirstPath: photoFirstPath,
      photoSecondPath: photoSecondPath,
      sucursalIdPhoto: sucursalIdPhoto,
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectedPhotoFirst != null
        ? developer.log(_selectedPhotoFirst!.path, name: 'my.app.developer')
        : developer.log("Null image 111", name: 'my.app.developer');

    _selectedPhotoSecond != null
        ? developer.log(_selectedPhotoSecond!.path, name: 'my.app.developer')
        : developer.log("Null image 222", name: 'my.app.developer');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: const Color(0xFF1976D2),
          child: const Text(
            'FOTOS DE VISITA',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () => _pickImageFromCamera(
                (value) {
                  setState(() {
                    if (value != null) {
                      _selectedPhotoFirst = value;
                      developer.log(
                          '_selectedPhotoFirst: ${_selectedPhotoFirst!.path}',
                          name: 'my.app.developer');
                      savePhotoLocal(widget.clienteRutaModel, value, 1);
                      // List<int> imageBytes = value.readAsBytesSync();
                      // _base64ImageFirst = base64Encode(imageBytes);
                      widget.onSelect(value, 1);
                    }
                  });
                },
              ),
              onLongPress: () {
                if (_selectedPhotoFirst != null) {
                  deletePhotoDialog(
                    context,
                    (value) => setState(() {
                      _selectedPhotoFirst = value;
                      // _base64ImageFirst = "";
                      widget.onSelect(null, 1);
                    }),
                  );
                }
              },
              child: _selectedPhotoFirst != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        _selectedPhotoFirst!,
                        width: 130,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'images/ic_photo_default.png',
                        width: 130,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
            InkWell(
              onTap: () => _pickImageFromCamera(
                (value) {
                  setState(
                    () {
                      if (value != null) {
                        _selectedPhotoSecond = value;
                        savePhotoLocal(widget.clienteRutaModel, value, 2);
                        // List<int> imageBytes = value.readAsBytesSync();
                        // _base64ImageSecond = base64Encode(imageBytes);
                        widget.onSelect(value, 2);
                      }
                    },
                  );
                },
              ),
              onLongPress: () {
                if (_selectedPhotoSecond != null) {
                  deletePhotoDialog(
                    context,
                    (value) => setState(() {
                      _selectedPhotoSecond = value;
                      // _base64ImageSecond = "";
                      widget.onSelect(null, 2);
                    }),
                  );
                }
              },
              child: _selectedPhotoSecond != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        _selectedPhotoSecond!,
                        width: 130,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'images/ic_photo_default.png',
                        width: 130,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  void savePhotoLocal(
      ClienteRutaModel clienteRutaModel, File? file, int index) async {
    final prefs = SharedPreferences.getInstance();

    final photoPath = prefs.then((prefs) => prefs.setString(
          index == 1 ? 'PhotoFirstPath' : 'PhotoSecondPath',
          file!.path,
        ));

    final clienteSucursalId = prefs.then((prefs) =>
        prefs.setInt('SucursalIdPhoto', clienteRutaModel.sucursalId!));

    final results = await Future.wait([photoPath, clienteSucursalId]);

    final statePhotoPath = results[0];
    final stateClienteSucursalId = results[1];

    if (statePhotoPath && stateClienteSucursalId) {
      developer.log("Save photo $index: $statePhotoPath",
          name: 'my.app.developer');
      return;
    } else {
      developer.log("Save photo $index : $statePhotoPath",
          name: 'my.app.developer');
    }
  }

  Future<dynamic> deletePhotoDialog(
      BuildContext context, Function(File?) deletePhoto) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            color: const Color(0xFF1976D2),
            child: const Text(
              'Eliminar Foto',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: const Text('Desesa eliminar la foto?'),
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // setState(() {
                //   index == 1
                //       ? _selectedPhotoFirst = null
                //       : _selectedPhotoSecond = null;
                // });
                deletePhoto(null);
                Navigator.pop(context);
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
            ),
          ],
        );
      },
    );
  }

/*   Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(
      () {
        _selectedPhotoFirst = File(returnedImage.path);
      },
    );
  } */

  Future<void> _pickImageFromCamera(Function(File?) pickerPhoto) async {
    final returnedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        maxWidth: 1280,
        maxHeight: 720);

    if (returnedImage == null) return;
    // setState(
    //   () {
    //     index == 1
    //         ? _selectedPhotoFirst = File(returnedImage.path)
    //         : _selectedPhotoSecond = File(returnedImage.path);
    //   },
    // );

    developer.log("Photo path: ${returnedImage.path}",
        name: 'my.app.developer');
    pickerPhoto(File(returnedImage.path));
  }
}

class Cronometro extends StatefulWidget {
  final ClienteRutaModel clienteRutaModel;
  final void Function(String valueStr) onSelect;

  const Cronometro({
    super.key,
    required this.clienteRutaModel,
    required this.onSelect,
  });

  @override
  State<Cronometro> createState() => _CronometroState();
}

class _CronometroState extends State<Cronometro>
    with SingleTickerProviderStateMixin {
  String _hours = '00';
  String _minutes = '00';
  String _seconds = '00';
  bool _isCronoInit = false;
  int _currentSucursalId = -1;

  late final CustomTimerController _controller = CustomTimerController(
      vsync: this,
      begin: const Duration(seconds: 0),
      end: const Duration(hours: 22, minutes: 0, seconds: 0),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds);

  @override
  void initState() {
    super.initState();

    getCronoData().then((value) {
      _currentSucursalId = widget.clienteRutaModel.sucursalId!;

      if (value.cronoInit &&
          value.cronoNow.isNotEmpty &&
          value.clienteSucursalId == _currentSucursalId &&
          value.cronoInitDate.isEmpty == false) {
        //Obtenemos la fecha actual
        DateTime now = DateTime.now();

        // Parseamos las fechas usando DateTime
        DateTime oldInitDate = DateTime.parse(value.cronoInitDate);

        restoreTime(oldInitDate, now, _controller, value);
      }
    });
  }

  void restoreTime(DateTime oldInitDate, DateTime currentDate,
      CustomTimerController controller, CronoData value) {
    // Extraemos solo las fechas (sin la hora)
    DateTime oldDateOnly =
        DateTime(oldInitDate.year, oldInitDate.month, oldInitDate.day);
    DateTime currentDateOnly =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    // Comparamos las fechas (sin la hora)
    if (oldDateOnly.isBefore(currentDateOnly) ||
        oldDateOnly.isAfter(currentDateOnly)) {
      developer.log("CronoInit is Before or is After",
          name: 'my.app.developer');
      //horaInicioVisita = "";
      widget.onSelect("");
      controller.reset();
    } else {
      developer.log("Restore time", name: 'my.app.developer');
      //horaInicioVisita = value.cronoInitDate;
      widget.onSelect(value.cronoInitDate);
      calculateTimeDifference(currentDate, controller, value);
    }
  }

  void calculateTimeDifference(
      DateTime currentDate, CustomTimerController controller, CronoData value) {
    _hours = value.cronoNow[0];
    _minutes = value.cronoNow[1];
    _seconds = value.cronoNow[2];

    _isCronoInit = value.cronoInit;

    Duration oldDateTime = Duration(
      hours: int.parse(_hours),
      minutes: int.parse(_minutes),
      seconds: int.parse(_seconds),
    );

    //DateTime now = DateTime.now();
    Duration currentDateTime = Duration(
      hours: currentDate.hour,
      minutes: currentDate.minute,
      seconds: currentDate.second,
    );

    Duration diferencia = currentDateTime - oldDateTime;
    developer.log(
        'diferencia: ${diferencia.inHours} - ${diferencia.inMinutes % 60} - ${diferencia.inSeconds % 60}',
        name: 'my.app.developer');
    developer.log(
        'oldDateTime: ${oldDateTime.inHours} - ${oldDateTime.inMinutes % 60} - ${oldDateTime.inSeconds % 60}',
        name: 'my.app.developer');

    developer.log(
        'currentDateTime: ${currentDateTime.inHours} - ${currentDateTime.inMinutes % 60} - ${currentDateTime.inSeconds % 60}',
        name: 'my.app.developer');

    controller.reset();
    controller.add(
      Duration(
        hours: diferencia.inHours,
        minutes: diferencia.inMinutes % 60,
        seconds: diferencia.inSeconds % 60,
      ),
    );
    controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<CronoData> getCronoData() async {
    final prefs = await SharedPreferences.getInstance();

    bool cronoInit = prefs.getBool('CronoInit') ?? false;
    List<String> cronoNow = prefs.getStringList('CronoNow') ?? [];
    int clienteSucursalId = prefs.getInt('SucursalId') ?? -1;
    String cronoInitDate = prefs.getString('CronoInitDate') ?? "";

    return CronoData(
        cronoInit: cronoInit,
        cronoNow: cronoNow,
        clienteSucursalId: clienteSucursalId,
        cronoInitDate: cronoInitDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.red[500],
          child: const Text(
            'TIEMPO DE VISITA',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  startCronometer(widget.clienteRutaModel);
                },
                child: const Icon(
                  Icons.timer_outlined,
                  color: Colors.green,
                  size: 30,
                ),
              ),
/*               const Text(
                '17:00:00',
                style: TextStyle(fontSize: 14),
              ),
              const Text(
                '00:22:20',
                style: TextStyle(fontSize: 14),
              ), */

              CustomTimer(
                  controller: _controller,
                  builder: (state, remaining) {
                    // developer.log("${remaining.hours}:${remaining.minutes}:${remaining.seconds}:${remaining.milliseconds}", name: 'my.app.developer');
                    // Build the widget you want!
                    return Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$_hours:$_minutes:$_seconds",
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.125,
                        ),
                        Text(
                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }

  void startCronometer(ClienteRutaModel clienteRutaModel) async {
    if (_isCronoInit == false) {
      final now = DateTime.now();
      developer.log(now.toString(), name: 'my.app.developer');
      String dateInitFormatted = "";
      final hourNow = validateDateTime(now.hour);
      final minuteNow = validateDateTime(now.minute);
      final secondNow = validateDateTime(now.second);

      setState(() {
        _hours = hourNow;
        _minutes = minuteNow;
        _seconds = secondNow;
        dateInitFormatted = formatDate(now);
        widget.onSelect(dateInitFormatted);
      });

      final prefs = SharedPreferences.getInstance();

      final cronoInitDateFuture = prefs.then((prefs) => prefs.setString(
            'CronoInitDate',
            dateInitFormatted,
          ));

      final cronoInitFuture =
          prefs.then((prefs) => prefs.setBool('CronoInit', true));

      final cronoNowFuture = prefs.then((prefs) =>
          prefs.setStringList('CronoNow', [hourNow, minuteNow, secondNow]));

      final clienteSucursalIdFuture = prefs.then(
          (prefs) => prefs.setInt('SucursalId', clienteRutaModel.sucursalId!));

      final results = await Future.wait([
        cronoInitFuture,
        cronoNowFuture,
        clienteSucursalIdFuture,
        cronoInitDateFuture
      ]);

      final stateCronoInit = results[0];
      final stateCronoNow = results[1];
      final stateClienteSucursalId = results[2];
      final stateCronoInitDateFuture = results[3];

      if (stateCronoInit &&
          stateCronoNow &&
          stateClienteSucursalId &&
          stateCronoInitDateFuture) {
        developer.log(
            'start button: ${now.toString()} $stateCronoInit - $stateCronoNow',
            name: 'my.app.developer');
        _controller.start();
      }
    }
  }

  String formatDate(DateTime dateTime) {
    // Utilizar el formato deseado
    final formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
    return formatter.format(dateTime);
  }

  String validateDateTime(int number) {
    return number < 10 ? "0$number" : "$number";
  }
}

class MotivoNoCompra extends StatefulWidget {
  final ClienteRutaModel clienteRutaModel;
  final void Function(int valueIdNoCompra) onSelect;

  const MotivoNoCompra({
    super.key,
    required this.clienteRutaModel,
    required this.onSelect,
  });

  @override
  State<MotivoNoCompra> createState() => _MotivoNoCompraState();
}

class _MotivoNoCompraState extends State<MotivoNoCompra> {
  bool? isChecked = false;
  final HttpServices httpServices = HttpServices();
  int idMotivoNoCompra = -1;
  String nombreMotivoNoCompra = "---";
  int _currentSucursalId = -1;

  @override
  void initState() {
    super.initState();
    getMotivoNoCompra().then((value) {
      _currentSucursalId = widget.clienteRutaModel.sucursalId!;

      if (value.idMotivoNoCompra != -1 &&
          value.nombreMotivoNoCompra != "---" &&
          _currentSucursalId == value.sucursalIdNoCompra) {
        developer.log("init Motivo No Compra: ${value.idMotivoNoCompra}",
            name: 'my.app.developer');
        setState(() {
          isChecked = true;
          idMotivoNoCompra = value.idMotivoNoCompra;
          nombreMotivoNoCompra = value.nombreMotivoNoCompra;
          widget.onSelect(idMotivoNoCompra);
        });
      }
    });
  }

  Future<MotivoNoCompraData> getMotivoNoCompra() async {
    final prefs = await SharedPreferences.getInstance();

    int idMotivoNoCompra = prefs.getInt('IdMotivoNoCompra') ?? -1;
    String nombreMotivoNoCompra =
        prefs.getString('NombreMotivoNoCompra') ?? "---";
    int sucursalId = prefs.getInt('SucursalIdNoCompra') ?? -1;

    return MotivoNoCompraData(
      idMotivoNoCompra: idMotivoNoCompra,
      nombreMotivoNoCompra: nombreMotivoNoCompra,
      sucursalIdNoCompra: sucursalId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: const Color(0xFF1976D2),
          child: const Text(
            'MOTIVO DE NO COMPRA',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CheckboxListTile(
          title: Text(idMotivoNoCompra == -1 ? "---" : nombreMotivoNoCompra),
          value: isChecked,
          controlAffinity: ListTileControlAffinity.leading,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {
            if (value == true) {
              showDialogMotivoNoCompra(
                context,
                (idItemSelected, nombreItemSelected) => setState(() {
                  idMotivoNoCompra = idItemSelected;
                  nombreMotivoNoCompra = nombreItemSelected;
                  isChecked = value;
                  saveMotivoNoCompra(widget.clienteRutaModel, idMotivoNoCompra,
                      nombreMotivoNoCompra);
                  widget.onSelect(idItemSelected);
                }),
              );
            } else {
              setState(() {
                isChecked = value;
                idMotivoNoCompra = -1;
                nombreMotivoNoCompra = "---";
                widget.onSelect(-1);
                developer.log('onChanged - $value', name: 'my.app.developer');
              });
            }
          },
          fillColor: MaterialStateProperty.resolveWith(
            (states) {
              if (isChecked == true) {
                return const Color(0xFF1976D2);
              } else {
                return Colors.transparent;
              }
            },
          ),
        )
      ],
    );
  }

  Future<dynamic> showDialogMotivoNoCompra(
      BuildContext context, Function(int, String) selectedItem) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Prevent backing out of Button "BACK".
            return Future.value(false);
          },
          //canPop: false,
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: Container(
              color: const Color(0xFF1976D2),
              child: const Text(
                'MOTIVO DE NO COMPRA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            content: futureBuilderMotivoNoCompra(selectedItem),
            actionsPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          ),
        );
      },
    );
  }

  FutureBuilder<List<MotivoNoCompraModel>> futureBuilderMotivoNoCompra(
      Function(int, String) selectedItem) {
    return FutureBuilder(
      future: httpServices.listarMotivoNoCompra(),
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
                MotivoNoCompraModel item = snapshot.data![index];
                return ListTile(
                  title: Text(item.nombre!),
                  trailing: const Icon(Icons.radio_button_off_outlined),
                  onTap: () {
                    selectedItem(item.motivoNoCompraId!, item.nombre!);
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

  void saveMotivoNoCompra(ClienteRutaModel clienteRutaModel,
      int idMotivoNoCompra, String nombreMotivoNoCompra) async {
    final prefs = SharedPreferences.getInstance();

    final idMotivoNoCompraFuture = prefs
        .then((prefs) => prefs.setInt('IdMotivoNoCompra', idMotivoNoCompra));

    final nombreMotivoNoCompraFuture = prefs.then((prefs) =>
        prefs.setString('NombreMotivoNoCompra', nombreMotivoNoCompra));

    final clienteSucursalIdFuture = prefs.then((prefs) =>
        prefs.setInt('SucursalIdNoCompra', clienteRutaModel.sucursalId!));

    final results = await Future.wait([
      idMotivoNoCompraFuture,
      nombreMotivoNoCompraFuture,
      clienteSucursalIdFuture
    ]);

    final stateIdMotivoNoCompra = results[0];
    final stateNombreMotivoNoCompraFuture = results[1];
    final stateClienteSucursalId = results[2];

    if (stateIdMotivoNoCompra &&
        stateNombreMotivoNoCompraFuture &&
        stateClienteSucursalId) {
      developer.log("Save MotivoNoCompra - true", name: 'my.app.developer');
      //return;
    } else {
      developer.log("Save MotivoNoCompra - false", name: 'my.app.developer');
      //return;
    }
  }
}

class MotivoVisita extends StatefulWidget {
  final ClienteRutaModel clienteRutaModel;
  final void Function(int valueIdMotivo) onSelect;

  const MotivoVisita({
    super.key,
    required this.clienteRutaModel,
    required this.onSelect,
  });

  @override
  State<MotivoVisita> createState() => _MotivoVisitaState();
}

class _MotivoVisitaState extends State<MotivoVisita> {
  bool? isChecked = false;
  final HttpServices httpServices = HttpServices();
  int idMotivoVisita = -1;
  String nombreMotivoVisita = "---";
  int _currentSucursalId = -1;

  @override
  void initState() {
    super.initState();
    getMotivoVisita().then((value) {
      _currentSucursalId = widget.clienteRutaModel.sucursalId!;

      if (value.idMotivoVisita != -1 &&
          value.nombreMotivoVisita != "---" &&
          _currentSucursalId == value.sucursalIdVisita) {
        developer.log("init Motivo Visita: ${value.idMotivoVisita}",
            name: 'my.app.developer');
        setState(() {
          isChecked = true;
          idMotivoVisita = value.idMotivoVisita;
          nombreMotivoVisita = value.nombreMotivoVisita;
          widget.onSelect(idMotivoVisita);
        });
      }
    });
  }

  Future<MotivoVisitaData> getMotivoVisita() async {
    final prefs = await SharedPreferences.getInstance();

    int idMotivoNoCompra = prefs.getInt('IdMotivoVisita') ?? -1;
    String nombreMotivoNoCompra =
        prefs.getString('NombreMotivoVisita') ?? "---";
    int sucursalId = prefs.getInt('SucursalIdVisita') ?? -1;

    return MotivoVisitaData(
      idMotivoVisita: idMotivoNoCompra,
      nombreMotivoVisita: nombreMotivoNoCompra,
      sucursalIdVisita: sucursalId,
    );
  }

  void saveMotivoVisita(ClienteRutaModel clienteRutaModel, int idMotivoNoCompra,
      String nombreMotivoNoCompra) async {
    final prefs = SharedPreferences.getInstance();

    final idMotivoVisitaFuture =
        prefs.then((prefs) => prefs.setInt('IdMotivoVisita', idMotivoNoCompra));

    final nombreMotivoVisitaFuture = prefs.then(
        (prefs) => prefs.setString('NombreMotivoVisita', nombreMotivoNoCompra));

    final clienteSucursalIdFuture = prefs.then((prefs) =>
        prefs.setInt('SucursalIdVisita', clienteRutaModel.sucursalId!));

    final results = await Future.wait([
      idMotivoVisitaFuture,
      nombreMotivoVisitaFuture,
      clienteSucursalIdFuture
    ]);

    final stateIdMotivoVisita = results[0];
    final stateombreMotivoVisita = results[1];
    final stateClienteSucursalId = results[2];

    if (stateIdMotivoVisita &&
        stateombreMotivoVisita &&
        stateClienteSucursalId) {
      developer.log("Save MotivoVisita - true", name: 'my.app.developer');
      //return;
    } else {
      developer.log("Save MotivoVisita - false", name: 'my.app.developer');
      //return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: const Color(0xFF1976D2),
          child: const Text(
            'MOTIVO DE VISITA',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CheckboxListTile(
          title: Text(idMotivoVisita == -1 ? "---" : nombreMotivoVisita),
          value: isChecked,
          controlAffinity: ListTileControlAffinity.leading,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {
            if (value == true) {
              showDialogMotivoVisita(
                context,
                (idItemSelected, nombreItemSelected) => setState(() {
                  idMotivoVisita = idItemSelected;
                  nombreMotivoVisita = nombreItemSelected;
                  isChecked = value;
                  saveMotivoVisita(widget.clienteRutaModel, idMotivoVisita,
                      nombreMotivoVisita);
                  widget.onSelect(idItemSelected);
                }),
              );
            } else {
              setState(() {
                isChecked = value;
                idMotivoVisita = -1;
                nombreMotivoVisita = "---";
                widget.onSelect(-1);
                developer.log('onChanged - $value', name: 'my.app.developer');
              });
            }
          },
          fillColor: MaterialStateProperty.resolveWith(
            (states) {
              if (isChecked == true) {
                return const Color(0xFF1976D2);
              } else {
                return Colors.transparent;
              }
            },
          ),
        ),
      ],
    );
  }

  Future<dynamic> showDialogMotivoVisita(
      BuildContext context, Function(int, String) selectedItem) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Prevent backing out of Button "BACK".
            return Future.value(false);
          },
          //canPop: false,
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: Container(
              color: const Color(0xFF1976D2),
              child: const Text(
                'MOTIVO DE VISITA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            content: futureBuilderMotivoVisita(selectedItem),
            actionsPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          ),
        );
      },
    );
  }

  FutureBuilder<List<MotivoVisitaModel>> futureBuilderMotivoVisita(
      Function(int, String) selectedItem) {
    return FutureBuilder(
      future: httpServices.listarMotivoVisita(),
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
                MotivoVisitaModel item = snapshot.data![index];
                return ListTile(
                  title: Text(item.nombre!),
                  trailing: const Icon(Icons.radio_button_off_outlined),
                  onTap: () {
                    selectedItem(item.motivoVisitaId!, item.nombre!);
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

class CronoData {
  final bool cronoInit;
  final List<String> cronoNow;
  final int clienteSucursalId;
  final String cronoInitDate;

  CronoData({
    required this.cronoInit,
    required this.cronoNow,
    required this.clienteSucursalId,
    required this.cronoInitDate,
  });
}

class PhotoData {
  final String photoFirstPath;
  final String photoSecondPath;
  final int sucursalIdPhoto;

  PhotoData({
    required this.photoFirstPath,
    required this.photoSecondPath,
    required this.sucursalIdPhoto,
  });
}

class MotivoNoCompraData {
  final int idMotivoNoCompra;
  final String nombreMotivoNoCompra;
  final int sucursalIdNoCompra;

  MotivoNoCompraData({
    required this.idMotivoNoCompra,
    required this.nombreMotivoNoCompra,
    required this.sucursalIdNoCompra,
  });
}

class MotivoVisitaData {
  final int idMotivoVisita;
  final String nombreMotivoVisita;
  final int sucursalIdVisita;

  MotivoVisitaData({
    required this.idMotivoVisita,
    required this.nombreMotivoVisita,
    required this.sucursalIdVisita,
  });
}

class ComentarioData {
  final String comentarioVisita;
  final int sucursalIdComentario;

  ComentarioData({
    required this.comentarioVisita,
    required this.sucursalIdComentario,
  });
}

class PositionData {
  final Position? position;
  final String error;

  PositionData({
    required this.position,
    required this.error,
  });
}
