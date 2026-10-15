-- Foreign key for the table created in 03_tables. telemetry.gps already exists in this same run.
ALTER TABLE telemetry.location
    ADD CONSTRAINT fk_location_gps FOREIGN KEY (gps_id) REFERENCES telemetry.gps(gps_id);
