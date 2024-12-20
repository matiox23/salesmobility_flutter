class PedidoClienteTabModel {
  int? pedidoId;
  String? codigo;
  String? codigoOrigen;
  String? ordenCompra;
  String? fecha;
  String? dCliente;
  String? sucursal;
  double? totalDescuentos;
  double? valorVenta;
  double? total;
  bool? credito;
  int? clienteId;
  int? clienteSucursalId;
  int? ventaId;
  bool? enviado;
  bool? cotizacion;
  String? aps;
  String? ads;

  PedidoClienteTabModel(
      {this.pedidoId,
      this.codigo,
      this.codigoOrigen,
      this.ordenCompra,
      this.fecha,
      this.dCliente,
      this.sucursal,
      this.totalDescuentos,
      this.valorVenta,
      this.total,
      this.credito,
      this.clienteId,
      this.clienteSucursalId,
      this.ventaId,
      this.enviado,
      this.cotizacion,
      this.aps,
      this.ads});

  PedidoClienteTabModel.fromJson(Map<String, dynamic> json) {
    pedidoId = json['pedidoId'];
    codigo = json['codigo'];
    codigoOrigen = json['codigoOrigen'];
    ordenCompra = json['ordenCompra'];
    fecha = json['fecha'];
    dCliente = json['dCliente'];
    sucursal = json['sucursal'];
    totalDescuentos = json['totalDescuentos'];
    valorVenta = json['valorVenta'];
    total = json['total'];
    credito = json['credito'];
    clienteId = json['clienteId'];
    clienteSucursalId = json['clienteSucursalId'];
    ventaId = json['ventaId'];
    enviado = json['enviado'];
    cotizacion = json['cotizacion'];
    aps = json['aps'];
    ads = json['ads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pedidoId'] = pedidoId;
    data['codigo'] = codigo;
    data['codigoOrigen'] = codigoOrigen;
    data['ordenCompra'] = ordenCompra;
    data['fecha'] = fecha;
    data['dCliente'] = dCliente;
    data['sucursal'] = sucursal;
    data['totalDescuentos'] = totalDescuentos;
    data['valorVenta'] = valorVenta;
    data['total'] = total;
    data['credito'] = credito;
    data['clienteId'] = clienteId;
    data['clienteSucursalId'] = clienteSucursalId;
    data['ventaId'] = ventaId;
    data['enviado'] = enviado;
    data['cotizacion'] = cotizacion;
    data['aps'] = aps;
    data['ads'] = ads;
    return data;
  }
}
