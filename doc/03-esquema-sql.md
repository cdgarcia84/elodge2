# ELOGDE - Esquema SQL inicial (SQLite)

Este esquema es una base para implementar con SQLite/SQLCipher.

## Tablas base

```sql
CREATE TABLE logia (
  id TEXT PRIMARY KEY,
  nombre TEXT NOT NULL,
  estado TEXT NOT NULL,
  domicilio TEXT NOT NULL,
  dias_reunion TEXT NOT NULL,
  moneda TEXT NOT NULL,
  clave_logia_id TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE rol_gestion (
  id TEXT PRIMARY KEY,
  nombre TEXT NOT NULL UNIQUE,
  descripcion TEXT
);

CREATE TABLE grado (
  id TEXT PRIMARY KEY,
  nombre TEXT NOT NULL UNIQUE,
  nivel INTEGER NOT NULL
);

CREATE TABLE cargo (
  id TEXT PRIMARY KEY,
  nombre TEXT NOT NULL UNIQUE,
  descripcion TEXT,
  activo INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE usuario (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  password_salt TEXT NOT NULL,
  hh_id TEXT,
  rol_gestion_id TEXT NOT NULL,
  activo INTEGER NOT NULL DEFAULT 1,
  created_at INTEGER NOT NULL,
  last_login_at INTEGER,
  FOREIGN KEY (hh_id) REFERENCES hh(id),
  FOREIGN KEY (rol_gestion_id) REFERENCES rol_gestion(id)
);

CREATE TABLE hh (
  id TEXT PRIMARY KEY,
  legajo TEXT NOT NULL UNIQUE,
  apellidos TEXT NOT NULL,
  nombres TEXT NOT NULL,
  grado_id TEXT NOT NULL,
  cargo_id TEXT NOT NULL,
  afiliacion TEXT NOT NULL,
  domicilio TEXT NOT NULL,
  localidad TEXT NOT NULL,
  telefonos TEXT NOT NULL,
  email TEXT NOT NULL,
  ml INTEGER NOT NULL DEFAULT 0,
  mh INTEGER NOT NULL DEFAULT 0,
  delegado_titular INTEGER NOT NULL DEFAULT 0,
  delegado_suplente INTEGER NOT NULL DEFAULT 0,
  hbr INTEGER NOT NULL DEFAULT 0,
  bjg INTEGER NOT NULL DEFAULT 0,
  estado TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  last_modified_at INTEGER NOT NULL,
  FOREIGN KEY (grado_id) REFERENCES grado(id),
  FOREIGN KEY (cargo_id) REFERENCES cargo(id)
);

CREATE TABLE auditoria (
  id TEXT PRIMARY KEY,
  entidad TEXT NOT NULL,
  entidad_id TEXT NOT NULL,
  accion TEXT NOT NULL,
  actor_usuario_id TEXT NOT NULL,
  payload TEXT,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (actor_usuario_id) REFERENCES usuario(id)
);
```

## Tesoreria

```sql
CREATE TABLE cuenta_hh (
  id TEXT PRIMARY KEY,
  hh_id TEXT NOT NULL UNIQUE,
  saldo INTEGER NOT NULL DEFAULT 0,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY (hh_id) REFERENCES hh(id)
);

CREATE TABLE cuota (
  id TEXT PRIMARY KEY,
  monto INTEGER NOT NULL,
  periodicidad TEXT NOT NULL,
  activa INTEGER NOT NULL DEFAULT 1,
  created_at INTEGER NOT NULL
);

CREATE TABLE cargo_hh (
  id TEXT PRIMARY KEY,
  hh_id TEXT NOT NULL,
  tipo TEXT NOT NULL,
  monto INTEGER NOT NULL,
  fecha INTEGER NOT NULL,
  descripcion TEXT,
  creado_por_usuario_id TEXT NOT NULL,
  FOREIGN KEY (hh_id) REFERENCES hh(id),
  FOREIGN KEY (creado_por_usuario_id) REFERENCES usuario(id)
);

CREATE TABLE pago_hh (
  id TEXT PRIMARY KEY,
  hh_id TEXT NOT NULL,
  monto INTEGER NOT NULL,
  fecha INTEGER NOT NULL,
  medio TEXT,
  descripcion TEXT,
  creado_por_usuario_id TEXT NOT NULL,
  FOREIGN KEY (hh_id) REFERENCES hh(id),
  FOREIGN KEY (creado_por_usuario_id) REFERENCES usuario(id)
);

CREATE TABLE movimiento_general (
  id TEXT PRIMARY KEY,
  tipo TEXT NOT NULL,
  monto INTEGER NOT NULL,
  fecha INTEGER NOT NULL,
  descripcion TEXT,
  creado_por_usuario_id TEXT NOT NULL,
  FOREIGN KEY (creado_por_usuario_id) REFERENCES usuario(id)
);
```

## Configuracion

```sql
CREATE TABLE clave_logia (
  id TEXT PRIMARY KEY,
  clave_cifrado BLOB NOT NULL,
  activa INTEGER NOT NULL DEFAULT 1,
  created_at INTEGER NOT NULL,
  rotada_por_usuario_id TEXT,
  FOREIGN KEY (rotada_por_usuario_id) REFERENCES usuario(id)
);

CREATE TABLE config (
  id TEXT PRIMARY KEY,
  clave TEXT NOT NULL UNIQUE,
  valor TEXT NOT NULL,
  updated_at INTEGER NOT NULL
);
```

## Indices sugeridos

```sql
CREATE INDEX idx_hh_apellidos ON hh(apellidos);
CREATE INDEX idx_hh_grado ON hh(grado_id);
CREATE INDEX idx_hh_estado ON hh(estado);
CREATE INDEX idx_cargo_hh_fecha ON cargo_hh(fecha);
CREATE INDEX idx_pago_hh_fecha ON pago_hh(fecha);
CREATE INDEX idx_movimiento_general_fecha ON movimiento_general(fecha);
```
