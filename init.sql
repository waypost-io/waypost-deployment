CREATE TABLE IF NOT EXISTS flags (
    id SERIAL PRIMARY KEY,
    app_id integer,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) DEFAULT 'No description',
    status boolean NOT NULL DEFAULT FALSE,
    percentage_split SMALLINT NOT NULL CHECK (percentage_split >= 0 AND percentage_split <= 100) DEFAULT 100,
    is_experiment boolean NOT NULL DEFAULT FALSE,
    is_deleted boolean NOT NULL DEFAULT FALSE,
    date_created timestamp with time zone NOT NULL DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS flag_events (
    id SERIAL PRIMARY KEY,
    flag_id integer NOT NULL,
    event_type VARCHAR(255) NOT NULL,
    timestamp timestamp with time zone NOT NULL DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS connection (
    id SERIAL PRIMARY KEY,
    pg_user VARCHAR(100) NOT NULL,
    pg_host VARCHAR(255) NOT NULL,
    pg_port integer NOT NULL,
    pg_database VARCHAR(255),
    pg_password VARCHAR(255),
    expt_table_query VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS experiments (
    id SERIAL PRIMARY KEY,
    flag_id INTEGER REFERENCES flags (id),
    date_started DATE NOT NULL DEFAULT CURRENT_DATE,
    date_ended DATE,
    duration INT NOT NULL DEFAULT 90,
    hash_offset INT NOT NULL DEFAULT 0,
    name VARCHAR(50),
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS exposures (
  id SERIAL PRIMARY KEY,
  experiment_id INTEGER REFERENCES experiments (id) NOT NULL,
  variant VARCHAR(7) NOT NULL,
  num_users INT NOT NULL,
  date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS metrics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  query_string TEXT NOT NULL,
  type VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS experiment_metrics (
 experiment_id INTEGER REFERENCES experiments (id) NOT NULL,
 metric_id INTEGER REFERENCES metrics (id) NOT NULL,
 mean_test float,
 mean_control float,
 standard_dev_test float,
 standard_dev_control float,
 p_value float,
 PRIMARY KEY (experiment_id, metric_id)
);