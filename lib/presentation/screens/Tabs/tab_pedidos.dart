import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/inventario_model.dart';
import 'package:flutter_app_users/models/pedido_cliente_tab_model.dart';
import 'package:flutter_app_users/services/services.dart';
import 'dart:developer' as developer;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
final today = DateUtils.dateOnly(DateTime.now());

class TabPedidos extends StatefulWidget {
  const TabPedidos({super.key});

  @override
  State<TabPedidos> createState() => _TabPedidosState();
}

class _TabPedidosState extends State<TabPedidos> {
  //final HttpServices httpServices = HttpServices();
  final DioServices dioServices = DioServices();

  TextEditingController tcBuscarProducto = TextEditingController(text: "");
  bool buscar = false;
  final List<DateTime?> _dialogCalendarPickerValue = [
    DateTime(today.year, today.month, today.day),
  ];
  late CalendarDatePicker2WithActionButtonsConfig config;

  @override
  void initState() {
    dioServices.addInterceptor();

    // tcBuscarProducto.text = '${today.year}-${today.month}-${today.day}';
    tcBuscarProducto.text = DateFormat('yyyy-MM-dd').format(today);
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabels: const ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(1998, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.zero,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
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
                      'Fecha: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: AbsorbPointer(
                        absorbing: true,
                        child: TextFormField(
                          controller: tcBuscarProducto,
                          //initialValue: '${today.year}-${today.month}-${today.day}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Buscar',
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      onTap: () async {
                        final values = await showCalendarDatePicker2Dialog(
                          context: context,
                          config: config,
                          dialogSize: const Size(325, 400),
                          borderRadius: BorderRadius.circular(15),
                          value: _dialogCalendarPickerValue,
                          dialogBackgroundColor: Colors.white,
                        );
                        if (values != null) {
                          /* developer.log(
                              _getValueText(
                                config.calendarType,
                                values,
                              ).toList().toString(),
                              name: 'my.app.developer'); */

                          List<String> resultado = _getValueText(
                            config.calendarType,
                            values,
                          );

                          if (resultado[0] == resultado[1] ||
                              resultado[1] == 'null') {
                            tcBuscarProducto.text =
                                resultado[0] == 'null' ? '' : resultado[0];

                            developer.log('1 - ${tcBuscarProducto.text}',
                                name: 'my.app.developer');
                          } else {
                            tcBuscarProducto.text = {
                              resultado[0] == 'null' ? '' : resultado[0],
                              resultado[1] == 'null' ? '' : resultado[1]
                            }.join(' <> ');

                            developer.log('2 - ${tcBuscarProducto.text}',
                                name: 'my.app.developer');
                          }

                          // setState(() {
                          //   _dialogCalendarPickerValue = values;
                          // });
                        }
                      },
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
                  'Pedidos',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: buscar == false
                  ? const Center(child: Text(""))
                  : tcBuscarProducto.text.length >= 3
                      ? futureBuilderTabPedidos(tcBuscarProducto.text)
                      : const Center(child: Text("")),
            )
          ],
        ));
  }

  List<String> _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();

    if (datePickerType == CalendarDatePicker2Type.single) {
      return [
        values.isNotEmpty
            ? values[0].toString().replaceAll('00:00:00.000', '')
            : 'null'
      ];
    } else if (datePickerType == CalendarDatePicker2Type.multi) {
      return values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .toList();
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        return [startDate.trim(), endDate.trim()];
      } else {
        return [];
      }
    }

    return [];
  }

  FutureBuilder<List<PedidoClienteTabModel>> futureBuilderTabPedidos(
      String fechas) {
    String delimitador = "<>";

    String fechaInicial = "";
    String fechaFinal = "";

    // Verificar si la cadena contiene el delimitador
    if (fechas.contains(delimitador)) {
      // Dividir la cadena usando el delimitador
      List<String> partes = fechas.split(delimitador);

      fechaInicial = partes[0];
      fechaFinal = partes[1];
      developer.log('Las fechas :  $fechaInicial - $fechaFinal',
          name: 'my.app.developer');
    } else {
      fechaInicial = fechaFinal = fechas;
      developer.log('La fecha :  $fechaInicial - $fechaFinal',
          name: 'my.app.developer');
    }

    return FutureBuilder(
      future: dioServices.listarTabPedidosClientes(fechaInicial, fechaFinal),
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
                final pedidoItem = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'images/ic_fecha.svg',
                                  width: 16,
                                  height: 16,
                                ),
                                Text(
                                  pedidoItem.fecha!,
                                  style: const TextStyle(
                                    fontSize: 8,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                  height: 0,
                                ),
                                const Text(
                                  "COD",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    backgroundColor: Color(0xFF1976D2),
                                  ),
                                ),
                                Text(
                                  pedidoItem.codigo!,
                                  style: const TextStyle(
                                    fontSize: 9,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                  height: 0,
                                ),
                                const Text(
                                  "COD",
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    backgroundColor: Color(0xFF455a64),
                                  ),
                                ),
                                Text(
                                  pedidoItem.codigoOrigen!,
                                  style: const TextStyle(
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              pedidoItem.dCliente!,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: esCotizacion(pedidoItem),
                              ),
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                mostrarApsAds("PP", pedidoItem.aps!),
                                const SizedBox(
                                  width: 6,
                                  height: 0,
                                ),
                                mostrarApsAds("PD", pedidoItem.ads!),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 53,
                                    color: Colors.red[700],
                                    child: const Text(
                                      "S.TOTAL",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        //backgroundColor: Colors.red[700],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    roundToDecimals(pedidoItem.valorVenta!, 2),
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, bottom: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 55,
                                    color: Colors.red[700],
                                    child: const Text(
                                      "DSCTO",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        //backgroundColor: Colors.red[700],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    roundToDecimals(
                                        pedidoItem.totalDescuentos!, 2),
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 55,
                                    color: Colors.red[700],
                                    child: const Text(
                                      "TOTAL",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        //backgroundColor: Colors.red[700],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    roundToDecimals(pedidoItem.total!, 2)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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

  Color esCotizacion(PedidoClienteTabModel pedidoItem) {
    bool esCotizacion = pedidoItem.cotizacion!;

    if (esCotizacion) {
      return const Color(0xFFF09030); // Por defecto
    } else {
      return const Color(0xFF000000);
    }
  }

  Widget mostrarApsAds(String labelText, String value) {
    Color colorDefault = const Color(0xFFAAAAAA);

    if (value.isNotEmpty) {
      switch (value) {
        case "P":
          colorDefault = const Color(0xFFff8800);
          break;
        case "A":
          colorDefault = const Color(0xFF669900);
          break;
        case "R":
          colorDefault = const Color(0xFFCC0000);
          break;
        default:
          colorDefault = const Color(0xFFAAAAAA);
      }
    }

    return Padding(
      padding: EdgeInsets.zero,
      child: CircleAvatar(
        radius: 10,
        backgroundColor: colorDefault,
        foregroundColor: Colors.white,
        child: Text(
          labelText,
          style: const TextStyle(fontSize: 9),
        ),
      ),
    );
  }

  String roundToDecimals(double number, int decimalPlaces) {
    // Convierte el número a una cadena con la cantidad de decimales especificada
    //String result = number.toStringAsFixed(decimalPlaces);

    // Convierte la cadena de nuevo a un double
    //return double.parse(result);
    return number.toStringAsFixed(decimalPlaces);
  }

  List<Widget> agregarStock(InventarioModel productoItem) {
    List<DetalleStock> detalleStock = productoItem.detalleStock!;

    List<Widget> lista = [];

    if (detalleStock.isNotEmpty) {
      for (int i = 0; i < detalleStock.length; i++) {
        double stock = detalleStock[i].stock!;
        String codigoAlmacen = detalleStock[i].codigoAlmacen!;

        lista.add(Text(
          stock.toString(),
          style: const TextStyle(
            backgroundColor: Color(0xFF1976D2),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ));

        lista.add(const SizedBox(
          width: 3,
          height: 0,
        ));

        lista.add(Text(
          codigoAlmacen,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1976D2),
          ),
        ));

        lista.add(const SizedBox(
          width: 8,
          height: 0,
        ));
      }
    } else {
      lista.add(const Text(
        '0.0',
        style: TextStyle(
          backgroundColor: Color(0xFF1976D2),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ));

      lista.add(const SizedBox(
        width: 3,
        height: 0,
      ));

      lista.add(const Text(
        "00",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1976D2),
        ),
      ));
    }
    return lista;
  }
}
