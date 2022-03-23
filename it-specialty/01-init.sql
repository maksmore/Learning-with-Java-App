CREATE TABLE IF NOT EXISTS specialty(
    id INT PRIMARY KEY,
    name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS technology(
    id INT PRIMARY KEY,
    name varchar(50) NOT NULL,
    specialty_id INT NOT NULL REFERENCES specialty(id)
);

GRANT ALL PRIVILEGES ON DATABASE "postgres" TO postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres;
ALTER USER postgres WITH ENCRYPTED PASSWORD 'password';

INSERT INTO specialty VALUES (1, 'developer'), (2, 'maintenance');

INSERT INTO technology VALUES (1, 'language(java, python)', 1),
(2, 'framework(spring)', 1),
(3, 'language(python, bash, perl, ruby)', 2),
(4, 'technologies(Linux, TCP/IP, Zabbix, Grafana, etc.)', 2);

SELECT * FROM specialty s 
INNER JOIN technology t ON s.id = t.specialty_id;
