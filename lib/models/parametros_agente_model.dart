class ParametrosAgenteModel {
  int? distribuidorId;
  String? nombre;
  String? pais;
  bool? usaDescuento;
  bool? obligaFotoVisita;
  bool? seleccionaTipoCredito;
  bool? seleccionaTipoContado;
  bool? verTodosClientes;
  bool? requiereAprobacionPedido;
  bool? usarRuta;
  bool? verProgamadoPlanificado;
  bool? precioConIVA;
  bool? editaPrecio;
  bool? soloChannelMap;
  bool? preciosEscala;
  bool? validaStock;
  bool? ventasPerdidas;
  bool? verFidelizadoRuta;
  bool? verPrecioConIVAenApp;
  bool? calculaEscalaGlobal;
  bool? precioconFormaPago;
  bool? precioconTipoPago;
  bool? visitaLlamada;

  ParametrosAgenteModel(
      {this.distribuidorId,
      this.nombre,
      this.pais,
      this.usaDescuento,
      this.obligaFotoVisita,
      this.seleccionaTipoCredito,
      this.seleccionaTipoContado,
      this.verTodosClientes,
      this.requiereAprobacionPedido,
      this.usarRuta,
      this.verProgamadoPlanificado,
      this.precioConIVA,
      this.editaPrecio,
      this.soloChannelMap,
      this.preciosEscala,
      this.validaStock,
      this.ventasPerdidas,
      this.verFidelizadoRuta,
      this.verPrecioConIVAenApp,
      this.calculaEscalaGlobal,
      this.precioconFormaPago,
      this.precioconTipoPago,
      this.visitaLlamada});

  ParametrosAgenteModel.fromJson(Map<String, dynamic> json) {
    distribuidorId = json['distribuidorId'];
    nombre = json['nombre'];
    pais = json['pais'];
    usaDescuento = json['usaDescuento'];
    obligaFotoVisita = json['obligaFotoVisita'];
    seleccionaTipoCredito = json['seleccionaTipoCredito'];
    seleccionaTipoContado = json['seleccionaTipoContado'];
    verTodosClientes = json['verTodosClientes'];
    requiereAprobacionPedido = json['requiereAprobacionPedido'];
    usarRuta = json['usarRuta'];
    verProgamadoPlanificado = json['verProgamadoPlanificado'];
    precioConIVA = json['precioConIVA'];
    editaPrecio = json['editaPrecio'];
    soloChannelMap = json['soloChannelMap'];
    preciosEscala = json['preciosEscala'];
    validaStock = json['validaStock'];
    ventasPerdidas = json['ventasPerdidas'];
    verFidelizadoRuta = json['verFidelizadoRuta'];
    verPrecioConIVAenApp = json['verPrecioConIVAenApp'];
    calculaEscalaGlobal = json['calculaEscalaGlobal'];
    precioconFormaPago = json['precioconFormaPago'];
    precioconTipoPago = json['precioconTipoPago'];
    visitaLlamada = json['visitaLlamada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distribuidorId'] = distribuidorId;
    data['nombre'] = nombre;
    data['pais'] = pais;
    data['usaDescuento'] = usaDescuento;
    data['obligaFotoVisita'] = obligaFotoVisita;
    data['seleccionaTipoCredito'] = seleccionaTipoCredito;
    data['seleccionaTipoContado'] = seleccionaTipoContado;
    data['verTodosClientes'] = verTodosClientes;
    data['requiereAprobacionPedido'] = requiereAprobacionPedido;
    data['usarRuta'] = usarRuta;
    data['verProgamadoPlanificado'] = verProgamadoPlanificado;
    data['precioConIVA'] = precioConIVA;
    data['editaPrecio'] = editaPrecio;
    data['soloChannelMap'] = soloChannelMap;
    data['preciosEscala'] = preciosEscala;
    data['validaStock'] = validaStock;
    data['ventasPerdidas'] = ventasPerdidas;
    data['verFidelizadoRuta'] = verFidelizadoRuta;
    data['verPrecioConIVAenApp'] = verPrecioConIVAenApp;
    data['calculaEscalaGlobal'] = calculaEscalaGlobal;
    data['precioconFormaPago'] = precioconFormaPago;
    data['precioconTipoPago'] = precioconTipoPago;
    data['visitaLlamada'] = visitaLlamada;
    return data;
  }
}