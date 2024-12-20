class MotivoNoCompraModel {
  int? motivoNoCompraId;
  String? nombre;

  MotivoNoCompraModel({this.motivoNoCompraId, this.nombre});

  MotivoNoCompraModel.fromJson(Map<String, dynamic> json) {
    motivoNoCompraId = json['motivoNoCompraId'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['motivoNoCompraId'] = motivoNoCompraId;
    data['nombre'] = nombre;
    return data;
  }
}
