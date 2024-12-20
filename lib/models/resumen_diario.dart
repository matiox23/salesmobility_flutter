class ResumenDiarioModel {
  int? orden;
  String? titulo;
  String? dato;
  String? footer;
  String? imagen;
  int? vendedorId;

  ResumenDiarioModel(
      {this.orden,
      this.titulo,
      this.dato,
      this.footer,
      this.imagen,
      this.vendedorId});

  ResumenDiarioModel.fromJson(Map<String, dynamic> json) {
    orden = json['Orden'];
    titulo = json['Titulo'];
    dato = json['Dato'];
    footer = json['Footer'];
    imagen = json['Imagen'];
    vendedorId = json['VendedorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Orden'] = orden;
    data['Titulo'] = titulo;
    data['Dato'] = dato;
    data['Footer'] = footer;
    data['Imagen'] = imagen;
    data['VendedorId'] = vendedorId;
    return data;
  }
}
