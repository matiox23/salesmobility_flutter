class BusquedaUbigeoModel {
  int? ubigeoId;
  String? codigo;
  String? nombre;

  BusquedaUbigeoModel({this.ubigeoId, this.codigo, this.nombre});

  BusquedaUbigeoModel.fromJson(Map<String, dynamic> json) {
    ubigeoId = json['ubigeoId'];
    codigo = json['codigo'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ubigeoId'] = ubigeoId;
    data['codigo'] = codigo;
    data['nombre'] = nombre;
    return data;
  }
}
