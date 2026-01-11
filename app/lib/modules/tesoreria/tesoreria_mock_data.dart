import 'tesoreria_models.dart';

class TesoreriaMockData {
  static final Map<String, List<TesoreriaPersonalMovimiento>> personalPorLegajo =
      {
    '95.278': [
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2024, 6, 3),
        concepto: 'Pago capita',
        monto: 20000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2024, 6, 23),
        concepto: 'Deuda Solsticio',
        monto: -15000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2024, 7, 1),
        concepto: 'Capita julio',
        monto: -15300,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2024, 7, 10),
        concepto: 'Pago capita',
        monto: 30000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2024, 11, 21),
        concepto: 'Pago capita y cena',
        monto: 90000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 1, 1),
        concepto: 'Capita enero',
        monto: -20000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 1, 1),
        concepto: 'Pago capita',
        monto: 17749,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 3, 6),
        concepto: 'Pago capita',
        monto: 25000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 7, 3),
        concepto: 'Capita julio',
        monto: -25000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 12, 4),
        concepto: 'Pago capita',
        monto: 56000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2026, 1, 3),
        concepto: 'Capita',
        monto: -28000,
      ),
    ],
    '92.425': [
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2024, 9, 24),
        concepto: 'Pago capita',
        monto: 35000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2024, 10, 1),
        concepto: 'Capita octubre',
        monto: -20000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 4, 23),
        concepto: 'Pago capita',
        monto: 23000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 10, 3),
        concepto: 'Pago capita',
        monto: 50000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 12, 9),
        concepto: 'Tarjeta cena x 2',
        monto: -70000,
      ),
    ],
    '108.629': [
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 2, 2),
        concepto: 'Capita marzo',
        monto: -24000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 3, 6),
        concepto: 'Pago capita',
        monto: 25000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 8, 1),
        concepto: 'Capita agosto',
        monto: -25000,
      ),
      TesoreriaPersonalMovimiento(
        fecha: DateTime(2025, 9, 1),
        concepto: 'Capita septiembre',
        monto: -25000,
      ),
    ],
  };

  static final List<TesoreriaGeneralMovimiento> general = [
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 11, 1),
      concepto: 'Capita',
      montoEfectivo: 15000,
      montoVirtual: null,
      detalle: 'Goyechea 15k',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 11, 2),
      concepto: 'Capitas y devolucion de expensas',
      montoEfectivo: 110000,
      montoVirtual: null,
      detalle: 'Hart 15k, Valdez Ramos 15k, Veliz 45k',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 11, 3),
      concepto: 'Pago supremo consejo',
      montoEfectivo: -100000,
      montoVirtual: null,
      detalle: 'Capitas',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 11, 10),
      concepto: 'Capita efectivo',
      montoEfectivo: 100000,
      montoVirtual: null,
      detalle: 'Altamiranda 20k, Hernandez 30k, Pardo 15k',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 11, 12),
      concepto: 'Expensas casa masonica',
      montoEfectivo: -100000,
      montoVirtual: null,
      detalle: 'Pago expensas 190k',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 11, 20),
      concepto: 'Pago exaltacion G 18 al SC',
      montoEfectivo: -660000,
      montoVirtual: null,
      detalle: 'VVHH Cobos, Pardo Moyano, Hernandez',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 12, 2),
      concepto: 'Capitas',
      montoEfectivo: null,
      montoVirtual: null,
      detalle: 'Goyechea 15k, Falco 15k, Hart 15k',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 12, 12),
      concepto: 'Capita',
      montoEfectivo: 60000,
      montoVirtual: null,
      detalle: 'Alderete 60k efectivo',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2025, 12, 17),
      concepto: 'De efectivo a virtual',
      montoEfectivo: -60000,
      montoVirtual: 60000,
      detalle: 'Por los 60 de Alderete',
    ),
    TesoreriaGeneralMovimiento(
      fecha: DateTime(2026, 1, 5),
      concepto: 'Capitas',
      montoEfectivo: null,
      montoVirtual: null,
      detalle: 'Hart 15k, Mingolla 30k, Falco 15k',
    ),
  ];
}
