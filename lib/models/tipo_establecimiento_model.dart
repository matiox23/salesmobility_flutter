class TipoEstablecimientoModel {
  int? tipoEstablecimientoId;
  String? dTipoEstablecimiento;

  TipoEstablecimientoModel(
      {this.tipoEstablecimientoId, this.dTipoEstablecimiento});

  TipoEstablecimientoModel.fromJson(Map<String, dynamic> json) {
    tipoEstablecimientoId = json['tipoEstablecimientoId'];
    dTipoEstablecimiento = json['dTipoEstablecimiento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tipoEstablecimientoId'] = tipoEstablecimientoId;
    data['dTipoEstablecimiento'] = dTipoEstablecimiento;
    return data;
  }
}
