import 'dart:convert';

List<PresentacionModel> presentacionModelFromJson(String str) =>
    List<PresentacionModel>.from(
        json.decode(str).map((x) => PresentacionModel.fromJson(x)));

String presentacionModelToJson(List<PresentacionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PresentacionModel {
  int productoId;
  String dProducto;
  String certificado;
  List<Presentaciones> presentaciones;

  PresentacionModel({
    required this.productoId,
    required this.dProducto,
    required this.certificado,
    required this.presentaciones,
  });

  factory PresentacionModel.fromJson(Map<String, dynamic> json) =>
      PresentacionModel(
        productoId: json["productoId"],
        dProducto: json["dProducto"],
        certificado: json["certificado"],
        presentaciones: List<Presentaciones>.from(
            json["presentaciones"].map((x) => Presentaciones.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productoId": productoId,
        "dProducto": dProducto,
        "certificado": certificado,
        "presentaciones":
            List<dynamic>.from(presentaciones.map((x) => x.toJson())),
      };
}

class Presentaciones {
  int productoId;
  int presentacionId;
  String dPresentacion;
  String detalle;
  double precioCompra;
  double precioVenta;
  double promedioCompra;
  double promedioVenta;

  Presentaciones({
    required this.productoId,
    required this.presentacionId,
    required this.dPresentacion,
    required this.detalle,
    required this.precioCompra,
    required this.precioVenta,
    required this.promedioCompra,
    required this.promedioVenta,
  });

  factory Presentaciones.fromJson(Map<String, dynamic> json) => Presentaciones(
        productoId: json["productoId"],
        presentacionId: json["presentacionId"],
        dPresentacion: json["dPresentacion"],
        detalle: json["detalle"],
        precioCompra: json["precioCompra"]?.toDouble(),
        precioVenta: json["precioVenta"]?.toDouble(),
        promedioCompra: json["promedioCompra"]?.toDouble(),
        promedioVenta: json["promedioVenta"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "productoId": productoId,
        "presentacionId": presentacionId,
        "dPresentacion": dPresentacion,
        "detalle": detalle,
        "precioCompra": precioCompra,
        "precioVenta": precioVenta,
        "promedioCompra": promedioCompra,
        "promedioVenta": promedioVenta,
      };
}
