class InventarioModel {
  int? productoId;
  String? codigo;
  String? codigoFabrica;
  String? nombre;
  String? marca;
  String? umd;
  double? stock;
  double? precio;
  double? precioMinimo;
  double? precioSecundario;
  double? precioSecundarioMinimo;
  double? descuento;
  double? descuentoBase;
  bool? otrosAlmacenes;
  String? categoria;
  bool? programa;
  double? ecovalorxunidad;
  int? tipoProductoId;
  String? dTipoProducto;
  bool? seleccionaEscala;
  bool? calculaEscala;
  double? volumen;
  int? equivale;
  List<DetalleStock>? detalleStock;

  InventarioModel(
      {this.productoId,
      this.codigo,
      this.codigoFabrica,
      this.nombre,
      this.marca,
      this.umd,
      this.stock,
      this.precio,
      this.precioMinimo,
      this.precioSecundario,
      this.precioSecundarioMinimo,
      this.descuento,
      this.descuentoBase,
      this.otrosAlmacenes,
      this.categoria,
      this.programa,
      this.ecovalorxunidad,
      this.tipoProductoId,
      this.dTipoProducto,
      this.seleccionaEscala,
      this.calculaEscala,
      this.volumen,
      this.equivale,
      this.detalleStock});

  InventarioModel.fromJson(Map<String, dynamic> json) {
    productoId = json['productoId'];
    codigo = json['codigo'];
    codigoFabrica = json['codigoFabrica'];
    nombre = json['nombre'];
    marca = json['marca'];
    umd = json['umd'];
    stock = json['stock'].toDouble();
    precio = json['precio'].toDouble();
    precioMinimo = json['precioMinimo'].toDouble();
    precioSecundario = json['precioSecundario'].toDouble();
    precioSecundarioMinimo = json['precioSecundarioMinimo'].toDouble();
    descuento = json['descuento'].toDouble();
    descuentoBase = json['descuentoBase'].toDouble();
    otrosAlmacenes = json['otrosAlmacenes'];
    categoria = json['categoria'];
    programa = json['programa'];
    ecovalorxunidad = json['ecovalorxunidad'].toDouble();
    tipoProductoId = json['tipoProductoId'];
    dTipoProducto = json['dTipoProducto'];
    seleccionaEscala = json['seleccionaEscala'];
    calculaEscala = json['calculaEscala'];
    volumen = json['volumen'].toDouble();
    equivale = json['equivale'];
    if (json['detalleStock'] != null) {
      detalleStock = <DetalleStock>[];
      json['detalleStock'].forEach((v) {
        detalleStock!.add(DetalleStock.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productoId'] = productoId;
    data['codigo'] = codigo;
    data['codigoFabrica'] = codigoFabrica;
    data['nombre'] = nombre;
    data['marca'] = marca;
    data['umd'] = umd;
    data['stock'] = stock;
    data['precio'] = precio;
    data['precioMinimo'] = precioMinimo;
    data['precioSecundario'] = precioSecundario;
    data['precioSecundarioMinimo'] = precioSecundarioMinimo;
    data['descuento'] = descuento;
    data['descuentoBase'] = descuentoBase;
    data['otrosAlmacenes'] = otrosAlmacenes;
    data['categoria'] = categoria;
    data['programa'] = programa;
    data['ecovalorxunidad'] = ecovalorxunidad;
    data['tipoProductoId'] = tipoProductoId;
    data['dTipoProducto'] = dTipoProducto;
    data['seleccionaEscala'] = seleccionaEscala;
    data['calculaEscala'] = calculaEscala;
    data['volumen'] = volumen;
    data['equivale'] = equivale;
    if (detalleStock != null) {
      data['detalleStock'] = detalleStock!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetalleStock {
  int? productoId;
  int? sucursalId;
  String? codigoAlmacen;
  double? stock;

  DetalleStock(
      {this.productoId, this.sucursalId, this.codigoAlmacen, this.stock});

  DetalleStock.fromJson(Map<String, dynamic> json) {
    productoId = json['productoId'];
    sucursalId = json['sucursalId'];
    codigoAlmacen = json['codigoAlmacen'];
    stock = json['stock'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productoId'] = productoId;
    data['sucursalId'] = sucursalId;
    data['codigoAlmacen'] = codigoAlmacen;
    data['stock'] = stock;
    return data;
  }
}
