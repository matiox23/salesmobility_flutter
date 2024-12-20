class MotivoVisitaModel {
  int? motivoVisitaId;
  String? nombre;

  MotivoVisitaModel({this.motivoVisitaId, this.nombre});

  MotivoVisitaModel.fromJson(Map<String, dynamic> json) {
    motivoVisitaId = json['motivoVisitaId'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['motivoVisitaId'] = motivoVisitaId;
    data['nombre'] = nombre;
    return data;
  }
}
