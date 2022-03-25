CREATE TABLE IF NOT EXISTS flags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) DEFAULT 'No description',
    status BOOLEAN NOT NULL DEFAULT FALSE,
    percentage_split SMALLINT NOT NULL CHECK (percentage_split >= 0 AND percentage_split <= 100) DEFAULT 100,
    hash_offset INTEGER NOT NULL DEFAULT 0,
    is_experiment BOOLEAN NOT NULL DEFAULT FALSE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    date_created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO experiments (name, is_experiment)
VALUES ('New Marketing Feature', TRUE);

CREATE TABLE IF NOT EXISTS custom_assignments (
 id SERIAL PRIMARY KEY,
 user_id TEXT NOT NULL,
 flag_id INTEGER REFERENCES flags (id) NOT NULL,
 status BOOLEAN NOT NULL DEFAULT TRUE,
 UNIQUE (user_id, flag_id)
);

CREATE TABLE IF NOT EXISTS flag_events (
    id SERIAL PRIMARY KEY,
    flag_id INTEGER NOT NULL,
    event_type VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS connection (
    id SERIAL PRIMARY KEY,
    pg_user VARCHAR(100) NOT NULL,
    pg_host VARCHAR(255) NOT NULL,
    pg_port INTEGER NOT NULL,
    pg_database VARCHAR(255),
    pg_password VARCHAR(255),
    expt_table_query VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS keys (
    sdk_key VARCHAR(37) PRIMARY KEY UNIQUE
);

CREATE TABLE IF NOT EXISTS experiments (
    id SERIAL PRIMARY KEY,
    flag_id INTEGER REFERENCES flags (id),
    date_started DATE NOT NULL DEFAULT CURRENT_DATE,
    date_ended DATE,
    duration INTEGER NOT NULL DEFAULT 90,
    name VARCHAR(50),
    description VARCHAR(255)
);

INSERT INTO experiments (id, flag_id, date_started)
VALUES (1, 1, '2022-03-14');

CREATE TABLE IF NOT EXISTS exposures (
  id SERIAL PRIMARY KEY,
  experiment_id INTEGER REFERENCES experiments (id) NOT NULL,
  variant VARCHAR(7) NOT NULL,
  num_users INTEGER NOT NULL,
  date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS metrics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  query_string TEXT NOT NULL,
  type VARCHAR(10) NOT NULL,
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS experiment_metrics (
 experiment_id INTEGER REFERENCES experiments (id) NOT NULL,
 metric_id INTEGER REFERENCES metrics (id) NOT NULL,
 mean_test FLOAT,
 mean_control FLOAT,
 interval_start FLOAT,
 interval_end FLOAT,
 p_value FLOAT,
 PRIMARY KEY (experiment_id, metric_id)
);
