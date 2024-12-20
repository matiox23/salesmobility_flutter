class RutaGpsModel {
  int? clienteId;
  String? dCliente;
  String? direccion;
  String? latitud;
  String? longitud;
  int? sucursalId;
  int? conVisita;
  int? orden;
  String? duracionVisita;

  RutaGpsModel(
      {this.clienteId,
      this.dCliente,
      this.direccion,
      this.latitud,
      this.longitud,
      this.sucursalId,
      this.conVisita,
      this.orden,
      this.duracionVisita});

  RutaGpsModel.fromJson(Map<String, dynamic> json) {
    clienteId = json['ClienteId'];
    dCliente = json['DCliente'];
    direccion = json['Direccion'];
    latitud = json['Latitud'];
    longitud = json['Longitud'];
    sucursalId = json['SucursalId'];
    conVisita = json['conVisita'];
    orden = json['Orden'];
    duracionVisita = json['DuracionVisita'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClienteId'] = clienteId;
    data['DCliente'] = dCliente;
    data['Direccion'] = direccion;
    data['Latitud'] = latitud;
    data['Longitud'] = longitud;
    data['SucursalId'] = sucursalId;
    data['conVisita'] = conVisita;
    data['Orden'] = orden;
    data['DuracionVisita'] = duracionVisita;
    return data;
  }
}
