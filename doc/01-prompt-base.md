# Prompt base - ELODGE

Necesito que actues como arquitecto/PM tecnico para una app descentralizada de gestion de logias masonicas. Empezamos desde cero y el contexto es solo para UNA logia (una BD por logia). No compartas datos entre logias. Si un HH pertenece a varias logias, tiene usuarios separados.

## Objetivo general
Desarrollar una aplicacion descentralizada que ejecute en dispositivos locales (movil y desktop), sin servidor 24x7, y sincronice P2P cuando se abre. La app es mayormente lectura y se trabaja por modulos.

## Modulos iniciales
1) Gestion de HH (hermanos)
2) Tesoreria del taller

## Roles y permisos
Dos ejes independientes:
- Rol de gestion: VM, Secretario, Tesorero, Admin, HH (solo lectura).
- Grado masonico: Aprendiz, Companero, Maestro.

Lineamientos:
- VM hace todo (incluye configuracion global).
- Secretario edita HH y su modulo futuro (actas, planchas, etc.).
- Tesorero edita tesoreria (personal y general).
- Admin solo configuracion global; puede coexistir con otro rol (doble rol).
- HH sin cargo: lectura segun su grado.
- Grado define visibilidad: Companero ve Aprendiz; Maestro ve Companero y Aprendiz.

## Sync
- P2P con consistencia eventual.
- "Ultimo escritor gana".
- Cada dispositivo guarda BD completa (backup implicito).
- Si no hay pares, se puede usar un nodo de sincronizacion temporal.

## Cifrado y seguridad
- BD cifrada con AES.
- Clave unica por logia (autogenerada).
- Passwords con hash + salt.
- Reset de password aprobado por VM, con reinstalacion y resincronizacion.

## Modulo HH - operaciones
- Alta, baja logica (inactivo), cambios, listado, historial/auditoria.
- Categorias: grados y cargos.
- Cuota mensual asignada automaticamente (al abrir o por fecha).

## Tesoreria
Dos partes:
- Tesoreria personal por HH: cuotas, pagos, saldo (solo roles con permiso).
- Tesoreria general del taller: ingresos/egresos visibles a todos.
- Sin comprobantes por ahora.

## Campos base de HH (Gran Logia Argentina)
Obligatorios:
- Legajo (Leg. #)
- Apellidos
- Nombres
- Grado
- Cargo
- Afiliacion (Afil.)
- Domicilio
- Localidad
- Telefonos
- Email

Opcionales:
- ML (miembro libre)
- MH (miembro de honor)
- D.T. (delegado titular)
- D.S. (delegado suplente)
- HBR (rep. Hogar Bernardino Rivadavia)
- BJG (rep. Biblioteca Joaquin Gonzalez)

## Plataforma
- Flutter como base.
- Apps nativas: Android + desktop (Win/Linux/Mac).
*** End Patch} }`})();
