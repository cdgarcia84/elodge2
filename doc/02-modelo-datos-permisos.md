# ELOGDE - Modelo de datos y permisos (borrador)

Este documento define el modelo inicial para una logia (una BD por logia).

## Entidades principales
1) Logia
- id
- nombre
- estado (activa/inactiva)
- domicilio
- dias_reunion (texto)
- moneda (por defecto ARS)
- clave_logia_id (referencia a clave activa)

2) Usuario
- id
- username
- password_hash
- password_salt
- hh_id (nullable)
- rol_gestion_id
- activo (bool)
- created_at
- last_login_at

3) HH (Hermano)
- id
- legajo
- apellidos
- nombres
- grado_id
- cargo_id
- afiliacion
- domicilio
- localidad
- telefonos
- email
- ml (bool)
- mh (bool)
- delegado_titular (bool)
- delegado_suplente (bool)
- hbr (bool)
- bjg (bool)
- estado (activo/inactivo)
- created_at
- updated_at

4) RolGestion
- id
- nombre (VM, Secretario, Tesorero, Admin, HH)
- descripcion

5) Grado
- id
- nombre (Aprendiz, Companero, Maestro)
- nivel (1..3)

6) Cargo
- id
- nombre
- descripcion
- activo (bool)

7) Permiso
- id
- modulo (HH, TesoreriaPersonal, TesoreriaGeneral, Config)
- accion (lectura, crear, editar, eliminar, auditar)
- rol_gestion_id

8) Auditoria
- id
- entidad (HH, Tesoreria, Config, etc.)
- entidad_id
- accion (crear, editar, baja, reactivar)
- actor_usuario_id
- payload (json)
- created_at

## Tesoreria
9) CuentaHH
- id
- hh_id
- saldo
- updated_at

10) Cuota
- id
- monto
- periodicidad (mensual)
- activa (bool)
- created_at

11) CargoHH
- id
- hh_id
- tipo (cuota, otro)
- monto
- fecha
- descripcion
- creado_por_usuario_id

12) PagoHH
- id
- hh_id
- monto
- fecha
- medio (texto libre)
- descripcion
- creado_por_usuario_id

13) MovimientoGeneral
- id
- tipo (ingreso, egreso)
- monto
- fecha
- descripcion
- creado_por_usuario_id

## Configuracion
14) ClaveLogia
- id
- clave_cifrado (blob/bytes)
- activa (bool)
- created_at
- rotada_por_usuario_id

15) Config
- id
- clave
- valor
- updated_at

## Reglas de acceso por grado (contenido)
- Aprendiz: ve datos de Aprendiz.
- Companero: ve Aprendiz + Companero.
- Maestro: ve Aprendiz + Companero + Maestro.

## Roles de gestion (resumen)
- VM: acceso total (incluye Config).
- Secretario: CRUD HH + lectura tesoreria general, sin cambios en tesoreria.
- Tesorero: CRUD tesoreria (personal + general), lectura HH.
- Admin: CRUD Config, lectura HH y tesoreria general.
- HH: lectura segun grado.

## Matriz de permisos sugerida
HH
- VM: lectura/crear/editar/eliminar/auditar
- Secretario: lectura/crear/editar/auditar (sin eliminar fisico)
- Tesorero: lectura
- Admin: lectura
- HH: lectura (filtrada por grado)

Tesoreria personal
- VM: lectura/crear/editar/eliminar/auditar
- Tesorero: lectura/crear/editar/auditar
- Secretario: lectura
- Admin: lectura
- HH: lectura propia (si aplica)

Tesoreria general
- VM: lectura/crear/editar/eliminar/auditar
- Tesorero: lectura/crear/editar/auditar
- Secretario: lectura
- Admin: lectura
- HH: lectura

Config
- VM: lectura/crear/editar/auditar
- Admin: lectura/crear/editar/auditar
- Secretario: lectura
- Tesorero: lectura
- HH: sin acceso

## Notas
- Bajas de HH son logicas (estado=inactivo).
- "Eliminar" solo para datos operativos (si aplica).
- Auditoria guarda cambios de HH, tesoreria y configuracion.
- Cuota mensual: al abrir la app, se verifica y genera el cargo del mes.
