class TesoreriaPersonalMovimiento {
  const TesoreriaPersonalMovimiento({
    required this.fecha,
    required this.concepto,
    required this.monto,
  });

  final DateTime fecha;
  final String concepto;
  final int monto;
}

class TesoreriaGeneralMovimiento {
  const TesoreriaGeneralMovimiento({
    required this.fecha,
    required this.concepto,
    required this.montoEfectivo,
    required this.montoVirtual,
    required this.detalle,
  });

  final DateTime fecha;
  final String concepto;
  final int? montoEfectivo;
  final int? montoVirtual;
  final String detalle;
}
