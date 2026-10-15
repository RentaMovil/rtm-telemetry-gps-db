-- Dispositivos de prueba. No hay ninguna HU para crear/gestionar gps vía API (README.md,
-- decisions.md): el Administrador solo indica un gpsId ya existente al registrar el pickup, así
-- que el catálogo se siembra acá, igual que iam siembra sus roles y permisos.
INSERT INTO telemetry.gps (serial, model, is_active) VALUES
    ('GPS-TEST-001', 'Queclink GV75', 1),
    ('GPS-TEST-002', 'Queclink GV75', 1),
    ('GPS-TEST-003', 'Concox GT06N', 1);
