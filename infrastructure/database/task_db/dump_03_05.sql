-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: tasks_db
-- ------------------------------------------------------
-- Server version	8.0.41-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',8,'add_permission'),(2,'Can change permission',8,'change_permission'),(3,'Can delete permission',8,'delete_permission'),(4,'Can view permission',8,'view_permission'),(5,'Can add group',9,'add_group'),(6,'Can change group',9,'change_group'),(7,'Can delete group',9,'delete_group'),(8,'Can view group',9,'view_group'),(9,'Can add user',10,'add_user'),(10,'Can change user',10,'change_user'),(11,'Can delete user',10,'delete_user'),(12,'Can view user',10,'view_user'),(13,'Can add content type',1,'add_contenttype'),(14,'Can change content type',1,'change_contenttype'),(15,'Can delete content type',1,'delete_contenttype'),(16,'Can view content type',1,'view_contenttype'),(17,'Can add task',6,'add_task'),(18,'Can change task',6,'change_task'),(19,'Can delete task',6,'delete_task'),(20,'Can view task',6,'view_task'),(21,'Can add task path',3,'add_taskpath'),(22,'Can change task path',3,'change_taskpath'),(23,'Can delete task path',3,'delete_taskpath'),(24,'Can view task path',3,'view_taskpath'),(25,'Can add popular path',2,'add_popularpath'),(26,'Can change popular path',2,'change_popularpath'),(27,'Can delete popular path',2,'delete_popularpath'),(28,'Can view popular path',2,'view_popularpath'),(29,'Can add task path assignment',4,'add_taskpathassignment'),(30,'Can change task path assignment',4,'change_taskpathassignment'),(31,'Can delete task path assignment',4,'delete_taskpathassignment'),(32,'Can view task path assignment',4,'view_taskpathassignment'),(33,'Can add user paths',5,'add_userpaths'),(34,'Can change user paths',5,'change_userpaths'),(35,'Can delete user paths',5,'delete_userpaths'),(36,'Can view user paths',5,'view_userpaths'),(37,'Can add user task',7,'add_usertask'),(38,'Can change user task',7,'change_usertask'),(39,'Can delete user task',7,'delete_usertask'),(40,'Can view user task',7,'view_usertask'),(41,'Can add path',11,'add_path'),(42,'Can change path',11,'change_path'),(43,'Can delete path',11,'delete_path'),(44,'Can view path',11,'view_path'),(45,'Can add user path',12,'add_userpath'),(46,'Can change user path',12,'change_userpath'),(47,'Can delete user path',12,'delete_userpath'),(48,'Can view user path',12,'view_userpath'),(49,'Can add user task answer',13,'add_usertaskanswer'),(50,'Can change user task answer',13,'change_usertaskanswer'),(51,'Can delete user task answer',13,'delete_usertaskanswer'),(52,'Can view user task answer',13,'view_usertaskanswer');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (9,'auth','group'),(8,'auth','permission'),(10,'auth','user'),(1,'contenttypes','contenttype'),(11,'task_management','path'),(2,'task_management','popularpath'),(6,'task_management','task'),(3,'task_management','taskpath'),(4,'task_management','taskpathassignment'),(12,'task_management','userpath'),(5,'task_management','userpaths'),(7,'task_management','usertask'),(13,'task_management','usertaskanswer');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-03-24 22:18:51.163408'),(2,'contenttypes','0002_remove_content_type_name','2025-03-24 22:18:51.370004'),(3,'task_management','0001_initial','2025-03-27 23:15:36.104552'),(4,'auth','0001_initial','2025-03-27 23:24:34.921029'),(5,'auth','0002_alter_permission_name_max_length','2025-03-27 23:24:35.050422'),(6,'auth','0003_alter_user_email_max_length','2025-03-27 23:24:35.076411'),(7,'auth','0004_alter_user_username_opts','2025-03-27 23:24:35.088168'),(8,'auth','0005_alter_user_last_login_null','2025-03-27 23:24:35.195213'),(9,'auth','0006_require_contenttypes_0002','2025-03-27 23:24:35.201805'),(10,'auth','0007_alter_validators_add_error_messages','2025-03-27 23:24:35.211983'),(11,'auth','0008_alter_user_username_max_length','2025-03-27 23:24:35.355516'),(12,'auth','0009_alter_user_last_name_max_length','2025-03-27 23:24:35.482698'),(13,'auth','0010_alter_group_name_max_length','2025-03-27 23:24:35.512435'),(14,'auth','0011_update_proxy_permissions','2025-03-27 23:24:35.524605'),(15,'auth','0012_alter_user_first_name_max_length','2025-03-27 23:24:35.663364');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paths`
--

DROP TABLE IF EXISTS `paths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paths` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `color_hex` char(7) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paths`
--

