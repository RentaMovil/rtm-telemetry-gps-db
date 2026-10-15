-- 06-data/models.md -> gps. Catálogo de dispositivos físicos instalados por vehículo al
-- registrar el pickup (booking-reservation indica el gpsId directamente, decisions.md).
CREATE TABLE telemetry.gps (
    gps_id    INT IDENTITY(1,1) NOT NULL,
    serial    VARCHAR(100)      NOT NULL,
    model     VARCHAR(50)       NULL,
    is_active BIT               NOT NULL,

    CONSTRAINT pk_gps PRIMARY KEY (gps_id),
    CONSTRAINT uq_gps_serial UNIQUE (serial)
);
