-- Database identity the rtm-telemetry-gps service connects with (never sa).
-- LOGIN = credentials to enter the SQL Server instance; USER = its identity inside rentamovil.
-- The password comes from liquibase.properties (parameter.telemetryAppPassword), never from this repo.

-- Fail fast if the parameter wasn't provided: Liquibase would otherwise leave the literal text.
IF '${telemetryAppPassword}' = '$' + '{telemetryAppPassword}'
    THROW 50000, 'Missing parameter.telemetryAppPassword in liquibase.properties', 1;

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'telemetry_app')
    CREATE LOGIN telemetry_app WITH PASSWORD = '${telemetryAppPassword}', CHECK_POLICY = ON;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'telemetry_app')
    CREATE USER telemetry_app FOR LOGIN telemetry_app WITH DEFAULT_SCHEMA = telemetry;
