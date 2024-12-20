class ProductoModel {
  int? productoId;
  int? lobId;
  String? dLinea;
  int? usoAceiteId;
  String? dUsoAceite;
  int? tipoAceiteId;
  String? dTipoAceite;
  int? marcaId;
  String? dMarca;
  String? nombre;
  String? viscosidad;
  String? certificado;
  bool? activo;
  String? dCanal;
  int? lineaId;
  int? canalId;

  ProductoModel(
      {this.productoId,
      this.lobId,
      this.dLinea,
      this.usoAceiteId,
      this.dUsoAceite,
      this.tipoAceiteId,
      this.dTipoAceite,
      this.marcaId,
      this.dMarca,
      this.nombre,
      this.viscosidad,
      this.certificado,
      this.activo,
      this.dCanal,
      this.lineaId,
      this.canalId});

  ProductoModel.fromJson(Map<String, dynamic> json) {
    productoId = json['productoId'];
    lobId = json['lobId'];
    dLinea = json['dLinea'];
    usoAceiteId = json['usoAceiteId'];
    dUsoAceite = json['dUsoAceite'];
    tipoAceiteId = json['tipoAceiteId'];
    dTipoAceite = json['dTipoAceite'];
    marcaId = json['marcaId'];
    dMarca = json['dMarca'];
    nombre = json['nombre'];
    viscosidad = json['viscosidad'];
    certificado = json['certificado'];
    activo = json['activo'];
    dCanal = json['dCanal'];
    lineaId = json['lineaId'];
    canalId = json['canalId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productoId'] = productoId;
    data['lobId'] = lobId;
    data['dLinea'] = dLinea;
    data['usoAceiteId'] = usoAceiteId;
    data['dUsoAceite'] = dUsoAceite;
    data['tipoAceiteId'] = tipoAceiteId;
    data['dTipoAceite'] = dTipoAceite;
    data['marcaId'] = marcaId;
    data['dMarca'] = dMarca;
    data['nombre'] = nombre;
    data['viscosidad'] = viscosidad;
    data['certificado'] = certificado;
    data['activo'] = activo;
    data['dCanal'] = dCanal;
    data['lineaId'] = lineaId;
    data['canalId'] = canalId;
    return data;
  }
}