LOCK TABLES `paths` WRITE;
/*!40000 ALTER TABLE `paths` DISABLE KEYS */;
INSERT INTO `paths` VALUES (1,'Ścieżka wdzięczności','Zadania pomagające zauważać pozytywne rzeczy.','https://picsum.photos/500/300?random=1','#220465','2025-04-05 19:13:02','2025-04-05 19:13:02'),(2,'Ścieżka relaksu','Zadania wspomagające redukcję stresu i napięcia.','https://picsum.photos/500/300?random=2','#446938','2025-04-05 19:13:02','2025-04-05 19:13:02'),(3,'Ścieżka uważności','Ćwiczenia rozwijające obecność tu i teraz.','https://picsum.photos/500/300?random=3','#708334','2025-04-05 19:13:02','2025-04-05 19:13:02'),(4,'Ścieżka samoakceptacji','Zadania wzmacniające pozytywne myślenie o sobie.','https://picsum.photos/500/300?random=4','#293018','2025-04-05 19:13:02','2025-04-05 19:13:02'),(5,'Ścieżka rozwoju','Zadania pomagające rozwijać nowe umiejętności i pasje.','https://picsum.photos/500/300?random=5','#374944','2025-04-05 19:13:02','2025-04-05 19:13:02'),(6,'Ścieżka emocji','Pomaga nazywać i akceptować emocje.','https://picsum.photos/500/300?random=6','#798876','2025-04-05 19:13:02','2025-04-05 19:13:02'),(7,'Ścieżka relacji','Zadania poprawiające relacje z innymi.','https://picsum.photos/500/300?random=7','#493851','2025-04-05 19:13:02','2025-04-05 19:13:02'),(8,'Ścieżka ciała','Zadania skupione na zdrowiu fizycznym i ruchu.','https://picsum.photos/500/300?random=8','#648492','2025-04-05 19:13:02','2025-04-05 19:13:02'),(9,'Ścieżka offline','Zadania ograniczające nadmiar bodźców cyfrowych.','https://picsum.photos/500/300?random=9','#830945','2025-04-05 19:13:02','2025-04-05 19:13:02'),(10,'Ścieżka ekspresji','Zadania pobudzające kreatywność i ekspresję.','https://picsum.photos/500/300?random=10','#539823','2025-04-05 19:13:02','2025-04-05 19:13:02');
/*!40000 ALTER TABLE `paths` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popular_paths`
--

DROP TABLE IF EXISTS `popular_paths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `popular_paths` (
  `id` int NOT NULL AUTO_INCREMENT,
  `path_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `path_id` (`path_id`),
  CONSTRAINT `popular_paths_ibfk_1` FOREIGN KEY (`path_id`) REFERENCES `paths` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popular_paths`
--

LOCK TABLES `popular_paths` WRITE;
/*!40000 ALTER TABLE `popular_paths` DISABLE KEYS */;
INSERT INTO `popular_paths` VALUES (1,1),(2,3),(3,5),(4,7),(5,8);
/*!40000 ALTER TABLE `popular_paths` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_path`
--

DROP TABLE IF EXISTS `task_path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_path` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` int NOT NULL,
  `path_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `task_id` (`task_id`),
  KEY `path_id` (`path_id`),
  CONSTRAINT `task_path_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_path_ibfk_2` FOREIGN KEY (`path_id`) REFERENCES `paths` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_path`
--

LOCK TABLES `task_path` WRITE;
/*!40000 ALTER TABLE `task_path` DISABLE KEYS */;
INSERT INTO `task_path` VALUES (1,1,10),(2,2,9),(3,3,3),(4,4,9),(5,5,8),(6,6,10),(7,7,5),(8,8,3),(9,9,1),(10,10,1),(11,11,9),(12,12,8),(13,13,5),(14,14,5),(15,15,4),(16,16,1),(17,17,10),(18,18,7),(19,19,5),(20,20,6),(21,21,4),(22,22,7),(23,23,7),(24,24,9),(25,25,4),(26,26,9),(27,27,2),(28,28,1),(29,29,8),(30,30,10),(31,31,2),(32,32,6),(33,33,10),(34,34,1),(35,35,10),(36,36,7),(37,37,2),(38,38,5),(39,39,1),(40,40,10),(41,41,6),(42,42,1),(43,43,9),(44,44,9),(45,45,2),(46,46,6),(47,47,3),(48,48,6),(49,49,4),(50,50,3);
/*!40000 ALTER TABLE `task_path` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `difficulty` int DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `date_for_daily` date DEFAULT NULL,
  `answer_type` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `tasks_chk_1` CHECK ((`answer_type` in (_utf8mb4'text',_utf8mb4'checkbox')))
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,'Zadanie 1','Opis zadania 1, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 1',3,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(2,'Zadanie 2','Opis zadania 2, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 2',3,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(3,'Zadanie 3','Opis zadania 3, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 3',2,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(4,'Zadanie 4','Opis zadania 4, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 4',1,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(5,'Zadanie 5','Opis zadania 5, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 5',4,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(6,'Zadanie 6','Opis zadania 6, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 6',2,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(7,'Zadanie 7','Opis zadania 7, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 7',1,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(8,'Zadanie 8','Opis zadania 8, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 8',3,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(9,'Zadanie 9','Opis zadania 9, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 9',1,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(10,'Zadanie 10','Opis zadania 10, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 0',1,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(11,'Zadanie 11','Opis zadania 11, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 1',4,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(12,'Zadanie 12','Opis zadania 12, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 2',2,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(13,'Zadanie 13','Opis zadania 13, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 3',1,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(14,'Zadanie 14','Opis zadania 14, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 4',3,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(15,'Zadanie 15','Opis zadania 15, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 5',4,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(16,'Zadanie 16','Opis zadania 16, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 6',4,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(17,'Zadanie 17','Opis zadania 17, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 7',1,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(18,'Zadanie 18','Opis zadania 18, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 8',1,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(19,'Zadanie 19','Opis zadania 19, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 9',2,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(20,'Zadanie 20','Opis zadania 20, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 0',3,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(21,'Zadanie 21','Opis zadania 21, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 1',1,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(22,'Zadanie 22','Opis zadania 22, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 2',1,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(23,'Zadanie 23','Opis zadania 23, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 3',2,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(24,'Zadanie 24','Opis zadania 24, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 4',3,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(25,'Zadanie 25','Opis zadania 25, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 5',1,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(26,'Zadanie 26','Opis zadania 26, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 6',4,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(27,'Zadanie 27','Opis zadania 27, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 7',4,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(28,'Zadanie 28','Opis zadania 28, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 8',3,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(29,'Zadanie 29','Opis zadania 29, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 9',4,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(30,'Zadanie 30','Opis zadania 30, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 0',2,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(31,'Zadanie 31','Opis zadania 31, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 1',1,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(32,'Zadanie 32','Opis zadania 32, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 2',3,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(33,'Zadanie 33','Opis zadania 33, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 3',2,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(34,'Zadanie 34','Opis zadania 34, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 4',1,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(35,'Zadanie 35','Opis zadania 35, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 5',2,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(36,'Zadanie 36','Opis zadania 36, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 6',3,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(37,'Zadanie 37','Opis zadania 37, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 7',2,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(38,'Zadanie 38','Opis zadania 38, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 8',2,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(39,'Zadanie 39','Opis zadania 39, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 9',3,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(40,'Zadanie 40','Opis zadania 40, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 0',2,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(41,'Zadanie 41','Opis zadania 41, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 1',4,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(42,'Zadanie 42','Opis zadania 42, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 2',2,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(43,'Zadanie 43','Opis zadania 43, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 3',3,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(44,'Zadanie 44','Opis zadania 44, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 4',1,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(45,'Zadanie 45','Opis zadania 45, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 5',2,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(46,'Zadanie 46','Opis zadania 46, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 6',2,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(47,'Zadanie 47','Opis zadania 47, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 7',4,'path',NULL,'text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(48,'Zadanie 48','Opis zadania 48, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 8',4,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(49,'Zadanie 49','Opis zadania 49, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 9',3,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(50,'Zadanie 50','Opis zadania 50, skup się na sobie i spróbuj wykonać to ćwiczenie uważnie.','Kategoria 0',4,'path',NULL,'checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(51,'Codzienne zadanie 1','To jest opis codziennego zadania numer 1. Wykonaj je uważnie.','DailyKategoria 0',2,'daily','2025-03-29','text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(52,'Codzienne zadanie 2','To jest opis codziennego zadania numer 2. Wykonaj je uważnie.','DailyKategoria 1',3,'daily','2025-03-30','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(53,'Codzienne zadanie 3','To jest opis codziennego zadania numer 3. Wykonaj je uważnie.','DailyKategoria 2',3,'daily','2025-03-31','text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(54,'Codzienne zadanie 4','To jest opis codziennego zadania numer 4. Wykonaj je uważnie.','DailyKategoria 3',1,'daily','2025-04-01','text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(55,'Codzienne zadanie 5','To jest opis codziennego zadania numer 5. Wykonaj je uważnie.','DailyKategoria 4',2,'daily','2025-04-02','text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(56,'Codzienne zadanie 6','To jest opis codziennego zadania numer 6. Wykonaj je uważnie.','DailyKategoria 0',4,'daily','2025-04-03','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(57,'Codzienne zadanie 7','To jest opis codziennego zadania numer 7. Wykonaj je uważnie.','DailyKategoria 1',4,'daily','2025-04-04','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(58,'Codzienne zadanie 8','To jest opis codziennego zadania numer 8. Wykonaj je uważnie.','DailyKategoria 2',1,'daily','2025-04-05','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(59,'Codzienne zadanie 9','To jest opis codziennego zadania numer 9. Wykonaj je uważnie.','DailyKategoria 3',3,'daily','2025-04-06','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(60,'Codzienne zadanie 10','To jest opis codziennego zadania numer 10. Wykonaj je uważnie.','DailyKategoria 4',2,'daily','2025-04-07','text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(61,'Codzienne zadanie 11','To jest opis codziennego zadania numer 11. Wykonaj je uważnie.','DailyKategoria 0',1,'daily','2025-04-08','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(62,'Codzienne zadanie 12','To jest opis codziennego zadania numer 12. Wykonaj je uważnie.','DailyKategoria 1',1,'daily','2025-04-09','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(63,'Codzienne zadanie 13','To jest opis codziennego zadania numer 13. Wykonaj je uważnie.','DailyKategoria 2',4,'daily','2025-04-10','text','2025-04-05 19:13:02','2025-04-05 19:13:02'),(64,'Codzienne zadanie 14','To jest opis codziennego zadania numer 14. Wykonaj je uważnie.','DailyKategoria 3',2,'daily','2025-04-11','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(65,'Codzienne zadanie 15','To jest opis codziennego zadania numer 15. Wykonaj je uważnie.','DailyKategoria 4',3,'daily','2025-04-12','checkbox','2025-04-05 19:13:02','2025-04-05 19:13:02'),(66,'Codzienne zadanie 16','To jest opis codziennego zadania numer 1. Wykonaj je uważnie.','DailyKategoria 0',2,'daily','2025-04-18','text','2025-04-18 19:13:32','2025-04-18 19:13:32'),(67,'Codzienne zadanie 17','To jest opis codziennego zadania numer 2. Wykonaj je uważnie.','DailyKategoria 1',3,'daily','2025-04-19','checkbox','2025-04-18 19:13:32','2025-04-18 19:13:32'),(68,'Codzienne zadanie 18','To jest opis codziennego zadania numer 3. Wykonaj je uważnie.','DailyKategoria 2',3,'daily','2025-04-20','text','2025-04-18 19:13:32','2025-04-18 19:13:32'),(69,'Codzienne zadanie 17','To jest opis codziennego zadania numer 1. Wykonaj je uważnie.','DailyKategoria 0',2,'daily','2025-04-17','text','2025-04-18 19:23:05','2025-04-18 19:23:05'),(70,'Codzienne zadanie 20','To jest opis codziennego zadania numer 2. Wykonaj je uważnie.','DailyKategoria 1',3,'daily','2025-04-16','checkbox','2025-04-18 19:23:05','2025-04-18 19:23:05'),(71,'Codzienne zadanie 21','To jest opis codziennego zadania numer 3. Wykonaj je uważnie.','DailyKategoria 2',3,'daily','2025-04-15','text','2025-04-18 19:23:05','2025-04-18 19:23:05'),(72,'Codzienne zadanie 20','To jest opis codziennego zadania numer 2. Wykonaj je uważnie.','DailyKategoria 1',3,'daily','2025-04-14','checkbox','2025-04-18 19:24:00','2025-04-18 19:24:00'),(73,'Codzienne zadanie 21','To jest opis codziennego zadania numer 3. Wykonaj je uważnie.','DailyKategoria 2',3,'daily','2025-04-13','text','2025-04-18 19:24:00','2025-04-18 19:24:00'),(74,'Codzienne zadanie 25','To jest opis codziennego zadania numer 25. Wykonaj je uważnie.','DailyKategoria 4',2,'daily','2025-04-25','text','2025-04-30 18:33:03','2025-04-30 18:33:03'),(75,'Codzienne zadanie 26','To jest opis codziennego zadania numer 26. Wykonaj je uważnie.','DailyKategoria 0',1,'daily','2025-04-26','checkbox','2025-04-30 18:33:03','2025-04-30 18:33:03'),(76,'Codzienne zadanie 27','To jest opis codziennego zadania numer 27. Wykonaj je uważnie.','DailyKategoria 1',1,'daily','2025-04-27','checkbox','2025-04-30 18:33:03','2025-04-30 18:33:03'),(77,'Codzienne zadanie 28','To jest opis codziennego zadania numer 28. Wykonaj je uważnie.','DailyKategoria 2',4,'daily','2025-04-28','text','2025-04-30 18:33:03','2025-04-30 18:33:03'),(78,'Codzienne zadanie 29','To jest opis codziennego zadania numer 29. Wykonaj je uważnie.','DailyKategoria 3',2,'daily','2025-04-29','checkbox','2025-04-30 18:33:03','2025-04-30 18:33:03'),(79,'Codzienne zadanie 30','To jest opis codziennego zadania numer 30. Wykonaj je uważnie.','DailyKategoria 4',3,'daily','2025-04-30','checkbox','2025-04-30 18:33:03','2025-04-30 18:33:03');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_paths`
--

DROP TABLE IF EXISTS `user_paths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_paths` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `path_id` int NOT NULL,
  `started_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `path_id` (`path_id`),
  CONSTRAINT `user_paths_ibfk_1` FOREIGN KEY (`path_id`) REFERENCES `paths` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_paths`
--

LOCK TABLES `user_paths` WRITE;
/*!40000 ALTER TABLE `user_paths` DISABLE KEYS */;
INSERT INTO `user_paths` VALUES (1,1,2,'2025-03-01 09:00:00',NULL,'2025-04-05 19:14:26'),(2,2,3,'2025-02-10 08:30:00','2025-03-01 11:00:00','2025-04-05 19:14:26'),(3,1,1,'2025-03-03 07:45:00','2025-03-08 19:00:00','2025-04-05 19:14:26'),(4,3,5,'2025-03-15 13:00:00',NULL,'2025-04-05 19:14:26'),(9,6,1,'2025-04-06 20:21:25',NULL,'2025-04-06 20:21:25'),(15,6,8,'2025-04-15 19:33:34',NULL,'2025-04-15 19:33:34'),(16,6,5,'2025-04-18 17:30:05',NULL,'2025-04-18 17:30:05');
/*!40000 ALTER TABLE `user_paths` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_task_answers`
--

DROP TABLE IF EXISTS `user_task_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_task_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `task_id` int NOT NULL,
  `text_answer` text,
  `checkbox_answer` tinyint(1) DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `answered_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `task_id` (`task_id`),
  CONSTRAINT `user_task_answers_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_task_answers_chk_1` CHECK ((`status` in (_utf8mb4'in_progress',_utf8mb4'completed')))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_task_answers`
--

LOCK TABLES `user_task_answers` WRITE;
/*!40000 ALTER TABLE `user_task_answers` DISABLE KEYS */;
INSERT INTO `user_task_answers` VALUES (1,1,3,NULL,1,'completed','2025-04-05 19:14:26'),(2,1,5,'Czułem się dziś spokojny i zrelaksowany.',NULL,'completed','2025-04-05 19:14:26'),(3,2,10,NULL,0,'in_progress','2025-04-05 19:14:26'),(4,3,12,'Dzisiaj byłem wdzięczny za rodzinę i dobrą kawę.',NULL,'completed','2025-04-05 19:14:26'),(5,1,16,'Poświęciłam 15 minut na spacer, słuchałam śpiewu ptaków.',NULL,'completed','2025-04-05 19:14:26'),(6,6,10,NULL,1,'completed','2025-04-06 19:20:52'),(7,6,16,NULL,1,'completed','2025-04-05 21:03:03'),(8,6,34,'',NULL,'in_progress','2025-04-05 21:02:02'),(9,6,28,NULL,0,'in_progress','2025-04-14 18:41:47'),(10,6,8,NULL,1,'completed','2025-04-05 21:12:44'),(11,6,47,'',NULL,'in_progress','2025-04-05 21:37:18'),(12,6,27,NULL,0,'in_progress','2025-04-06 20:58:41'),(13,6,31,'Jaki tekst',NULL,'completed','2025-04-06 20:58:26'),(14,6,62,NULL,1,'completed','2025-04-10 23:57:25'),(15,6,63,NULL,1,'completed','2025-04-12 15:25:27'),(16,6,64,NULL,1,'completed','2025-04-12 15:01:59'),(17,6,65,NULL,0,'in_progress','2025-04-12 15:00:12'),(18,6,9,NULL,1,'completed','2025-04-14 18:41:42'),(19,6,70,NULL,0,'in_progress','2025-04-22 19:23:04'),(20,6,69,'',NULL,'in_progress','2025-04-22 19:23:20'),(21,6,15,'cos',NULL,'completed','2025-04-18 17:29:27'),(22,6,66,'tekst',NULL,'completed','2025-04-18 17:30:38'),(23,6,67,NULL,1,'completed','2025-04-20 14:57:55'),(24,6,68,'Jaki odpowiedz',NULL,'completed','2025-04-22 19:23:38'),(25,6,79,NULL,1,'completed','2025-04-30 16:33:16'),(26,6,78,NULL,1,'completed','2025-04-30 16:33:21');
/*!40000 ALTER TABLE `user_task_answers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-03  2:29:19
