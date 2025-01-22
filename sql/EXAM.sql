CREATE TABLE StaffType (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL
);

CREATE TABLE Staff (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    staff_type_id INTEGER NOT NULL,
    FOREIGN KEY (staff_type_id) REFERENCES StaffType(id)
);

CREATE TABLE EquipmentType (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    subtype_name VARCHAR(100)
);

CREATE TABLE Equipment (
    id SERIAL PRIMARY KEY,
    equipment_name VARCHAR(200) NOT NULL,
    equipment_type_id INTEGER NOT NULL,
    FOREIGN KEY (equipment_type_id) REFERENCES EquipmentType(id)
);

CREATE TABLE Installation (
    id SERIAL PRIMARY KEY,
    installation_type VARCHAR(100) NOT NULL,
    installation_name VARCHAR(200) NOT NULL,
    address VARCHAR(255) NOT NULL,
    customer_name VARCHAR(100) NOT NULL
);

CREATE TABLE InstallationEquipment (
    installation_id INTEGER,
    equipment_id INTEGER,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (installation_id, equipment_id),
    FOREIGN KEY (installation_id) REFERENCES Installation(id),
    FOREIGN KEY (equipment_id) REFERENCES Equipment(id)
);

CREATE TABLE StaffAssignment (
    staff_id INTEGER,
    installation_id INTEGER,
    start_date DATE NOT NULL,
    end_date DATE,
    PRIMARY KEY (staff_id, installation_id, start_date),
    FOREIGN KEY (staff_id) REFERENCES Staff(id),
    FOREIGN KEY (installation_id) REFERENCES Installation(id),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

--Malumotlar to'ldirish
INSERT INTO StaffType (type_name) VALUES 
    ('Mason'),
    ('Installition Engineer'),
    ('Aquatics Installer'),
	('Plumber'),
	('Brick Layer');

INSERT INTO Staff (name, staff_type_id) VALUES 
    ('Alisher', 1),
    ('Abdul Aziz', 2),
    ('Ulugbek', 3),
	('Yusuf', 2),
	('Eric', 4),
	('Ardaq', 3),
	('Asilbek', 5);

INSERT INTO EquipmentType (type_name, subtype_name) VALUES 
	('Dustless', ''),
	('Air Driven', 'Under gravel'),
	('Standard', 'Super');

INSERT INTO Equipment (equipment_name, equipment_type_id) VALUES
	('Air handlers', 1),
	('Thermostats', 3),
	('Air pumps', 3),
	('Filters', 2),
	('Humidifiers', 3),
	('DeHumidifiers', 3);

INSERT INTO Installation (installation_type, installation_name, address, customer_name) VALUES 
    ('Cooling Ventilation', 'Air condition', 'Tashkent', 'Azizbek'),
    ('Thermal', 'Heating and Cooling', 'Tashkent', 'Jasur');

INSERT INTO InstallationEquipment(installation_id, equipment_id, quantity) VALUES
	(1, 1, 2),
	(2, 2, 1);

INSERT INTO StaffAssignment(staff_id, installation_id, start_date, end_date) VALUES
	(2, 1, '10-10-2024', '12-10-2024'),
	(4, 2, '01-01-2025', '05-01-2025');

SELECT s.id, s.name, st.type_name as role
FROM Staff s
JOIN StaffType st ON s.staff_type_id = st.id;


SELECT 
    i.installation_name,
    i.installation_type,
    i.address,
    e.equipment_name,
    ie.quantity,
    i.customer_name
FROM Installation i
JOIN InstallationEquipment ie ON i.id = ie.installation_id
JOIN Equipment e ON ie.equipment_id = e.id;


-- 1. SELECT
SELECT s.id, s.name, st.type_name
FROM Staff s
JOIN StaffType st ON s.staff_type_id = st.id;

SELECT e.id, e.equipment_name, et.type_name, et.subtype_name
FROM Equipment e
JOIN EquipmentType et ON e.equipment_type_id = et.id
WHERE et.type_name = 'Konditsioner';

SELECT i.installation_name, COUNT(ie.equipment_id) as equipment_count
FROM Installation i
LEFT JOIN InstallationEquipment ie ON i.id = ie.installation_id
GROUP BY i.installation_name;

-- 2. INSERT
INSERT INTO Staff (name, staff_type_id)
VALUES ('Bobur', 2);



INSERT INTO Installation (installation_type, installation_name, address, customer_name)
VALUES ('Zavod', 'Metal Konstruksiya', 'Toshkent sh., Sergeli', 'Metal Pro LLC');

INSERT INTO StaffAssignment (staff_id, installation_id, start_date)
VALUES (1, 1, CURRENT_DATE);

--3. UPDATE
UPDATE Staff
SET name = 'Akmal'
WHERE id = 1;

UPDATE Installation
SET address = 'Fargona'
WHERE id = 2;


--4. DELETE
DELETE FROM StaffAssignment WHERE staff_id = 1;
DELETE FROM Staff WHERE id = 1;

DELETE FROM InstallationEquipment WHERE equipment_id = 1;
DELETE FROM Equipment WHERE id = 1;


--5. JOIN
SELECT 
    i.installation_name,
    STRING_AGG(DISTINCT s.name, ', ') as staff_members,
    STRING_AGG(DISTINCT e.equipment_name, ', ') as equipment_list
FROM Installation i
LEFT JOIN StaffAssignment sa ON i.id = sa.installation_id
LEFT JOIN Staff s ON sa.staff_id = s.id
LEFT JOIN InstallationEquipment ie ON i.id = ie.installation_id
LEFT JOIN Equipment e ON ie.equipment_id = e.id
GROUP BY i.installation_name;

SELECT 
    s.name,
    st.type_name as role,
    COUNT(DISTINCT sa.installation_id) as installations_count,
    MIN(sa.start_date) as first_assignment,
    MAX(sa.end_date) as last_assignment
FROM Staff s
JOIN StaffType st ON s.staff_type_id = st.id
LEFT JOIN StaffAssignment sa ON s.id = sa.staff_id
GROUP BY s.name, st.type_name;


SELECT 
    et.type_name,
    COUNT(e.id) as total_equipment,
    COUNT(DISTINCT ie.installation_id) as installations_used
FROM EquipmentType et
LEFT JOIN Equipment e ON et.id = e.equipment_type_id
LEFT JOIN InstallationEquipment ie ON e.id = ie.equipment_id
GROUP BY et.type_name;

-- 6.TEST
INSERT INTO Staff (name, staff_type_id) VALUES ('Test User', 999);

INSERT INTO InstallationEquipment (installation_id, equipment_id, quantity)
VALUES (1, 1, -1);

INSERT INTO StaffAssignment (staff_id, installation_id, start_date, end_date)
VALUES (1, 1, '2024-01-01', '2023-01-01');