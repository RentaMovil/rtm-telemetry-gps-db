-- Data access only, and only on the telemetry schema: no DDL (that's Liquibase's job with its own
-- account), no access to other services' schemas or to dbo (Liquibase history tables).
--
-- This is what enforces the data-ownership matrix in 09-microservices/service-catalog.md on a
-- physically shared database: telemetry_app cannot read iam.*, booking.* or fleet.* even by
-- mistake. The FK that crosses service boundaries the other way (booking.rental.gps_id ->
-- telemetry.gps) still works (checked by the engine, not by the application user).
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::telemetry TO telemetry_app;
