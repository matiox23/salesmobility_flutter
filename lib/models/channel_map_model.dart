class ChannelMapModel {
  int? marcaId;
  String? nombre;
  String? imagen;
  int? pvl;
  int? cvl;
  int? mco;
  int? ind;
  int? tomaChannelMapId;
  String? ultimaOla;
  String? ultimaFecha;
  String? uriFoto;

  ChannelMapModel(
      {this.marcaId,
      this.nombre,
      this.imagen,
      this.pvl,
      this.cvl,
      this.mco,
      this.ind,
      this.tomaChannelMapId,
      this.ultimaOla,
      this.ultimaFecha,
      this.uriFoto});

  ChannelMapModel.fromJson(Map<String, dynamic> json) {
    marcaId = json['marcaId'];
    nombre = json['nombre'];
    imagen = json['imagen'];
    pvl = json['pvl'].toInt();
    cvl = json['cvl'].toInt();
    mco = json['mco'].toInt();
    ind = json['ind'].toInt();
    tomaChannelMapId = json['tomaChannelMapId'];
    ultimaOla = json['ultimaOla'];
    ultimaFecha = json['ultimaFecha'];
    uriFoto = json['uriFoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['marcaId'] = marcaId;
    data['nombre'] = nombre;
    data['imagen'] = imagen;
    data['pvl'] = pvl;
    data['cvl'] = cvl;
    data['mco'] = mco;
    data['ind'] = ind;
    data['tomaChannelMapId'] = tomaChannelMapId;
    data['ultimaOla'] = ultimaOla;
    data['ultimaFecha'] = ultimaFecha;
    data['uriFoto'] = uriFoto;
    return data;
  }
}
