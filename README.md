# rtm-telemetry-gps-db

Migraciones Liquibase de las tablas del servicio **Telemetry & GPS** de RentaMovil (ubicación GPS
durante rentas activas e historial de ruta — ver `rtm-docs/09-microservices/service-catalog.md`).

- **Base de datos:** `rentamovil` (SQL Server), **compartida** por todos los servicios.
- **Schema propio:** `telemetry` — toda tabla de este repo se crea como `telemetry.<tabla>`.
  Ninguna tabla va en `dbo`.
- **Tablas:** `gps` (catálogo de dispositivos, sembrado con datos de prueba), `location` (la de
  mayor volumen de escritura de todo el sistema).
- **Historial Liquibase propio:** `dbo.DATABASECHANGELOG_TELEMETRY` / `dbo.DATABASECHANGELOGLOCK_TELEMETRY`.
- **Orden entre repos:** 3.º — después de `rtm-fleet-maintenance-db`, antes de `rtm-booking-db`
  (`booking.rental.gps_id` es FK hacia `telemetry.gps`). Decisión en ADR-009.

Convenciones completas (estructura, nombres, orden, rollback): `rtm-docs/06-data/migration-strategy.md`.

## Por qué `gps` se siembra en vez de tener un endpoint de alta

Ninguna HU (`04-requirements/user-stories.md`) gestiona el catálogo de dispositivos vía API — el
Administrador solo indica un `gpsId` ya existente al registrar el pickup en `booking-reservation`
(`decisions.md` del servicio). Por eso `02_dml/00_inserts` siembra 3 dispositivos de prueba, igual
que `rtm-iam-db` siembra roles y permisos.

## Estructura

```
changelog/changelog-master.yaml   ← punto de entrada: incluye 01_ddl → 02_dml → 03_dcl → 04_tcl
01_ddl/                           DDL
  01_schemas/                       CREATE SCHEMA telemetry
  03_tables/                        CREATE TABLE, sin FKs
  04_alter/                         FK de location hacia gps
  05_views/                         CREATE VIEW (vacío)
  10_indexes/                       CREATE INDEX
02_dml/                           DML
  00_inserts/                       3 dispositivos GPS de prueba
  01_updates/                       (vacío)
  02_deletes/                       (vacío)
03_dcl/                           DCL
  00_roles/                         usuario de BD del servicio (telemetry_app)
  01_grants/                        permisos sobre el schema telemetry
04_tcl/                           TCL (vacío)
05_rollbacks/                     espejo de 01_ddl … 03_dcl: un .rollback.sql por cada .sql
```

## Requisitos

- Java 17+
- Maven 3.9+
- Docker Desktop
- **SQL Server ya levantado y migrado desde `rtm-iam-db`**, y **`rtm-fleet-maintenance-db` ya
  migrado** (corre antes en el orden, aunque este repo no tiene FK hacia `fleet`)

## Uso local

```bash
cp .env.example .env
cp liquibase.properties.example liquibase.properties
# edita la contraseña de sa en los dos archivos (deben coincidir) y pon en
# liquibase.properties una contraseña para telemetry_app (parameter.telemetryAppPassword)

mvn liquibase:status
mvn liquibase:updateSQL
mvn liquibase:update
```

### Con Docker (red compartida `rentamovil`)

```bash
cd ../../Iam/rtm-iam-db && docker compose up -d
docker compose up -d
```

| Contenedor | Qué hace | Estado normal |
|---|---|---|
| `migrations` | Corre las migraciones de este repo (igual que `mvn liquibase:update`) | `Exited (0)` |

## Usuario de base de datos del servicio (`03_dcl`)

Las migraciones corren con `sa`. El servicio `rtm-telemetry-gps` **nunca** usa `sa`: se conecta
con `telemetry_app`, que solo puede leer y escribir datos del schema `telemetry` (sin DDL, sin
acceso a otros schemas ni a `dbo`). Su contraseña **no está en el repo**: sale de
`parameter.telemetryAppPassword` en `liquibase.properties` (git-ignored).

## Ramas

`feat/`, `fix/`, `chore/` → PR a `develop` (Squash and Merge). Ver
`rtm-docs/00-governance/git-conventions.md`.
