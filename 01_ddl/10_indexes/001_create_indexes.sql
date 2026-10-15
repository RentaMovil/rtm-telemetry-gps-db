-- location(gps_id, timestamp) -- tanto "última ubicación" (ORDER BY timestamp DESC LIMIT 1)
-- como "historial completo" (ORDER BY timestamp ASC) filtran por este par (data-model.md).
CREATE INDEX ix_location_gps_id_timestamp ON telemetry.location (gps_id, [timestamp]);
