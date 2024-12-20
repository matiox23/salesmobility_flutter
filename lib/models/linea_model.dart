class LineaModel {
  int? lineaId;
  String? dLinea;

  LineaModel(
      {this.lineaId, this.dLinea});

  LineaModel.fromJson(Map<String, dynamic> json) {
    lineaId = json['lineaId'];
    dLinea = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lineaId'] = lineaId;
    data['dLinea'] = dLinea;
    return data;
  }
}