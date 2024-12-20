import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/inventario_model.dart';
import 'package:flutter_app_users/services/services.dart';

class TabInventario extends StatefulWidget {
  const TabInventario({super.key});

  @override
  State<TabInventario> createState() => _TabInventarioState();
}

class _TabInventarioState extends State<TabInventario> {
  //final HttpServices httpServices = HttpServices();
  TextEditingController tcBuscarProducto = TextEditingController(text: "");
  bool buscar = false;

  final DioServices dioServices = DioServices();

  @override
  void initState() {
    dioServices.addInterceptor();
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
                    'Producto: ',
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
                'Productos',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: buscar == false
                ? const Center(child: Text(""))
                : tcBuscarProducto.text.length >= 3
                    ? futureBuilderInventario(tcBuscarProducto.text)
                    : const Center(child: Text("")),
          )
        ],
      ),
    );
  }

  FutureBuilder<List<InventarioModel>> futureBuilderInventario(
      String nombreProducto) {
    return FutureBuilder(
      future: dioServices.listarInventariosProductos(nombreProducto),
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
                final productoItem = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  productoItem.codigo!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                  height: 0,
                                ),
                                Text(
                                  productoItem.codigoFabrica!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              productoItem.marca!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          productoItem.nombre!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: agregarStock(productoItem),
                              /* children: [
                                Text(
                                  '00',
                                  style: TextStyle(
                                    backgroundColor: Color(0xFF1976D2),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                  height: 0,
                                ),
                                Text(
                                  '00',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1976D2),
                                  ),
                                ),
                              ] */
                            ),
                            Text(
                              productoItem.precio!.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFfc1404),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
