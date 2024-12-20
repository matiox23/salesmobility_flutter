// Extiende la clase WebResourceError para proporcionar parámetros específicos de iOS.
import 'package:webview_flutter/webview_flutter.dart';

class IOSWebResourceError extends WebResourceError {
  // Constructor privado que inicializa la clase base con los datos del error original
  // y agrega el campo específico de iOS 'domain'.
  IOSWebResourceError._(WebResourceError error, {required this.domain})
      : super(
          errorCode: error.errorCode,
          description: error.description,
          errorType: error.errorType,
        );

  // Constructor de fábrica que crea una instancia de IOSWebResourceError a partir
  // de un objeto WebResourceError y un dominio específico de iOS.
  factory IOSWebResourceError.fromWebResourceError(
    WebResourceError error, {
    required String? domain,
  }) {
    return IOSWebResourceError._(error, domain: domain);
  }

  // Campo adicional específico de iOS.
  final String? domain;
}
