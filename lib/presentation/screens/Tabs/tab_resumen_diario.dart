import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/resumen_diario.dart';
import 'package:flutter_app_users/services/services.dart';

class TabResumenDiario extends StatefulWidget {
  const TabResumenDiario({super.key});

  @override
  State<TabResumenDiario> createState() => _TabResumenDiarioState();
}

class _TabResumenDiarioState extends State<TabResumenDiario> {
  //final HttpServices httpServices = HttpServices();
  final DioServices dioServices = DioServices();

  @override
  void initState() {
    dioServices.addInterceptor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return futureBuilderClienteRutaDiaria();
  }

  FutureBuilder<List<ResumenDiarioModel>> futureBuilderClienteRutaDiaria() {
    return FutureBuilder(
      future: dioServices.listarResumenDiario(),
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
                final resumenDiarioItem = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      resumenDiarioItem.imagen! == 'ic_resumen_barras'
                          ? Icons.calendar_today
                          : Icons.bar_chart_outlined,
                      color: const Color(0xFFADADAD),
                      size: 46,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resumenDiarioItem.titulo!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        resumenDiarioItem.dato!,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        resumenDiarioItem.footer!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF455a64),
                        ),
                      )
                    ],
                  ),
                  onTap: () {},
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
