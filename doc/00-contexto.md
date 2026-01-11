# ELOGDE - Contexto base

Este documento resume las decisiones iniciales para una logia (una BD por logia).

## Vision general
- App descentralizada (sin servidor 24x7), ejecuta en dispositivos locales.
- Sincronizacion P2P con consistencia eventual y "ultimo escritor gana".
- Copia completa de la BD en cada dispositivo (backup implicito).
- Operacion mayormente lectura, con pocos cambios por semana.
- Plataforma objetivo: apps nativas (Android + desktop).

## Roles y permisos
Dos ejes independientes:
1) Rol de gestion: VM, Secretario, Tesorero, Admin, HH (solo lectura).
2) Grado masonico: Aprendiz, Companero, Maestro.

Lineamientos:
- VM puede hacer todo, incluido configuracion global.
- Secretario edita modulo HH y su modulo futuro (actas, planchas, etc.).
- Tesorero edita tesoreria (personal y general).
- Admin solo configuracion global (puede coexistir con otro rol).
- HH sin cargo: lectura segun su grado.
- Grado define visibilidad: Companero ve Aprendiz; Maestro ve Companero y Aprendiz.

## Datos de HH (campos base)
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

## Modulos iniciales
1) Gestion de HH
   - Alta, baja logica (inactivo), cambios, listado, historial/auditoria.
   - Categorias: grados y cargos.

2) Tesoreria
   - Personal por HH: cuotas, pagos, saldo.
   - General del taller: ingresos/egresos visibles a todos.
   - Cuota mensual automatica (se dispara al abrir la app o por fecha).

## Cifrado y seguridad
- BD cifrada con AES.
- Clave unica por logia (no compartida entre logias).
- Acceso con usuario/password (hash + salt).
- Reset de password: aprobado por VM; reinstalacion y resincronizacion.

## Sincronizacion
- P2P entre dispositivos.
- Sin conflictos esperados; si ocurren, "ultimo escritor gana".
- Primer nodo con datos mas nuevos actua como fuente principal.

## Alcance futuro
- Notificaciones, Secretaria, Biblioteca, etc.
