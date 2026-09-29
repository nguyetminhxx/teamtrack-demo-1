CREATE DATABASE IF NOT EXISTS teamtrack CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE teamtrack;

DROP TABLE IF EXISTS formula_settings;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS meetings;
DROP TABLE IF EXISTS milestones;
DROP TABLE IF EXISTS project_members;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(190) UNIQUE NOT NULL,
  password TEXT NOT NULL,
  full_name VARCHAR(190) NOT NULL,
  short_name VARCHAR(90) NOT NULL,
  student_id VARCHAR(60),
  university VARCHAR(150),
  default_role VARCHAR(40),
  streak_days INT DEFAULT 0,
  credibility_points INT DEFAULT 0,
  ontime_rate_pct INT DEFAULT 100,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(150) NOT NULL,
  title TEXT NOT NULL,
  template_key VARCHAR(40) NOT NULL DEFAULT 'thuyettrinh',
  teacher VARCHAR(150),
  target VARCHAR(150),
  deadline DATETIME,
  active TINYINT(1) DEFAULT 1,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE project_members (
  project_id INT NOT NULL,
  user_id INT NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'member',
  PRIMARY KEY (project_id, user_id),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE milestones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  label VARCHAR(255) NOT NULL,
  due_date DATE,
  sort_order INT DEFAULT 0,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE meetings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  scheduled_at DATETIME,
  host_name VARCHAR(120),
  meet_link VARCHAR(255),
  agenda TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE documents (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  file_type VARCHAR(40),
  size_label VARCHAR(40),
  drive_url VARCHAR(255),
  uploaded_by VARCHAR(120),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  assignee_id INT,
  points INT NOT NULL DEFAULT 3,
  status VARCHAR(20) NOT NULL DEFAULT 'todo',
  due_at DATETIME,
  proof_url VARCHAR(255),
  note VARCHAR(255),
  submitted_at DATETIME,
  early_bonus_pct INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (assignee_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE formula_settings (
  project_id INT PRIMARY KEY,
  workload_pct INT NOT NULL DEFAULT 60,
  ontime_pct INT NOT NULL DEFAULT 25,
  peer_pct INT NOT NULL DEFAULT 15,
  leader_bonus_pct INT NOT NULL DEFAULT 0,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Tạo user ứng dụng. Đặt mật khẩu trùng với TT_DB_PASSWORD trong file .env
-- (xem .env.example). Có thể dùng lệnh sau, thay <TT_DB_PASSWORD>:
--   CREATE USER IF NOT EXISTS 'tt_user'@'localhost' IDENTIFIED BY '<TT_DB_PASSWORD>';
--   CREATE USER IF NOT EXISTS 'tt_user'@'127.0.0.1' IDENTIFIED BY '<TT_DB_PASSWORD>';
--   GRANT ALL PRIVILEGES ON teamtrack.* TO 'tt_user'@'localhost';
--   GRANT ALL PRIVILEGES ON teamtrack.* TO 'tt_user'@'127.0.0.1';
--   FLUSH PRIVILEGES;
