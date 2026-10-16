-- Solo GPS-TEST-001 es un dispositivo físico real hoy. Los otros dos quedaban en el seed inicial
-- y aparecían como opciones válidas en el selector del admin sin corresponder a nada real.
-- Se desactivan (no se borran) para no romper la FK rental.gps_id si alguna vez se usaron.
UPDATE telemetry.gps
SET is_active = 0
WHERE serial IN ('GPS-TEST-002', 'GPS-TEST-003');
