-- 06-data/models.md -> location. La tabla de mayor volumen de escritura de todo el sistema: los
-- dispositivos reportan continuamente mientras la renta está en curso (data-model.md).
--
-- Creada sin FK; se agrega en 04_alter, una vez que telemetry.gps ya existe (igual que el resto
-- de los repos: las FKs nunca van en línea en 03_tables, incluso siendo del mismo servicio).
CREATE TABLE telemetry.location (
    location_id INT IDENTITY(1,1) NOT NULL,
    gps_id      INT               NOT NULL,
    latitude    DECIMAL(10,8)     NOT NULL,
    longitude   DECIMAL(11,8)     NOT NULL,
    [timestamp] DATETIME          NOT NULL,

    CONSTRAINT pk_location PRIMARY KEY (location_id),
    -- Location.INV-001 (entities-and-rules.md): coordenadas válidas, no cualquier número.
    CONSTRAINT ck_location_latitude CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT ck_location_longitude CHECK (longitude BETWEEN -180 AND 180)
);
