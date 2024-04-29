-- Create tables:
CREATE TABLE appointments(
    appointment_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    time VARCHAR(50) NOT NULL,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY(service_id) REFERENCES services(service_id)
);

CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE services(
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Insert initial data into services table:
INSERT INTO
    services(name)
VALUES
    ('Cut'),
    ('color'),
    ('perm'),
    ('style'),
    ('trim');