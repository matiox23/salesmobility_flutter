import 'package:flutter_app_users/blocs/blocs.dart';

class ClienteProspectoScreen extends StatefulWidget {
  static const String routeName = 'cliente_prospecto_screen';
  const ClienteProspectoScreen({super.key});

  @override
  State<ClienteProspectoScreen> createState() => _ClienteProspectoScreenState();
}

class _ClienteProspectoScreenState extends State<ClienteProspectoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cliente Prospecto'),
      ),
      body: const Center(
        child: Text('Contenido de Cliente / Prospecto'),
      ),
    );
  }
}
