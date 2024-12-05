-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           8.0.30 - MySQL Community Server - GPL
-- SE du serveur:                Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour imen
CREATE DATABASE IF NOT EXISTS `imen` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `imen`;

-- Listage de la structure de table imen. classes
CREATE TABLE IF NOT EXISTS `classes` (
  `class_id` varchar(10) NOT NULL,
  `subject_id` varchar(10) DEFAULT NULL,
  `class_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`class_id`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Listage des données de la table imen.classes : ~2 rows (environ)
INSERT INTO `classes` (`class_id`, `subject_id`, `class_name`) VALUES
	('C001', 'S001', 'Mathematics 101 - Section A'),
	('C002', 'S002', 'Physics 101 - Section B');

-- Listage de la structure de table imen. rooms
CREATE TABLE IF NOT EXISTS `rooms` (
  `room_id` varchar(10) NOT NULL,
  `room_name` varchar(100) DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `building` varchar(100) DEFAULT NULL,
  `floor` int DEFAULT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Listage des données de la table imen.rooms : ~3 rows (environ)
INSERT INTO `rooms` (`room_id`, `room_name`, `capacity`, `building`, `floor`) VALUES
	('R101', 'Room 101', 30, 'Building A', 1),
	('R102', 'Room 102', 25, 'Building B', 2),
	('R103', 'uuuuuu', 1, 'building', 12);

-- Listage de la structure de table imen. sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(10) NOT NULL,
  `subject_id` varchar(10) DEFAULT NULL,
  `teacher_id` varchar(10) DEFAULT NULL,
  `room_id` varchar(10) DEFAULT NULL,
  `class_id` varchar(10) DEFAULT NULL,
  `session_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `subject_id` (`subject_id`),
  KEY `teacher_id` (`teacher_id`),
  KEY `room_id` (`room_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`),
  CONSTRAINT `sessions_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`),
  CONSTRAINT `sessions_ibfk_3` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`),
  CONSTRAINT `sessions_ibfk_4` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Listage des données de la table imen.sessions : ~0 rows (environ)

-- Listage de la structure de table imen. students
CREATE TABLE IF NOT EXISTS `students` (
  `student_id` varchar(10) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Listage des données de la table imen.students : ~3 rows (environ)
INSERT INTO `students` (`student_id`, `first_name`, `last_name`, `email`) VALUES
	('ST001', 'Alice', 'Johnson', 'alice.johnson@example.com'),
	('ST002', 'Bob', 'Williams', 'bob.williams@example.com'),
	('ST003', 'Charlie', 'Davis', 'charlie.davis@example.com');

-- Listage de la structure de table imen. subjects
CREATE TABLE IF NOT EXISTS `subjects` (
  `subject_id` varchar(10) NOT NULL,
  `subject_name` varchar(100) DEFAULT NULL,
  `subject_code` varchar(20) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Listage des données de la table imen.subjects : ~2 rows (environ)
INSERT INTO `subjects` (`subject_id`, `subject_name`, `subject_code`, `department`, `description`) VALUES
	('S001', 'Mathematics 101', 'MATH101', 'Mathematics', 'Introduction to Algebra and Calculus'),
	('S002', 'Physics 101', 'PHYS101', 'Physics', 'Fundamentals of Physics');

-- Listage de la structure de table imen. teachers
CREATE TABLE IF NOT EXISTS `teachers` (
  `teacher_id` varchar(10) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Listage des données de la table imen.teachers : ~2 rows (environ)
INSERT INTO `teachers` (`teacher_id`, `first_name`, `last_name`, `email`, `department`, `phone`) VALUES
	('T001', 'John', 'Doe', 'johndoe@example.com', 'Mathematics', '1234567890'),
	('T002', 'Jane', 'Smith', 'janesmith@example.com', 'Physics', '0987654321');

-- Listage de la structure de table imen. users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Listage des données de la table imen.users : ~5 rows (environ)
INSERT INTO `users` (`id`, `email`, `password`, `created_at`) VALUES
	(1, 'ichraf@gmail.com', '$2a$10$E3o6HKcRPBLny4dHgM7RbeeaKm7TMcdM1zJqI9w81xMHKGISGuKhm', '2024-12-04 17:23:49'),
	(4, 'ichraf2@gmail.com', '$2a$10$hMCAeFJygdJkCWLt.7sxUO8xBq.M078PzabD1wAq/a7UaFOUgFnB6', '2024-12-04 19:17:17'),
	(5, 'imen@gmail.com', '$2a$10$Em37NsAAw.0ZYGZ5BVKdzeRXfJFzfoxUuPdgNHR6ZPaiu6OeTYiM6', '2024-12-04 19:26:00'),
	(6, 'nour@gmail.com', '$2a$10$Vbf8EoVKYy9VgIlm8uiUwO.iDNAN0vYydGM1YOTHm7OdO3ayPmQc6', '2024-12-04 19:56:59'),
	(7, 'test@gmail.com', '$2a$10$Cs.DEgGz.Kv2yNZuO80PweBDRV1EN/vgRXhd4TYuIfmg9hQJhc.tm', '2024-12-04 20:37:54');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
