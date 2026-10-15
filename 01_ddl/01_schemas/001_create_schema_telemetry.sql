-- Schema that holds every table owned by the telemetry-gps service inside the shared
-- rentamovil database. CREATE SCHEMA must be the only statement in its batch, hence the EXEC wrapper.
IF SCHEMA_ID('telemetry') IS NULL
    EXEC('CREATE SCHEMA telemetry');
