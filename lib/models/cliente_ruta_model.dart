class ClienteRutaModel {
  int? clienteId;
  String? dCliente;
  String? direccion;
  int? ruta;
  int? pedido;
  String? iPT;
  String? estado;
  int? club;
  int? conVisita;
  int? credito;
  double? lineaCredito;
  int? diasCredito;
  int? saldo;
  int? sucursalId;
  int? rutaId;
  String? latitud;
  String? longitud;
  int? channelMap;
  String? telefono;
  String? correo;
  int? prospectoId;
  String? nIT;
  String? codigo;
  int? coberturado;
  int? diasVencido;
  String? ordencliente;
  int? diasFidelidad;
  int? ubigeoId;
  String? departamento;
  String? provincia;
  String? distrito;
  int? orden;
  String? tipo;
  int? clienteSucursalId;
  int? distribuidorId;

  ClienteRutaModel(
      {this.clienteId,
      this.dCliente,
      this.direccion,
      this.ruta,
      this.pedido,
      this.iPT,
      this.estado,
      this.club,
      this.conVisita,
      this.credito,
      this.lineaCredito,
      this.diasCredito,
      this.saldo,
      this.sucursalId,
      this.rutaId,
      this.latitud,
      this.longitud,
      this.channelMap,
      this.telefono,
      this.correo,
      this.prospectoId,
      this.nIT,
      this.codigo,
      this.coberturado,
      this.diasVencido,
      this.ordencliente,
      this.diasFidelidad,
      this.ubigeoId,
      this.departamento,
      this.provincia,
      this.distrito,
      this.orden,
      this.tipo,
      this.clienteSucursalId,
      this.distribuidorId});

  ClienteRutaModel.fromJson(Map<String, dynamic> json) {
    clienteId = json['ClienteId'];
    dCliente = json['DCliente'];
    direccion = json['Direccion'];
    ruta = json['Ruta'] ?? 0;
    pedido = json['Pedido'] ?? 0;
    iPT = json['IPT'] ?? "";
    estado = json['Estado'] ?? "";
    club = json['Club'] ?? 0;
    conVisita = json['ConVisita'] ?? 0;
    credito = json['Credito'] ?? 0;
    lineaCredito = json['LineaCredito'] ?? 0;
    diasCredito = json['DiasCredito'] ?? 0;
    saldo = json['Saldo'] ?? 0;
    sucursalId = json['SucursalId'] ?? 0;
    rutaId = json['RutaId'] ?? 0;
    latitud = json['Latitud'] ?? "";
    longitud = json['Longitud'] ?? "";
    channelMap = json['ChannelMap'] ?? 0;
    telefono = json['Telefono'] ?? "";
    correo = json['Correo'] ?? "";
    prospectoId = json['ProspectoId'] ?? 0;
    nIT = json['NIT'] ?? "";
    codigo = json['Codigo'] ?? "";
    coberturado = json['Coberturado'] ?? 0;
    diasVencido = json['DiasVencido'] ?? 0;
    ordencliente = json['ordencliente'] ?? "";
    diasFidelidad = json['DiasFidelidad'] ?? 0;
    ubigeoId = json['UbigeoId'] ?? 1;
    departamento = json['Departamento'] ?? "";
    provincia = json['Provincia'] ?? "";
    distrito = json['Distrito'] ?? "";
    orden = json['Orden'] ?? 0;
    tipo = json['Tipo'] ?? "";
    clienteSucursalId = json['ClienteSucursalId'] ?? 0;
    distribuidorId = json['DistribuidorId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClienteId'] = clienteId ?? 0;
    data['DCliente'] = dCliente ?? "";
    data['Direccion'] = direccion ?? "";
    data['Ruta'] = ruta ?? 0;
    data['Pedido'] = pedido ?? 0;
    data['IPT'] = iPT ?? "";
    data['Estado'] = estado ?? "";
    data['Club'] = club ?? 0;
    data['ConVisita'] = conVisita ?? 0;
    data['Credito'] = credito ?? 0;
    data['LineaCredito'] = lineaCredito ?? 0;
    data['DiasCredito'] = diasCredito ?? 0;
    data['Saldo'] = saldo ?? 0;
    data['SucursalId'] = sucursalId ?? 0;
    data['RutaId'] = rutaId ?? 0;
    data['Latitud'] = latitud ?? "";
    data['Longitud'] = longitud ?? "";
    data['ChannelMap'] = channelMap ?? 0;
    data['Telefono'] = telefono ?? "";
    data['Correo'] = correo ?? "";
    data['ProspectoId'] = prospectoId ?? 0;
    data['NIT'] = nIT ?? "";
    data['Codigo'] = codigo ?? "";
    data['Coberturado'] = coberturado ?? 0;
    data['DiasVencido'] = diasVencido ?? 0;
    data['ordencliente'] = ordencliente ?? "";
    data['DiasFidelidad'] = diasFidelidad ?? 0;
    data['UbigeoId'] = ubigeoId ?? 1;
    data['Departamento'] = departamento ?? "";
    data['Provincia'] = provincia ?? "";
    data['Distrito'] = distrito ?? "";
    data['Orden'] = orden ?? 0;
    data['Tipo'] = tipo ?? "";
    data['ClienteSucursalId'] = clienteSucursalId ?? 0;
    data['DistribuidorId'] = distribuidorId ?? 0;
    return data;
  }
}
