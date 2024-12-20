class MarcaModel {
  int? marcaId;
  String? dMarca;
  String? uriImagen;

  MarcaModel({this.marcaId, this.dMarca, this.uriImagen});

  MarcaModel.fromJson(Map<String, dynamic> json) {
    marcaId = json['marcaId'];
    dMarca = json['dMarca'];
    uriImagen = json['uriImagen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['marcaId'] = marcaId;
    data['dMarca'] = dMarca;
    data['uriImagen'] = uriImagen;
    return data;
  }
}
