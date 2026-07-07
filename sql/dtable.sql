
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `row_id` varchar(36) NOT NULL,
  `op_user` varchar(255) NOT NULL,
  `op_type` varchar(128) NOT NULL,
  `op_time` datetime NOT NULL,
  `detail` text NOT NULL,
  `op_app` varchar(255) DEFAULT NULL,
  `row_count` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `ix_activities_op_time_dtable_uuid` (`op_time`,`dtable_uuid`),
  KEY `ix_activities_op_time` (`op_time`),
  KEY `ix_activities_dtable_uuid` (`dtable_uuid`),
  KEY `ix_activities_row_id` (`row_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_log_adminlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `operation` varchar(255) NOT NULL,
  `detail` longtext NOT NULL,
  `datetime` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_log_adminlog_email_7213c993` (`email`),
  KEY `admin_log_adminlog_operation_4bad7bd1` (`operation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `admin_log_adminlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_log_adminlog` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api2_token` (
  `key` varchar(40) NOT NULL,
  `user` varchar(255) NOT NULL,
  `created` datetime(6) NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `api2_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `api2_token` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api2_tokenv2` (
  `key` varchar(40) NOT NULL,
  `user` varchar(255) NOT NULL,
  `platform` varchar(32) NOT NULL,
  `device_id` varchar(40) NOT NULL,
  `device_name` varchar(40) NOT NULL,
  `platform_version` varchar(16) NOT NULL,
  `client_version` varchar(16) NOT NULL,
  `last_accessed` datetime(6) NOT NULL,
  `last_login_ip` char(39) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `wiped_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `api2_tokenv2_user_platform_device_id_37005c24_uniq` (`user`,`platform`,`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `api2_tokenv2` DISABLE KEYS */;
/*!40000 ALTER TABLE `api2_tokenv2` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add content type',1,'add_contenttype'),(2,'Can change content type',1,'change_contenttype'),(3,'Can delete content type',1,'delete_contenttype'),(4,'Can change config',2,'change_config'),(5,'Can add session',3,'add_session'),(6,'Can change session',3,'change_session'),(7,'Can delete session',3,'delete_session'),(8,'Can add commands last check',4,'add_commandslastcheck'),(9,'Can change commands last check',4,'change_commandslastcheck'),(10,'Can delete commands last check',4,'delete_commandslastcheck'),(11,'Can add social auth user',5,'add_socialauthuser'),(12,'Can change social auth user',5,'change_socialauthuser'),(13,'Can delete social auth user',5,'delete_socialauthuser'),(14,'Can add user last login',6,'add_userlastlogin'),(15,'Can change user last login',6,'change_userlastlogin'),(16,'Can delete user last login',6,'delete_userlastlogin'),(17,'Can add permission',7,'add_permission'),(18,'Can change permission',7,'change_permission'),(19,'Can delete permission',7,'delete_permission'),(20,'Can add group',8,'add_group'),(21,'Can change group',8,'change_group'),(22,'Can delete group',8,'delete_group'),(23,'Can add user',9,'add_user'),(24,'Can change user',9,'change_user'),(25,'Can delete user',9,'delete_user'),(26,'Can add captcha store',10,'add_captchastore'),(27,'Can change captcha store',10,'change_captchastore'),(28,'Can delete captcha store',10,'delete_captchastore'),(29,'Can add constance',11,'add_constance'),(30,'Can change constance',11,'change_constance'),(31,'Can delete constance',11,'delete_constance'),(32,'Can add Attachment',12,'add_attachment'),(33,'Can change Attachment',12,'change_attachment'),(34,'Can delete Attachment',12,'delete_attachment'),(35,'Can add Email',13,'add_email'),(36,'Can change Email',13,'change_email'),(37,'Can delete Email',13,'delete_email'),(38,'Can add Email Template',14,'add_emailtemplate'),(39,'Can change Email Template',14,'change_emailtemplate'),(40,'Can delete Email Template',14,'delete_emailtemplate'),(41,'Can add Log',15,'add_log'),(42,'Can change Log',15,'change_log'),(43,'Can delete Log',15,'delete_log'),(44,'Can add Terms and Conditions',16,'add_termsandconditions'),(45,'Can change Terms and Conditions',16,'change_termsandconditions'),(46,'Can delete Terms and Conditions',16,'delete_termsandconditions'),(47,'Can add User Terms and Conditions',17,'add_usertermsandconditions'),(48,'Can change User Terms and Conditions',17,'change_usertermsandconditions'),(49,'Can delete User Terms and Conditions',17,'delete_usertermsandconditions'),(50,'Can add token',18,'add_token'),(51,'Can change token',18,'change_token'),(52,'Can delete token',18,'delete_token'),(53,'Can add token v2',19,'add_tokenv2'),(54,'Can change token v2',19,'change_tokenv2'),(55,'Can delete token v2',19,'delete_tokenv2'),(56,'Can add avatar',20,'add_avatar'),(57,'Can change avatar',20,'change_avatar'),(58,'Can delete avatar',20,'delete_avatar'),(59,'Can add group avatar',21,'add_groupavatar'),(60,'Can change group avatar',21,'change_groupavatar'),(61,'Can delete group avatar',21,'delete_groupavatar'),(62,'Can add institution',22,'add_institution'),(63,'Can change institution',22,'change_institution'),(64,'Can delete institution',22,'delete_institution'),(65,'Can add institution admin',23,'add_institutionadmin'),(66,'Can change institution admin',23,'change_institutionadmin'),(67,'Can delete institution admin',23,'delete_institutionadmin'),(68,'Can add institution quota',24,'add_institutionquota'),(69,'Can change institution quota',24,'change_institutionquota'),(70,'Can delete institution quota',24,'delete_institutionquota'),(71,'Can add invitation',25,'add_invitation'),(72,'Can change invitation',25,'change_invitation'),(73,'Can delete invitation',25,'delete_invitation'),(74,'Can add notification',26,'add_notification'),(75,'Can change notification',26,'change_notification'),(76,'Can delete notification',26,'delete_notification'),(77,'Can add user notification',27,'add_usernotification'),(78,'Can change user notification',27,'change_usernotification'),(79,'Can delete user notification',27,'delete_usernotification'),(80,'Can add user options',28,'add_useroptions'),(81,'Can change user options',28,'change_useroptions'),(82,'Can delete user options',28,'delete_useroptions'),(83,'Can add profile',29,'add_profile'),(84,'Can change profile',29,'change_profile'),(85,'Can delete profile',29,'delete_profile'),(86,'Can add admin log',30,'add_adminlog'),(87,'Can change admin log',30,'change_adminlog'),(88,'Can delete admin log',30,'delete_adminlog'),(89,'Can add phone device',31,'add_phonedevice'),(90,'Can change phone device',31,'change_phonedevice'),(91,'Can delete phone device',31,'delete_phonedevice'),(92,'Can add static device',32,'add_staticdevice'),(93,'Can change static device',32,'change_staticdevice'),(94,'Can delete static device',32,'delete_staticdevice'),(95,'Can add static token',33,'add_statictoken'),(96,'Can change static token',33,'change_statictoken'),(97,'Can delete static token',33,'delete_statictoken'),(98,'Can add TOTP device',34,'add_totpdevice'),(99,'Can change TOTP device',34,'change_totpdevice'),(100,'Can delete TOTP device',34,'delete_totpdevice'),(101,'Can add admin role',35,'add_adminrole'),(102,'Can change admin role',35,'change_adminrole'),(103,'Can delete admin role',35,'delete_adminrole'),(104,'Can add d tables',36,'add_dtables'),(105,'Can change d tables',36,'change_dtables'),(106,'Can delete d tables',36,'delete_dtables'),(107,'Can add workspaces',37,'add_workspaces'),(108,'Can change workspaces',37,'change_workspaces'),(109,'Can delete workspaces',37,'delete_workspaces'),(110,'Can add d table share',38,'add_dtableshare'),(111,'Can change d table share',38,'change_dtableshare'),(112,'Can delete d table share',38,'delete_dtableshare'),(113,'Can add d table api token',39,'add_dtableapitoken'),(114,'Can change d table api token',39,'change_dtableapitoken'),(115,'Can delete d table api token',39,'delete_dtableapitoken'),(116,'Can add d table share links',40,'add_dtablesharelinks'),(117,'Can change d table share links',40,'change_dtablesharelinks'),(118,'Can delete d table share links',40,'delete_dtablesharelinks'),(119,'Can add d table form links',41,'add_dtableformlinks'),(120,'Can change d table form links',41,'change_dtableformlinks'),(121,'Can delete d table form links',41,'delete_dtableformlinks'),(122,'Can add d table row shares',42,'add_dtablerowshares'),(123,'Can change d table row shares',42,'change_dtablerowshares'),(124,'Can delete d table row shares',42,'delete_dtablerowshares'),(125,'Can add org member quota',43,'add_orgmemberquota'),(126,'Can change org member quota',43,'change_orgmemberquota'),(127,'Can delete org member quota',43,'delete_orgmemberquota'),(128,'Can add org settings',44,'add_orgsettings'),(129,'Can change org settings',44,'change_orgsettings'),(130,'Can delete org settings',44,'delete_orgsettings'),(131,'Can add registration profile',45,'add_registrationprofile'),(132,'Can change registration profile',45,'change_registrationprofile'),(133,'Can delete registration profile',45,'delete_registrationprofile');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `avatar_avatar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `emailuser` varchar(255) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `avatar` varchar(1024) NOT NULL,
  `date_uploaded` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_emailuser` (`emailuser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `avatar_avatar` DISABLE KEYS */;
/*!40000 ALTER TABLE `avatar_avatar` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `avatar_groupavatar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(255) NOT NULL,
  `avatar` varchar(1024) NOT NULL,
  `date_uploaded` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `avatar_groupavatar` DISABLE KEYS */;
/*!40000 ALTER TABLE `avatar_groupavatar` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `base_commandslastcheck` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command_type` varchar(100) NOT NULL,
  `last_check` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `base_commandslastcheck` DISABLE KEYS */;
/*!40000 ALTER TABLE `base_commandslastcheck` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `base_userlastlogin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `last_login` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `base_userlastlogin_username_270de06f` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `base_userlastlogin` DISABLE KEYS */;
/*!40000 ALTER TABLE `base_userlastlogin` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `captcha_captchastore` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge` varchar(32) NOT NULL,
  `response` varchar(32) NOT NULL,
  `hashkey` varchar(40) NOT NULL,
  `expiration` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hashkey` (`hashkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `captcha_captchastore` DISABLE KEYS */;
/*!40000 ALTER TABLE `captcha_captchastore` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `constance_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `constance_key` varchar(255) NOT NULL,
  `value` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `constance_key` (`constance_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `constance_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `constance_config` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (30,'admin_log','adminlog'),(18,'api2','token'),(19,'api2','tokenv2'),(8,'auth','group'),(7,'auth','permission'),(9,'auth','user'),(20,'avatar','avatar'),(21,'avatar','groupavatar'),(4,'base','commandslastcheck'),(5,'base','socialauthuser'),(6,'base','userlastlogin'),(10,'captcha','captchastore'),(2,'constance','config'),(1,'contenttypes','contenttype'),(11,'database','constance'),(39,'dtable','dtableapitoken'),(41,'dtable','dtableformlinks'),(42,'dtable','dtablerowshares'),(36,'dtable','dtables'),(38,'dtable','dtableshare'),(40,'dtable','dtablesharelinks'),(37,'dtable','workspaces'),(22,'institutions','institution'),(23,'institutions','institutionadmin'),(24,'institutions','institutionquota'),(25,'invitations','invitation'),(26,'notifications','notification'),(27,'notifications','usernotification'),(28,'options','useroptions'),(43,'organizations','orgmemberquota'),(44,'organizations','orgsettings'),(12,'post_office','attachment'),(13,'post_office','email'),(14,'post_office','emailtemplate'),(15,'post_office','log'),(29,'profile','profile'),(45,'registration','registrationprofile'),(35,'role_permissions','adminrole'),(3,'sessions','session'),(16,'termsandconditions','termsandconditions'),(17,'termsandconditions','usertermsandconditions'),(31,'two_factor','phonedevice'),(32,'two_factor','staticdevice'),(33,'two_factor','statictoken'),(34,'two_factor','totpdevice');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'admin_log','0001_initial','2019-11-08 06:35:53.219245'),(2,'api2','0001_initial','2019-11-08 06:35:53.323473'),(3,'contenttypes','0001_initial','2019-11-08 06:35:53.386478'),(4,'contenttypes','0002_remove_content_type_name','2019-11-08 06:35:53.465613'),(5,'auth','0001_initial','2019-11-08 06:35:54.046100'),(6,'auth','0002_alter_permission_name_max_length','2019-11-08 06:35:54.104176'),(7,'auth','0003_alter_user_email_max_length','2019-11-08 06:35:54.171273'),(8,'auth','0004_alter_user_username_opts','2019-11-08 06:35:54.184287'),(9,'auth','0005_alter_user_last_login_null','2019-11-08 06:35:54.229620'),(10,'auth','0006_require_contenttypes_0002','2019-11-08 06:35:54.238282'),(11,'auth','0007_alter_validators_add_error_messages','2019-11-08 06:35:54.250623'),(12,'auth','0008_alter_user_username_max_length','2019-11-08 06:35:54.310005'),(13,'avatar','0001_initial','2019-11-08 06:35:54.386320'),(14,'base','0001_initial','2019-11-08 06:35:54.537089'),(15,'captcha','0001_initial','2019-11-08 06:35:54.577019'),(16,'database','0001_initial','2019-11-08 06:35:54.618613'),(17,'database','0002_auto_20190129_2304','2019-11-08 06:35:54.667405'),(18,'dtable','0001_initial','2019-11-08 06:35:54.851437'),(19,'dtable','0002_auto','2019-11-08 06:35:54.994007'),(20,'dtable','0003_auto','2019-11-08 06:35:55.133840'),(21,'dtable','0004_sharedtablelink','2019-11-08 06:35:55.257235'),(22,'dtable','0005_dtableformlinks','2019-11-08 06:35:55.372744'),(23,'dtable','0006_dtablerowshares','2019-11-08 06:35:55.481031'),(24,'dtable','0007_workspaces_org_id','2019-11-08 06:35:55.510935'),(25,'group','0001_initial','2019-11-08 06:35:55.766627'),(26,'group','0002_auto_20191108_0635','2019-11-08 06:35:55.908549'),(27,'institutions','0001_initial','2019-11-08 06:35:56.029319'),(28,'institutions','0002_institutionquota','2019-11-08 06:35:56.124189'),(29,'institutions','0003_auto_20180426_0710','2019-11-08 06:35:56.176677'),(30,'invitations','0001_initial','2019-11-08 06:35:56.251118'),(31,'invitations','0002_invitation_invite_type','2019-11-08 06:35:56.279339'),(32,'invitations','0003_auto_20160510_1703','2019-11-08 06:35:56.322600'),(33,'invitations','0004_auto_20160629_1610','2019-11-08 06:35:56.371715'),(34,'invitations','0005_auto_20160629_1614','2019-11-08 06:35:56.396334'),(35,'notifications','0001_initial','2019-11-08 06:35:56.513296'),(36,'notifications','0002_auto_20180426_0710','2019-11-08 06:35:56.539902'),(37,'notifications','0003_auto_20181115_0825','2019-11-08 06:35:56.585483'),(38,'notifications','0004_auto_20191108_0635','2019-11-08 06:35:56.598223'),(39,'options','0001_initial','2019-11-08 06:35:56.664302'),(40,'options','0002_auto_20181107_0811','2019-11-08 06:35:56.690269'),(41,'organizations','0001_initial','2019-11-08 06:35:56.751245'),(42,'organizations','0002_orgsettings','2019-11-08 06:35:56.807661'),(43,'organizations','0003_auto_20190116_0323','2019-11-08 06:35:56.847965'),(44,'post_office','0001_initial','2019-11-08 06:35:57.345188'),(45,'post_office','0002_add_i18n_and_backend_alias','2019-11-08 06:35:57.559446'),(46,'post_office','0003_longer_subject','2019-11-08 06:35:57.595204'),(47,'post_office','0004_auto_20160607_0901','2019-11-08 06:35:58.017340'),(48,'post_office','0005_auto_20170515_0013','2019-11-08 06:35:58.065744'),(49,'post_office','0006_attachment_mimetype','2019-11-08 06:35:58.143677'),(50,'post_office','0007_auto_20170731_1342','2019-11-08 06:35:58.161135'),(51,'post_office','0008_attachment_headers','2019-11-08 06:35:58.197639'),(52,'profile','0001_initial','2019-11-08 06:35:58.308140'),(53,'profile','0002_auto_20190122_0225','2019-11-08 06:35:58.358521'),(54,'profile','0003_auto_20191108_0635','2019-11-08 06:35:58.374621'),(55,'registration','0001_initial','2019-11-08 06:35:58.425348'),(56,'role_permissions','0001_initial','2019-11-08 06:35:58.474448'),(57,'sessions','0001_initial','2019-11-08 06:35:58.548033'),(58,'termsandconditions','0001_initial','2019-11-08 06:35:58.726030'),(59,'termsandconditions','0002_auto_20191108_0635','2019-11-08 06:35:58.775103'),(60,'two_factor','0001_initial','2019-11-08 06:35:59.039964');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_api_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(255) NOT NULL,
  `token` varchar(40) NOT NULL,
  `generated_at` datetime(6) NOT NULL,
  `generated_by` varchar(255) NOT NULL,
  `last_access` datetime(6) NOT NULL,
  `permission` varchar(15) NOT NULL,
  `dtable_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  UNIQUE KEY `dtable_api_token_dtable_id_app_name_8594f458_uniq` (`dtable_id`,`app_name`),
  KEY `dtable_api_token_app_name_d80e8bcc` (`app_name`),
  CONSTRAINT `dtable_api_token_dtable_id_9a955fd6_fk_dtables_id` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_api_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_api_token` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_external_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_id` int(11) NOT NULL,
  `token` varchar(100) NOT NULL,
  `creator` varchar(255) NOT NULL,
  `create_at` datetime(6) NOT NULL,
  `permission` varchar(50) NOT NULL,
  `view_cnt` int(11) DEFAULT 0,
  `is_custom` tinyint(1) DEFAULT 0,
  `password` varchar(128) DEFAULT NULL,
  `expire_date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_key` (`token`),
  KEY `dtable_id_key` (`dtable_id`),
  CONSTRAINT `dtable_external_link_ibf83fk_1` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_external_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_external_link` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `form_id` varchar(36) NOT NULL,
  `form_config` longtext DEFAULT NULL,
  `token` varchar(36) NOT NULL,
  `share_type` varchar(20) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `submit_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `dtable_forms_username_c507c6cc` (`username`),
  KEY `dtable_forms_workspace_id_2520d284` (`workspace_id`),
  KEY `dtable_forms_dtable_uuid_a4dbea23` (`dtable_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `dtable_forms` CHANGE `form_config` `form_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL;

/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_forms` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_forms` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_form_share` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `form_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_form_share_form_id_group_id_890fd26b_uniq` (`form_id`,`group_id`),
  KEY `dtable_form_share_group_id_68ef49a9` (`group_id`),
  CONSTRAINT `dtable_form_share_form_id_e3565e7d_fk_dtable_forms_id` FOREIGN KEY (`form_id`) REFERENCES `dtable_forms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_form_share` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_form_share` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_row_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(255) NOT NULL,
  `comment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `dtable_uuid` char(32) NOT NULL,
  `row_id` char(36) NOT NULL DEFAULT '',
  `detail` longtext DEFAULT NULL,
  `resolved` tinyint(1) NOT NULL DEFAULT 0,
  `comment_from` varchar(20) NOT NULL DEFAULT 'base',
  PRIMARY KEY (`id`),
  KEY `dtable_uuid_key` (`dtable_uuid`),
  KEY `row_id_key` (`row_id`),
  KEY `created_at_y5g3o0l1_key` (`created_at`),
  KEY `idx_base_comment_from` (`comment_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `dtable_row_comments` CHANGE  `comment` `comment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;

/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_row_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_row_comments` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_row_shares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `table_id` varchar(36) NOT NULL,
  `row_id` varchar(36) NOT NULL,
  `token` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `dtable_row_shares_username_e02f884b` (`username`),
  KEY `dtable_row_shares_workspace_id_5f1b5daf` (`workspace_id`),
  KEY `dtable_row_shares_dtable_uuid_ea644d62` (`dtable_uuid`),
  KEY `dtable_row_shares_row_id_5d2bbe39` (`row_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_row_shares` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_row_shares` ENABLE KEYS */;

CREATE TABLE `user_share_folders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_name_n3o847t3_uniq_key` (`username`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_share` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_user` varchar(255) NOT NULL,
  `to_user` varchar(255) NOT NULL,
  `permission` varchar(15) NOT NULL,
  `dtable_id` int(11) NOT NULL,
  `share_folder_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_share_dtable_id_to_user_1ea3dc52_uniq` (`dtable_id`,`to_user`),
  KEY `dtable_share_from_user_4f7dc15d` (`from_user`),
  KEY `dtable_share_to_user_8d62bc4b` (`to_user`),
  KEY `share_folder_id` (`share_folder_id`),
  CONSTRAINT `dtable_share_dtable_id_316d50ad_fk_dtables_id` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`),
  CONSTRAINT `dtable_share_ibfk_1` FOREIGN KEY (`share_folder_id`) REFERENCES `user_share_folders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_share` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_share` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_share_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `token` varchar(100) NOT NULL,
  `ctime` datetime(6) NOT NULL,
  `password` varchar(128) DEFAULT NULL,
  `expire_date` datetime(6) DEFAULT NULL,
  `permission` varchar(50) NOT NULL,
  `dtable_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `dtable_share_links_dtable_id_19974ba2_fk_dtables_id` (`dtable_id`),
  KEY `dtable_share_links_username_0fcbefa6` (`username`),
  KEY `dtable_share_links_permission_17ad74da` (`permission`),
  CONSTRAINT `dtable_share_links_dtable_id_19974ba2_fk_dtables_id` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_share_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_share_links` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtable_snapshot` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `dtable_name` varchar(255) NOT NULL,
  `commit_id` varchar(40) NOT NULL,
  `ctime` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_snapshot_dtable_uuid_commit_id_b16af249_uniq` (`dtable_uuid`,`commit_id`),
  KEY `dtable_snapshot_dtable_uuid_57ef9f7f` (`dtable_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtable_snapshot` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtable_snapshot` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dtables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` char(32) NOT NULL,
  `name` varchar(255) NOT NULL,
  `creator` varchar(255) NOT NULL,
  `modifier` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `delete_time` datetime(6) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `text_color` varchar(50) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `in_storage` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  UNIQUE KEY `dtables_workspace_id_name_0b89d91b_uniq` (`workspace_id`,`name`),
  KEY `dtables_deleted_n3b4o5b2_key` (`deleted`),
  KEY `dtables_created_at_e6716f4b` (`created_at`),
  KEY `updated_at_h3g4o9u6_key` (`updated_at`),
  CONSTRAINT `dtables_workspace_id_538ecbbf_fk_workspaces_id` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dtables` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtables` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operation_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(32) NOT NULL,
  `op_id` bigint(20) NOT NULL,
  `op_time` bigint(20) NOT NULL,
  `operation` longtext NOT NULL,
  `author` varchar(255) NOT NULL,
  `app` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `operation_log_op_time` (`op_time`),
  KEY `operation_log_dtable_uuid` (`dtable_uuid`),
  KEY `idx_operation_log_dtable_uuid_op_id` (`dtable_uuid`,`op_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `operation_log` CHANGE  `operation` `operation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `operation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `operation_log` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operation_checkpoint` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(32) NOT NULL,
  `op_id` bigint(20) NOT NULL,
  `op_time` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_uuid` (`dtable_uuid`),
  KEY `idx_operation_checkpoint_op_time` (`op_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `operation_checkpoint` DISABLE KEYS */;
/*!40000 ALTER TABLE `operation_checkpoint` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `institutions_institution` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `institutions_institution` DISABLE KEYS */;
/*!40000 ALTER TABLE `institutions_institution` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `institutions_institutionadmin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `institution_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `institutions_institu_institution_id_1e9bb58b_fk_instituti` (`institution_id`),
  KEY `institutions_institutionadmin_user_c71d766d` (`user`),
  CONSTRAINT `institutions_institu_institution_id_1e9bb58b_fk_instituti` FOREIGN KEY (`institution_id`) REFERENCES `institutions_institution` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `institutions_institutionadmin` DISABLE KEYS */;
/*!40000 ALTER TABLE `institutions_institutionadmin` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `institutions_institutionquota` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quota` bigint(20) NOT NULL,
  `institution_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `institutions_institu_institution_id_d23201d9_fk_instituti` (`institution_id`),
  CONSTRAINT `institutions_institu_institution_id_d23201d9_fk_instituti` FOREIGN KEY (`institution_id`) REFERENCES `institutions_institution` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `institutions_institutionquota` DISABLE KEYS */;
/*!40000 ALTER TABLE `institutions_institutionquota` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invitations_invitation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(40) NOT NULL,
  `inviter` varchar(255) NOT NULL,
  `accepter` varchar(255) NOT NULL,
  `invite_time` datetime(6) NOT NULL,
  `accept_time` datetime(6) DEFAULT NULL,
  `invite_type` varchar(20) NOT NULL,
  `expire_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `invitations_invitation_inviter_b0a7b855` (`inviter`),
  KEY `invitations_invitation_token_25a92a38` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `invitations_invitation` DISABLE KEYS */;
/*!40000 ALTER TABLE `invitations_invitation` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications_notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(512) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notification_primary_4f95ec21` (`primary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `notifications_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications_notification` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications_usernotification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to_user` varchar(255) NOT NULL,
  `msg_type` varchar(30) NOT NULL,
  `detail` longtext NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `seen` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_usernotification_to_user_6cadafa1` (`to_user`),
  KEY `notifications_usernotification_msg_type_985afd02` (`msg_type`),
  KEY `notifications_usernotification_timestamp_125067e8` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `notifications_usernotification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications_usernotification` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `options_useroptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `option_key` varchar(50) NOT NULL,
  `option_val` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `options_useroptions_email_77d5726a` (`email`),
  KEY `options_useroptions_option_key_7bf7ae4b` (`option_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `options_useroptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `options_useroptions` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organizations_orgmemberquota` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `quota` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `organizations_orgmemberquota_org_id_93dde51d` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `organizations_orgmemberquota` DISABLE KEYS */;
/*!40000 ALTER TABLE `organizations_orgmemberquota` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organizations_orgsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `role` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `organizations_orgsettings_org_id_630f6843_uniq` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `organizations_orgsettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `organizations_orgsettings` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_office_attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file` varchar(100) NOT NULL,
  `name` varchar(255) NOT NULL,
  `mimetype` varchar(255) NOT NULL,
  `headers` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `post_office_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_office_attachment` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_office_attachment_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attachment_id` int(11) NOT NULL,
  `email_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `post_office_attachment_e_attachment_id_email_id_8e046917_uniq` (`attachment_id`,`email_id`),
  KEY `post_office_attachme_email_id_96875fd9_fk_post_offi` (`email_id`),
  CONSTRAINT `post_office_attachme_attachment_id_6136fd9a_fk_post_offi` FOREIGN KEY (`attachment_id`) REFERENCES `post_office_attachment` (`id`),
  CONSTRAINT `post_office_attachme_email_id_96875fd9_fk_post_offi` FOREIGN KEY (`email_id`) REFERENCES `post_office_email` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `post_office_attachment_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_office_attachment_emails` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_office_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_email` varchar(254) NOT NULL,
  `to` longtext NOT NULL,
  `cc` longtext NOT NULL,
  `bcc` longtext NOT NULL,
  `subject` varchar(989) NOT NULL,
  `message` longtext NOT NULL,
  `html_message` longtext NOT NULL,
  `status` smallint(5) unsigned DEFAULT NULL,
  `priority` smallint(5) unsigned DEFAULT NULL,
  `created` datetime(6) NOT NULL,
  `last_updated` datetime(6) NOT NULL,
  `scheduled_time` datetime(6) DEFAULT NULL,
  `headers` longtext DEFAULT NULL,
  `context` longtext DEFAULT NULL,
  `template_id` int(11) DEFAULT NULL,
  `backend_alias` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_office_email_status_013a896c` (`status`),
  KEY `post_office_email_created_1306952f` (`created`),
  KEY `post_office_email_last_updated_0ffcec35` (`last_updated`),
  KEY `post_office_email_scheduled_time_3869ebec` (`scheduled_time`),
  KEY `post_office_email_template_id_417da7da_fk_post_offi` (`template_id`),
  CONSTRAINT `post_office_email_template_id_417da7da_fk_post_offi` FOREIGN KEY (`template_id`) REFERENCES `post_office_emailtemplate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `post_office_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_office_email` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_office_emailtemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `subject` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `html_content` longtext NOT NULL,
  `created` datetime(6) NOT NULL,
  `last_updated` datetime(6) NOT NULL,
  `default_template_id` int(11) DEFAULT NULL,
  `language` varchar(12) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `post_office_emailtemplat_name_language_default_te_4023e3e4_uniq` (`name`,`language`,`default_template_id`),
  KEY `post_office_emailtem_default_template_id_2ac2f889_fk_post_offi` (`default_template_id`),
  CONSTRAINT `post_office_emailtem_default_template_id_2ac2f889_fk_post_offi` FOREIGN KEY (`default_template_id`) REFERENCES `post_office_emailtemplate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `post_office_emailtemplate` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_office_emailtemplate` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_office_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime(6) NOT NULL,
  `status` smallint(5) unsigned NOT NULL,
  `exception_type` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `email_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_office_log_email_id_d42c8808_fk_post_office_email_id` (`email_id`),
  CONSTRAINT `post_office_log_email_id_d42c8808_fk_post_office_email_id` FOREIGN KEY (`email_id`) REFERENCES `post_office_email` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `post_office_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_office_log` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_profile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(254) NOT NULL,
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `intro` longtext NOT NULL,
  `lang_code` longtext DEFAULT NULL,
  `login_id` varchar(225) DEFAULT NULL,
  `contact_email` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_manually_set_contact_email` tinyint(1) DEFAULT 0,
  `institution` varchar(225) DEFAULT NULL,
  `list_in_address_book` tinyint(1) NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `need_show_video` tinyint(1) NOT NULL DEFAULT 0,
  `unit` longtext DEFAULT NULL,
  `sms_2fa` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user` (`user`),
  UNIQUE KEY `login_id` (`login_id`),
  UNIQUE KEY `profile_profile_contact_email_0975e4bf_uniq` (`contact_email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `profile_profile_institution_c0286bd1` (`institution`),
  KEY `profile_profile_list_in_address_book_b1009a78` (`list_in_address_book`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `profile_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `profile_profile` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `registration_registrationprofile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `emailuser_id` int(11) NOT NULL,
  `activation_key` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `registration_registrationprofile` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration_registrationprofile` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_permissions_adminrole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `role` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `role_permissions_adminrole` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_permissions_adminrole` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_auth_usersocialauth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `provider` varchar(32) NOT NULL,
  `uid` varchar(255) NOT NULL,
  `extra_data` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_usersocialauth_provider_uid_e6b5e668_uniq` (`provider`,`uid`),
  KEY `social_auth_usersocialauth_username_3f06b5cf` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `social_auth_usersocialauth` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_usersocialauth` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysadmin_extra_userloginlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `login_date` datetime(6) NOT NULL,
  `login_ip` varchar(128) NOT NULL,
  `login_success` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sysadmin_extra_userloginlog_username_5748b9e3` (`username`),
  KEY `sysadmin_extra_userloginlog_login_date_c171d790` (`login_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sysadmin_extra_userloginlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `sysadmin_extra_userloginlog` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `termsandconditions_termsandconditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(50) NOT NULL,
  `name` longtext NOT NULL,
  `version_number` decimal(6,2) NOT NULL,
  `text` longtext DEFAULT NULL,
  `info` longtext DEFAULT NULL,
  `date_active` datetime(6) DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `termsandconditions_termsandconditions_slug_489d1e9d` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `termsandconditions_termsandconditions` DISABLE KEYS */;
/*!40000 ALTER TABLE `termsandconditions_termsandconditions` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `termsandconditions_usertermsandconditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `ip_address` char(39) DEFAULT NULL,
  `date_accepted` datetime(6) NOT NULL,
  `terms_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `termsandconditions_usert_username_terms_id_a7dabb70_uniq` (`username`,`terms_id`),
  KEY `termsandconditions_u_terms_id_eacdbcc7_fk_termsandc` (`terms_id`),
  CONSTRAINT `termsandconditions_u_terms_id_eacdbcc7_fk_termsandc` FOREIGN KEY (`terms_id`) REFERENCES `termsandconditions_termsandconditions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `termsandconditions_usertermsandconditions` DISABLE KEYS */;
/*!40000 ALTER TABLE `termsandconditions_usertermsandconditions` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `two_factor_phonedevice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `name` varchar(64) NOT NULL,
  `confirmed` tinyint(1) NOT NULL,
  `number` varchar(40) NOT NULL,
  `key` varchar(40) NOT NULL,
  `method` varchar(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `two_factor_phonedevice` DISABLE KEYS */;
/*!40000 ALTER TABLE `two_factor_phonedevice` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `two_factor_staticdevice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `name` varchar(64) NOT NULL,
  `confirmed` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `two_factor_staticdevice` DISABLE KEYS */;
/*!40000 ALTER TABLE `two_factor_staticdevice` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `two_factor_statictoken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(16) NOT NULL,
  `device_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `two_factor_statictok_device_id_93095b45_fk_two_facto` (`device_id`),
  KEY `two_factor_statictoken_token_2ade1084` (`token`),
  CONSTRAINT `two_factor_statictok_device_id_93095b45_fk_two_facto` FOREIGN KEY (`device_id`) REFERENCES `two_factor_staticdevice` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `two_factor_statictoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `two_factor_statictoken` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `two_factor_totpdevice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `name` varchar(64) NOT NULL,
  `confirmed` tinyint(1) NOT NULL,
  `key` varchar(80) NOT NULL,
  `step` smallint(5) unsigned NOT NULL,
  `t0` bigint(20) NOT NULL,
  `digits` smallint(5) unsigned NOT NULL,
  `tolerance` smallint(5) unsigned NOT NULL,
  `drift` smallint(6) NOT NULL,
  `last_t` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `two_factor_totpdevice` DISABLE KEYS */;
/*!40000 ALTER TABLE `two_factor_totpdevice` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_activity_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_time_md5` varchar(32) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `timestamp` datetime NOT NULL,
  `org_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_time_md5` (`user_time_md5`),
  KEY `ix_user_activity_statistics_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `user_activity_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_activity_statistics` ENABLE KEYS */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workspaces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `owner` varchar(255) NOT NULL,
  `repo_id` varchar(36) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `org_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `delete_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `owner` (`owner`),
  UNIQUE KEY `repo_id` (`repo_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `workspaces_deleted_idx` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `workspaces` DISABLE KEYS */;
/*!40000 ALTER TABLE `workspaces` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

CREATE TABLE `dtable_plugin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dtable_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_plugin_dtable_id_60e96e09_fk_dtables_id` (`dtable_id`),
  KEY `dtable_plugin_name_244402d2` (`name`),
  CONSTRAINT `dtable_plugin_dtable_id_60e96e09_fk_dtables_id` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dtable_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `dtable_uuid` varchar(32) NOT NULL,
  `msg_type` varchar(40) NOT NULL,
  `created_at` datetime NOT NULL,
  `detail` longtext NOT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `dtable_notifications_username_dtable_uuid` (`username`, `dtable_uuid`),
  KEY `dtable_notifications_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `dtable_notifications` CHANGE  `detail` `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;


CREATE TABLE `dtable_common_dataset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `dtable_uuid` char(32) NOT NULL,
  `table_id` varchar(36) NOT NULL,
  `view_id` varchar(36) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `creator` varchar(255) NOT NULL,
  `dataset_name` varchar(255) NOT NULL,
  `is_valid` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_common_dataset_org_id_dtable_uuid_table_7a02fe88_uniq` (`org_id`,`dtable_uuid`,`table_id`,`view_id`),
  UNIQUE KEY `dtable_common_dataset_org_id_dataset_name_f98dea4a_uniq` (`org_id`,`dataset_name`),
  KEY `dtable_common_dataset_dtable_uuid_780a1b12` (`dtable_uuid`),
  KEY `dtable_common_dataset_creator_6dc5b17d` (`creator`),
  KEY `dtable_common_dataset_dataset_name_6cfd12e6` (`dataset_name`),
  KEY `group_id_h4y7t5r9_key` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_common_dataset_group_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `dataset_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_common_datase_dataset_id_c7dfe110_fk_dtable_co` (`dataset_id`),
  KEY `dtable_common_dataset_group_access_group_id_1598fb59` (`group_id`),
  CONSTRAINT `dtable_common_datase_dataset_id_c7dfe110_fk_dtable_co` FOREIGN KEY (`dataset_id`) REFERENCES `dtable_common_dataset` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_group_share` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission` varchar(15) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_group_share_dtable_id_group_id_p0o3n6x7_uniq` (`dtable_id`,`group_id`),
  KEY `dtable_group_share_dtable_id_k3n4n5y2` (`dtable_id`),
  KEY `dtable_group_share_group_id_a7q9o2p3` (`group_id`),
  CONSTRAINT `dtable_group_share_dtable_id_nao83b6s_fk_dtables_id` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_starred_dtables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_starred_dtables_email_dtable_uuid_n8s7b3s0_uniq` (`email`,`dtable_uuid`),
  KEY `user_starred_dtables_dtable_uuid_n3s8l4n8` (`dtable_uuid`),
  KEY `user_starred_dtables_email_n9x0l3n8` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_notification_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `run_condition` varchar(32) NOT NULL,
  `trigger` longtext NOT NULL,
  `action` longtext NOT NULL,
  `creator` varchar(255) NOT NULL,
  `ctime` datetime(6) NOT NULL,
  `last_trigger_time` datetime(6) DEFAULT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `is_valid` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `dtable_uuid` (`dtable_uuid`),
  KEY `ctime_k3x7o2p4_key` (`ctime`),
  KEY `last_trigger_time_b3n4m2l1_key` (`last_trigger_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_rows_count` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `rows_count` int(11) DEFAULT 0,
  `rows_count_update_at` datetime(6) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `org_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_uuid_n3v0m5n8_unique_key` (`dtable_uuid`),
  KEY `owner_k3h7x8j1_key` (`owner`),
  KEY `org_id_n4o9y6g8_key` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `org_rows_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `rows_count` int(11) DEFAULT 0,
  `rows_count_update_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id_n3x0l1x0_unique_key` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_rows_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `rows_count` int(11) DEFAULT 0,
  `rows_count_update_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_n3x0l1x0_unique_key` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_common_dataset_sync` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dst_dtable_uuid` char(32) NOT NULL,
  `dst_table_id` varchar(36) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `creator` varchar(255) NOT NULL,
  `last_sync_time` datetime(6) NOT NULL,
  `dataset_id` int(11) NOT NULL,
  `src_version` int(11) NOT NULL,
  `is_sync_periodically` tinyint(1) DEFAULT 0,
  `is_valid` tinyint(1) DEFAULT 1,
  `sync_interval` varchar(20) DEFAULT 'per_day',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_common_dataset_sy_dst_dtable_uuid_dst_tabl_9e70666b_uniq` (`dst_dtable_uuid`,`dst_table_id`),
  KEY `dtable_common_datase_dataset_id_b1473f04_fk_dtable_co` (`dataset_id`),
  KEY `dtable_common_dataset_sync_dst_dtable_uuid_8d8d4f16` (`dst_dtable_uuid`),
  KEY `dtable_common_dataset_sync_dst_table_id_54dc1cc3` (`dst_table_id`),
  KEY `dtable_common_dataset_sync_creator_a099c047` (`creator`),
  KEY `dtable_common_dataset_last_sync_time` (`last_sync_time`),
  KEY `is_sync_periodically_last_sync_time_j3j2p0_key` (`is_sync_periodically`,`last_sync_time`),
  CONSTRAINT `dtable_common_datase_dataset_id_b1473f04_fk_dtable_co` FOREIGN KEY (`dataset_id`) REFERENCES `dtable_common_dataset` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_view_user_share` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_user` varchar(255) NOT NULL,
  `to_user` varchar(255) NOT NULL,
  `permission` varchar(15) NOT NULL,
  `table_id` varchar(36) NOT NULL,
  `view_id` varchar(36) NOT NULL,
  `dtable_id` int(11) NOT NULL,
  `shared_name` varchar(255) DEFAULT NULL,
  `share_folder_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_view_user_share_dtable_id_to_user_table__7427273d_uniq` (`dtable_id`,`to_user`,`table_id`,`view_id`),
  KEY `dtable_view_user_share_from_user_a902a682` (`from_user`),
  KEY `dtable_view_user_share_to_user_11c9dad1` (`to_user`),
  KEY `dtable_view_user_share_table_id_d6743e78` (`table_id`),
  KEY `dtable_view_user_share_view_id_cce1c469` (`view_id`),
  KEY `share_folder_id` (`share_folder_id`),
  CONSTRAINT `dtable_view_user_share_dtable_id_0752f361_fk_dtables_id` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`),
  CONSTRAINT `dtable_view_user_share_ibfk_1` FOREIGN KEY (`share_folder_id`) REFERENCES `user_share_folders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_view_group_share` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_user` varchar(255) NOT NULL,
  `to_group_id` int(11) NOT NULL,
  `permission` varchar(15) NOT NULL,
  `table_id` varchar(36) NOT NULL,
  `view_id` varchar(36) NOT NULL,
  `dtable_id` int(11) NOT NULL,
  `shared_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_view_group_share_dtable_id_to_group_id_ta_cee5acd9_uniq` (`dtable_id`,`to_group_id`,`table_id`,`view_id`),
  KEY `dtable_view_group_share_from_user_19f5f54b` (`from_user`),
  KEY `dtable_view_group_share_to_group_id_8048d12e` (`to_group_id`),
  KEY `dtable_view_group_share_table_id_7fa4344d` (`table_id`),
  KEY `dtable_view_group_share_view_id_7cf93b71` (`view_id`),
  CONSTRAINT `dtable_view_group_share_dtable_id_832e8f1a_fk_dtables_id` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_quota` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `asset_quota` bigint(20) DEFAULT NULL,
  `row_limit` int(11) DEFAULT NULL,
  `monthly_api_call_limit_per_user` int(11) DEFAULT NULL,
  `monthly_automation_limit_per_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_x3m8s0l2_uniq` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `organizations_org_quota` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `asset_quota` bigint(20) DEFAULT NULL,
  `row_limit` int(11) DEFAULT NULL,
  `big_data_row_limit` bigint(20) DEFAULT NULL,
  `big_data_storage_quota` bigint(20) DEFAULT NULL,
  `monthly_api_call_limit_per_user` int(11) DEFAULT NULL,
  `monthly_automation_limit_per_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id_n3d9m1n7_uniq` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_system_plugin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `added_by` varchar(255) NOT NULL,
  `added_time` datetime(6) NOT NULL,
  `info` longtext NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_system_plugin_name_1b19cd3c` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `organizations_orgadminsettings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id_key_o0u4b7x9_unique_key` (`org_id`,`key`),
  KEY `org_id_n3x9b4v0_key` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `webhook_jobs` (
`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
`webhook_id` int(11) unsigned NOT NULL,
`created_at` datetime(6) DEFAULT current_timestamp(6),
`trigger_at` datetime(6) DEFAULT NULL,
`status` tinyint(1) DEFAULT NULL,
`url` varchar(2000) NOT NULL,
`request_headers` text DEFAULT NULL,
`request_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
`response_status` int(5) DEFAULT NULL,
`response_body` longtext DEFAULT NULL,
PRIMARY KEY (`id`),
KEY `webhook_id_l2o9j3x6_key` (`webhook_id`),
KEY `status_b7n3m0x1_key` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `webhooks` (
`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
`dtable_uuid` varchar(32) NOT NULL,
`url` varchar(2000) NOT NULL,
`settings` text DEFAULT NULL,
`creator` varchar(255) NOT NULL,
`created_at` datetime(6) DEFAULT current_timestamp(6),
`is_valid` tinyint(1) DEFAULT 1,
PRIMARY KEY (`id`),
KEY `dtable_uuid_k3nx9o5y7_key` (`dtable_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_opened_bys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `opened_by_user` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_open_dtable__daa364_idx` (`dtable_uuid`,`opened_by_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `organizations_org_corp_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) DEFAULT NULL,
  `corp_id` varchar(255) DEFAULT NULL,
  `corp_name` varchar(255) NOT NULL,
  `permanent_code` varchar(255) NOT NULL,
  `extra_data` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id` (`org_id`),
  UNIQUE KEY `corp_id` (`corp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_abuse_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reporter` varchar(255) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `external_link_token` varchar(100) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `abuse_type` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `handled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_abuse_report_dtable_uuid_034cf288` (`dtable_uuid`),
  KEY `dtable_abuse_report_handled_3b7da945` (`handled`),
  KEY `dtable_abuse_report_external_link_token` (`external_link_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_share_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) NOT NULL,
  `permission` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_share_permission_dtable_uuid_9ac100fe` (`dtable_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invitation_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `token` varchar(40) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `registration_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` varchar(40) NOT NULL DEFAULT '',
  `token` varchar(40) DEFAULT NULL,
  `accepter` varchar(255) DEFAULT NULL,
  `registered_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `registration_logs_source_c4868a74` (`source`),
  KEY `registration_logs_registered_at_b899305c` (`registered_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `group_invite_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(40) NOT NULL,
  `group_id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_invite_link_token_7f96850f` (`token`),
  KEY `group_invite_link_group_id_4b619114` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `id_in_org_tuple` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `virtual_id` varchar(255) NOT NULL,
  `id_in_org` varchar(255) NOT NULL,
  `org_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_in_org_virtual_id_41ccd900` (`virtual_id`),
  KEY `id_in_org_id_in_org_ffee1607` (`id_in_org`),
  KEY `id_in_org_org_id_169def82` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `notifications_sysusernotification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to_user` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `seen` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_sysusernotification_seen_djfwp829` (`seen`),
  KEY `notifications_sysusernotification_created_at_uurdf334` (`created_at`),
  KEY `notifications_sysusernotification_to_user_7605g569` (`to_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_collection_tables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `config` longtext DEFAULT NULL,
  `token` varchar(36) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `view_count` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `dtable_collection_tables_username_31a4ba98` (`username`),
  KEY `dtable_collection_tables_workspace_id_003b9f84` (`workspace_id`),
  KEY `dtable_collection_tables_dtable_uuid_fdc09bc2` (`dtable_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_view_external_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` varchar(255) NOT NULL,
  `table_id` varchar(36) NOT NULL,
  `view_id` varchar(36) NOT NULL,
  `token` varchar(100) NOT NULL,
  `permission` varchar(50) NOT NULL,
  `view_cnt` int(11) NOT NULL,
  `create_at` datetime(6) NOT NULL,
  `is_custom` tinyint(1) NOT NULL,
  `password` varchar(128) DEFAULT NULL,
  `expire_date` datetime(6) DEFAULT NULL,
  `dtable_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `dtable_view_external_link_dtable_id_ed96fdf4_fk_dtables_id` (`dtable_id`),
  CONSTRAINT `dtable_view_external_link_dtable_id_ed96fdf4_fk_dtables_id` FOREIGN KEY (`dtable_id`) REFERENCES `dtables` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `bound_third_party_accounts` (
	`id` INT ( 11 ) NOT NULL AUTO_INCREMENT,
	`dtable_uuid` VARCHAR ( 36 ) NOT NULL,
	`account_name` VARCHAR ( 255 ) NOT NULL,
	`account_type` VARCHAR ( 255 ) NOT NULL,
	`detail` LONGTEXT NOT NULL,
	`created_at` datetime ( 6 ) NOT NULL,
	PRIMARY KEY ( `id` ),
	UNIQUE KEY `bound_third_party_accounts_du_an_2ur5sjfd_uniq` ( `dtable_uuid`, `account_name` )
) ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE `folders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `workspace_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_workspace_id_n3o0u7t3_uniq_key` (`name`,`workspace_id`),
  KEY `workspace_id_j3b8g5q0p8_key` (`workspace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `folder_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_id` int(11) NOT NULL,
  `item_type` varchar(50) NOT NULL,
  `item_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `folder_id_item_type_item_id_k8h5b6q1_uniq_key` (`folder_id`,`item_type`,`item_id`),
  KEY `item_type_item_id_k3n8u0i0_union_key` (`item_type`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_external_apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_uuid` varchar(36) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `app_type` varchar(255) NOT NULL,
  `app_config` longtext DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `visit_times` int(11) NOT NULL DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `org_id` int(11) DEFAULT NULL,
  `custom_url` varchar(255) DEFAULT NULL,
  `inactive` tinyint(1) DEFAULT 0,
  `version` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_uuid` (`app_uuid`),
  UNIQUE KEY `custom_url` (`custom_url`),
  KEY `dtable_external_apps_dtable_uuid_3403d0a2` (`dtable_uuid`),
  KEY `idx_dtable_external_app_org_id` (`org_id`),
  KEY `dtable_external_apps_created_at_164f4499` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `delete_operation_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(64) NOT NULL,
  `op_id` bigint(20) NOT NULL,
  `op_type` varchar(255) NOT NULL,
  `op_time` bigint(20) NOT NULL,
  `operation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `author` varchar(255) NOT NULL,
  `app` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `delete_operation_log_op_time_type_dtable_uuid` (`dtable_uuid`,`op_time`),
  KEY `delete_operation_log_dtable_uuid` (`dtable_uuid`),
  KEY `delete_operation_log_op_time` (`op_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `email_sending_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `timestamp` datetime NOT NULL,
  `host` varchar(255) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_email_sending_log_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_plugins_install_count`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plugin_name` varchar(60) NOT NULL,
  `count` int(11) NOT NULL,
  `updated_at` datetime(6),
  `created_at` datetime(6),
  PRIMARY KEY (`id`),
 UNIQUE KEY `dtable_plugins_install_count_plugin_name`(`plugin_name`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_automation_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `run_condition` varchar(32) NOT NULL,
  `trigger` longtext NOT NULL,
  `actions` longtext NOT NULL,
  `creator` varchar(255) NOT NULL,
  `ctime` datetime(6) NOT NULL,
  `last_trigger_time` datetime(6) DEFAULT NULL,
  `is_valid` tinyint(1) DEFAULT 1,
  `trigger_count` int(11) NOT NULL DEFAULT 0,
  `org_id` int(11) DEFAULT NULL,
  `is_pause` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `dtable_uuid` (`dtable_uuid`),
  KEY `is_valid_u7h3b0j1_key` (`is_valid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_auto_rules_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `trigger_date` date NOT NULL,
  `trigger_count` int(11) DEFAULT 0,
  `update_at` datetime(6) NOT NULL,
  `warning_limit` INT(11) DEFAULT NULL,
  `has_sent_warning` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_trigger_date_n3x0p2i8_uniq_key` (`username`,`trigger_date`),
  KEY `username_m0o1g4d0_key` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `org_auto_rules_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `trigger_date` date NOT NULL,
  `trigger_count` int(11) DEFAULT 0,
  `update_at` datetime(6) NOT NULL,
  `warning_limit` INT(11) DEFAULT NULL,
  `has_sent_warning` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id_trigger_date_n3x0p2i8_uniq_key` (`org_id`,`trigger_date`),
  KEY `org_id_m0o1g4d0_key` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `session_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `user_agent` varchar(512) NOT NULL,
  `remote_address` varchar(60) NOT NULL,
  `session_key` varchar(40) NOT NULL,
  `op_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `session_log_user_name` (`user_name`),
  KEY `session_log_remote_address` (`remote_address`),
  KEY `session_key` (`session_key`),
  KEY `op_time_g4i9u7k1_key` (`op_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `onlyoffice_doc_key` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doc_key` varchar(36) NOT NULL,
  `username` varchar(255) NOT NULL,
  `repo_id` varchar(36) NOT NULL,
  `file_path` longtext NOT NULL,
  `repo_id_file_path_md5` varchar(100) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `repo_id_file_path_md5` (`repo_id_file_path_md5`),
  KEY `onlyoffice_doc_key_doc_key_49b6ca92` (`doc_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(36) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `workflow_config` text DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `visit_times` int(11) NOT NULL DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_workflow_token_h3b3j2k1` (`token`),
  KEY `dtable_workflows_dtable_uuid_h4v32g29` (`dtable_uuid`),
  KEY `dtable_workflows_created_at_b4h4k2vw` (`created_at`),
  KEY `dtable_workflows_owner_h4v3h2j2o6` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_workflow_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_workflow_id` int(11) NOT NULL,
  `row_id` varchar(36) NOT NULL,
  `initiator` varchar(255) DEFAULT NULL,
  `node_id` varchar(50) NOT NULL,
  `state` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `task_state` varchar(40) DEFAULT NULL,
  `finished_at` datetime(6) DEFAULT NULL,
  `is_valid` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `initiator_j3b0o1l9_key` (`initiator`),
  KEY `node_id_k3s0l1b8_key` (`node_id`),
  KEY `row_id_j3b4l52_key` (`row_id`),
  KEY `state_p2o3h4b5_key` (`state`),
  KEY `task_state_jk32v4c5_key` (`task_state`),
  KEY `task_workflow_id_fk_workflow_jh3b2` (`dtable_workflow_id`),
  CONSTRAINT `task_workflow_id_fk_workflow_jh3b2` FOREIGN KEY (`dtable_workflow_id`) REFERENCES `dtable_workflows` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_workflow_task_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_workflow_task_id` int(11) NOT NULL,
  `node_id` varchar(50) NOT NULL,
  `participant` varchar(255) NOT NULL DEFAULT '',
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `approvers_task_id_b3m2o0h7_fk_tasks_id` (`dtable_workflow_task_id`),
  KEY `participant_n3b2l4b1_key` (`participant`),
  CONSTRAINT `approvers_task_id_b3m2o0h7_fk_tasks_id` FOREIGN KEY (`dtable_workflow_task_id`) REFERENCES `dtable_workflow_tasks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_workflow_share` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_workflow_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_workflow_id_group_id_j3b2k4_key` (`dtable_workflow_id`,`group_id`),
  KEY `group_id_h3b4l5l9_key` (`group_id`),
  CONSTRAINT `wf_group_share_wf_id_fk_workflow_bk38` FOREIGN KEY (`dtable_workflow_id`) REFERENCES `dtable_workflows` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_workflow_task_logs` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NOT NULL,
  `log_type` varchar(20) NOT NULL,
  `node_id` varchar(50) DEFAULT NULL,
  `next_node_id` varchar(50) DEFAULT NULL,
  `operator` varchar(255) DEFAULT NULL,
  `row_data` text DEFAULT NULL,
  `start_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_workflow_task_id_j3b8h4o0_key` (`task_id`),
  KEY `operator_j3b2l9h4_key` (`operator`),
  KEY `log_type_p3b5k8b1_key` (`log_type`),
  CONSTRAINT `log_task_id_b3m2o0h7_fk_tasks_id` FOREIGN KEY (`task_id`) REFERENCES `dtable_workflow_tasks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `auto_rules_task_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trigger_time` datetime(6) NOT NULL,
  `success` tinyint(1) NOT NULL,
  `rule_id` int(11) NOT NULL,
  `run_condition` varchar(255) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `org_id` int(11) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `warnings` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `auto_rule_task_log_rule_id_f2jasf81` (`rule_id`),
  KEY `auto_rule_task_log_org_id_f2yuuahjd` (`org_id`),
  KEY `auto_rule_task_log_owner_fwhiyvye` (`owner`),
  KEY `auto_rule_task_log_dtable_uuid_uybhe82` (`dtable_uuid`),
  KEY `trigger_time_u3h9o0n1_key` (`trigger_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `group_id_ldap_uuid_pair` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `group_uuid` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`),
  UNIQUE KEY `group_uuid` (`group_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `big_data_storage_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `total_rows` bigint(20) NOT NULL,
  `total_storage` bigint(20) NOT NULL,
  `org_id` int(11) NOT NULL DEFAULT -1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `big_data_storage_stats_dtable_uuid` (`dtable_uuid`),
  KEY `big_data_storage_stats_idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* dtable-storage-server */;
CREATE TABLE storage_server_dtable_backups (
  id int AUTO_INCREMENT PRIMARY KEY,
  dtable_id varchar(36) NOT NULL,
  backup_version bigint unsigned NOT NULL,
  created_at bigint NOT NULL,
  size bigint NOT NULL,
  UNIQUE KEY index_backups_on_dtable_id (dtable_id, backup_version)
) ENGINE = InnoDB, COLLATE = utf8mb4_general_ci;

CREATE TABLE storage_server_dtable_snapshots (
  id int AUTO_INCREMENT PRIMARY KEY,
  dtable_id varchar(36) NOT NULL,
  snapshot_id varchar(36) NOT NULL,
  ctime bigint NOT NULL,
  KEY index_snapshots_on_dtable_id (dtable_id)
) ENGINE = InnoDB, COLLATE = utf8mb4_general_ci;

CREATE TABLE storage_server_dtable_backups_v2 (
  id int AUTO_INCREMENT PRIMARY KEY,
  dtable_id varchar(36) NOT NULL,
  backup_version bigint unsigned NOT NULL,
  created_at bigint NOT NULL,
  size bigint NOT NULL,
  UNIQUE KEY index_backups_on_dtable_id (dtable_id, backup_version)
) ENGINE = InnoDB, COLLATE = utf8mb4_general_ci;
/* dtable-storage-server */;

/* seatable-ai */;
CREATE TABLE `ai_assistant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assistant_uuid` varchar(36) NOT NULL,
  `assistant_name` varchar(255) NOT NULL,
  `assistant_type` varchar(255) NOT NULL,
  `assistant_avatar` varchar(255) NULL DEFAULT NULL,
  `config` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assistant_uuid`(`assistant_uuid`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `index_assistant_tables`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assistant_uuid` varchar(36) NOT NULL,
  `index_range` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated` datetime(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `assistant_uuid`(`assistant_uuid`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `assistant_need_clean`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assistant_uuid` varchar(36) NOT NULL,
  `clean_range` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated` datetime(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `assistant_uuid`(`assistant_uuid`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/* seatable-ai */;

/* sdoc */;
CREATE TABLE `sdoc_operation_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doc_uuid` varchar(36) NOT NULL,
  `op_id` bigint(20) NOT NULL,
  `op_time` bigint(20) NOT NULL,
  `operations` longtext NOT NULL,
  `author` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sdoc_operation_log_op_time` (`op_time`),
  KEY `sdoc_operation_log_doc_uuid` (`doc_uuid`),
  KEY `sdoc_idx_operation_log_doc_uuid_op_id` (`doc_uuid`,`op_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/* sdoc */;

/* dtable-db */;
CREATE TABLE `dtable_db_op_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `base_id` varchar(32) NOT NULL,
  `op_type` varchar(20) NOT NULL,
  `op_time` bigint NOT NULL,
  `operation` longtext NOT NULL,
  `author` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_db_op_log_base_id` (`base_id`),
  KEY `dtable_db_op_log_op_time` (`op_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/* dtable-db */;

CREATE TABLE `org_big_data_storage_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `total_rows` bigint(20) NOT NULL,
  `total_storage` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_big_data_storage_stats_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_app_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `role_name` varchar(255) NOT NULL,
  `role_permission` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `role_permission_detail` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_app_roles_app_id_role_name_key_234` (`app_id`,`role_name`),
  KEY `dtable_app_roles_app_id_key_8hhoeuh` (`app_id`),
  CONSTRAINT `dtable_app_roles_external_app` FOREIGN KEY (`app_id`) REFERENCES `dtable_external_apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_app_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_app_user_app_id_username_key_123` (`app_id`,`username`),
  KEY `dtable_app_user_role` (`role_id`),
  KEY `dtable_app_user_app_id_key_jajfie` (`app_id`),
  CONSTRAINT `dtable_app_user_role` FOREIGN KEY (`role_id`) REFERENCES `dtable_app_roles` (`id`),
  CONSTRAINT `dtable_app_users_external_app` FOREIGN KEY (`app_id`) REFERENCES `dtable_external_apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_app_invite_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `token` varchar(100) NOT NULL,
  `ctime` datetime(6) NOT NULL,
  `password` varchar(128) DEFAULT NULL,
  `expire_date` datetime(6) DEFAULT NULL,
  `app_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `dtable_share_links_dtable_id_19974ba2_fk_dtables_id` (`app_id`),
  KEY `dtable_share_links_username_0fcbefa6` (`username`),
  KEY `dtable_app_links_app_role_218391ad` (`role_id`),
  CONSTRAINT `dtable_app_links_app_id_19974ba2_fk_dtables_id` FOREIGN KEY (`app_id`) REFERENCES `dtable_external_apps` (`id`),
  CONSTRAINT `dtable_app_links_app_role_218391ad` FOREIGN KEY (`role_id`) REFERENCES `dtable_app_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `org_external_apps_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `visit_date` date NOT NULL,
  `visit_count` int(11) NOT NULL DEFAULT 1,
  `latest_visit_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id_visit_date_l980p4o8_uniq_key` (`org_id`,`visit_date`),
  KEY `visite_date_ddaifh0` (`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_external_apps_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `visit_date` date NOT NULL,
  `visit_count` int(11) NOT NULL DEFAULT 1,
  `latest_visit_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_visit_date_nyfiyib_uniq_key` (`username`,`visit_date`),
  KEY `visite_date_oiwh9802` (`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_group_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `detail` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_group_order_username_uwuyehjb` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `page_design_snapshot` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `page_id` varchar(36) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `commit_id` varchar(40) NOT NULL,
  `ctime` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `page_design_snapshot_page_id_commit_id_02846775_uniq` (`page_id`,`commit_id`),
  KEY `page_design_snapshot_page_id_18b38d9c` (`page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_app_user_sync` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `dst_table_id` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_sync_app_user_foreign_key` (`app_id`),
  CONSTRAINT `app_sync_app_user_foreign_key` FOREIGN KEY (`app_id`) REFERENCES `dtable_external_apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_data_syncs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `sync_type` varchar(20) NOT NULL,
  `detail` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_valid` tinyint(1) NULL DEFAULT 1,
  `last_sync_time` datetime DEFAULT NULL,
  `consecutive_errors_times` tinyint(4) DEFAULT 0,
  `error_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `dtable_uuid_sync_type`(`dtable_uuid`, `sync_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `custom_asset_uuid` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `parent_path` longtext NOT NULL,
  `dtable_uuid_parent_path_md5` varchar(100) NOT NULL,
  `file_name` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `custom_asset_uuid_dtable_uuid_parent_path_md5` (`dtable_uuid_parent_path_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_workflow_task_schedules` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NOT NULL,
  `schedule_time` datetime(6) NOT NULL,
  `action` text DEFAULT NULL,
  `is_executed` tinyint(1) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `task_id_h4v5n3b9_key` (`task_id`),
  KEY `schedule_time_j3o0n7b5_key` (`schedule_time`),
  KEY `state_j4b2k9b6_key` (`is_executed`),
  CONSTRAINT `schedules_task_id_j4g5v3o9_fk_tasks_id` FOREIGN KEY (`task_id`) REFERENCES `dtable_workflow_tasks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `admin_log_orgadminlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `operation` varchar(255) NOT NULL,
  `detail` longtext NOT NULL,
  `datetime` datetime(6) NOT NULL,
  `org_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_log_orgadminlog_email_7213c993`(`email`),
  KEY `admin_log_orgadminlog_operation_4bad7bd1`(`operation`),
  KEY `admin_log_org_id`(`org_id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_asset_trash` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(32) NOT NULL,
  `name` varchar(255) NOT NULL,
  `delete_from` varchar(20) NOT NULL,
  `item_type` varchar(20) NOT NULL,
  `basedir` varchar(4096) NOT NULL,
  `commit_id` varchar(40) NOT NULL,
  `size` bigint(20) DEFAULT 0,
  `deleted_at` datetime(6) DEFAULT NULL,
  `detail` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `deleted_at_j4b2o3j8_key` (`deleted_at`),
  KEY `dtable_uuid_b4l2p9m8_key` (`dtable_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `departments_v2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `id_in_org` int(11) NOT NULL,
  `path` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id_id_in_org_b4g2l0b1_uniq_key` (`org_id`,`id_in_org`),
  KEY `parent_id_j2u7g4v8_key` (`parent_id`),
  KEY `path_b3v2l4h9_key` (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `department_members_v2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `department_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `is_staff` tinyint(1) DEFAULT 0,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `department_id_username_b4j7v3l9_uniq_key` (`department_id`,`username`),
  KEY `username_h3v3j7b9_key` (`username`),
  CONSTRAINT `department_members_departments_id_fkb4g7_key` FOREIGN KEY (`department_id`) REFERENCES `departments_v2` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `department_v2_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `department_id` int(11) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `department_id_group_id_h5v3u6f9_uniq_key` (`department_id`,`group_id`),
  UNIQUE KEY `group_id_b4g2g5v8_uniq_key` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `dtable_app_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to_user` varchar(255) NOT NULL,
  `msg_type` varchar(255) NOT NULL,
  `detail` longtext NOT NULL,
  `app_id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `seen` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_app_ notification_foreign_key_app` (`app_id`),
  KEY `dtable_app_notifications_to_user_key` (`to_user`),
  KEY `dtable_app_notification_created_at_key` (`created_at`),
  CONSTRAINT `dtable_app_ notification_foreign_key_app` FOREIGN KEY (`app_id`) REFERENCES `dtable_external_apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `workflow_folders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `folder_type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_username_id_n3o0u7t3_uniq_key` (`name`,`username`,`folder_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `workflow_folder_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_id` int(11) NOT NULL,
  `workflow_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wf_folder_items_folder_id_key_138` (`folder_id`, `workflow_id`),
  KEY `wf_folder_items_workflow_id_ji228n` (`workflow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_app_snapshot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `app_version` bigint(20) NOT NULL,
  `app_config` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_app_snapshot_02846775_uniq` (`app_id`,`app_version`),
  CONSTRAINT `dtable_app_snapshot_app_id_19974ba2_fk_dtables_id` FOREIGN KEY (`app_id`) REFERENCES `dtable_external_apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_app_row_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(255) NOT NULL,
  `comment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `app_id` int(11) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `table_id` varchar(255) NOT NULL,
  `row_id` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `resolved` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `key_row_comment_created_at` (`created_at`),
  KEY `dtable_table_row_union_key` (`dtable_uuid`,`table_id`,`row_id`),
  CONSTRAINT `dtable_app_comments_foreign_key_app` FOREIGN KEY (`app_id`) REFERENCES `dtable_external_apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE `dtable_app_row_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `app_user` varchar(255) NOT NULL,
  `table_id` varchar(255) NOT NULL,
  `row_id` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dtable_app_participants_foreign_key_app_user` (`app_user`),
  KEY `dtable_table_row_union_key` (`dtable_uuid`, `table_id`, `row_id`),
  CONSTRAINT `dtable_app_participants_foreign_key_app` FOREIGN KEY (`app_id`) REFERENCES `dtable_external_apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE `org_saml_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `metadata_url` longtext NOT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `dns_txt` varchar(64) DEFAULT NULL,
  `domain_verified` tinyint(1) NOT NULL DEFAULT 0,
  `idp_certificate` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id` (`org_id`),
  UNIQUE KEY `domain` (`domain`),
  KEY `domain_verified` (`domain_verified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dtable_form_custom_urls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_token` varchar(36) NOT NULL,
  `custom_url` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `custom_url` (`custom_url`),
  KEY `form_token_key` (`form_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE `ai_assistant_owner`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assistant_uuid` varchar(36) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assitant_uuid_uniq_key`(`assistant_uuid`),
  KEY `owner_key`(`owner`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `dtable_app_folders` (
  `id` INT (11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR ( 255 ) NOT NULL,
  `username` VARCHAR ( 50 ) NULL,
  `folder_type` VARCHAR ( 255 ) NOT NULL,
  PRIMARY KEY ( `id` ),
  UNIQUE INDEX `name_username_folder_type_uniq_key`(`name`, `username`, `folder_type`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `dtable_app_folder_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_id` int(11) NOT NULL,
  `app_id` int (11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `folder_id_app_id_uniq_key` (`folder_id`, `app_id`),
  KEY `app_id_key` (`app_id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `stats_api_gateway_by_base` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(32) NOT NULL,
  `api_name` varchar(50) NOT NULL,
  `count` bigint(20) unsigned DEFAULT NULL,
  `month` date DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_month_api_y5f3b0z9_uniq_key` (`dtable_uuid`,`month`,`api_name`),
  KEY `month_h3k2l1p0_key` (`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `stats_api_gateway_by_team` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` bigint(20) NOT NULL,
  `api_name` varchar(50) NOT NULL,
  `count` bigint(20) unsigned DEFAULT NULL,
  `month` date DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_month_api_h2x0m1r4_uniq_key` (`org_id`,`month`,`api_name`),
  KEY `month_p3j6m2z9_key` (`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `stats_api_gateway_by_owner` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` varchar(255) NOT NULL,
  `api_name` varchar(50) NOT NULL,
  `count` bigint(20) unsigned DEFAULT NULL,
  `month` date DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `owner_month_api_r4f5v6b9_uniq_key` (`owner_id`,`month`,`api_name`),
  KEY `month_y5g6b4x0_key` (`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `audit_log_auditlog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `operation` varchar(255) NOT NULL,
  `detail` longtext NOT NULL,
  `org_id` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `audit_log_auditlog_created_at` (`created_at`),
  KEY `audit_log_auditlog_org_id_created_at` (`org_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `file_access_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime(0) NOT NULL,
  `etype` varchar(128) NOT NULL,
  `user` varchar(255) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `device` text NOT NULL,
  `org_id` int(11) NOT NULL,
  `dtable_uuid` varchar(36) NOT NULL,
  `file_path` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_file_access_log_timestamp`(`timestamp`),
  KEY `ix_file_access_log_org_id_timestamp`(`org_id`, `timestamp`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `VirusFile` (
  `vid` int(11) NOT NULL AUTO_INCREMENT,
  `repo_id` varchar(36) NOT NULL,
  `commit_id` varchar(40) NOT NULL,
  `file_path` text NOT NULL,
  `has_deleted` tinyint(1) NOT NULL,
  `has_ignored` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`vid`),
  KEY `ix_VirusFile_has_ignored` (`has_ignored`),
  KEY `ix_VirusFile_has_deleted` (`has_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `VirusScanRecord` (
  `repo_id` varchar(36) NOT NULL,
  `scan_commit_id` varchar(40) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`repo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `assistant_history`  (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `assistant_uuid` varchar(36) NOT NULL,
  `username` varchar(255) NOT NULL,
  `role` varchar(36) NOT NULL,
  `content` longtext,
  `tool_calls` longtext,
  `tool_call_id` varchar(64) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated` datetime(6),
  PRIMARY KEY (`id`),
  KEY `assistant_uuid_username_mode` (`assistant_uuid`,`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `exceed_api_quota_teams` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `org_id` bigint(20) DEFAULT NULL,
  `api_limit` int(11),
  `owner_id` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id_owner_id_h3u7f0p1_uniq_key` (`org_id`,`owner_id`),
  KEY `owner_id_b3g4j0l7_key` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dtable_app_anonymous_access_password` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `password` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_id_h3g2i8v9_uniq_key` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `stats_ai_by_team` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` bigint(20) NOT NULL,
  `month` date NOT NULL,
  `model` varchar(100) NOT NULL,
  `input_tokens` int(11) DEFAULT NULL,
  `output_tokens` int(11) DEFAULT NULL,
  `cost` double NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_month_model_h5f4v6m9_uniq_key` (`org_id`,`month`,`model`),
  KEY `month_h3o2b6k7_key` (`month`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `stats_ai_by_owner` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` varchar(255) NOT NULL,
  `month` date NOT NULL,
  `model` varchar(100) NOT NULL,
  `input_tokens` int(11) DEFAULT NULL,
  `output_tokens` int(11) DEFAULT NULL,
  `cost` double NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `owner_month_model_g2u6b9c7_uniq_key` (`owner_id`,`month`,`model`),
  KEY `month_g5v4l0d2_key` (`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `group_member_audit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `operator` varchar(255) NOT NULL,
  `user` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL,
  `operation` varchar(128) NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_group_member_audit_org_id` (`org_id`),
  KEY `idx_group_member_audit_timestamp` (`timestamp`),
  KEY `idx_group_member_audit_operator` (`operator`),
  KEY `idx_group_member_audit_user` (`user`),
  KEY `idx_group_member_audit_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dtable_app_pages_operation_log` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `app_uuid` VARCHAR(255) NOT NULL,
  `page_id` VARCHAR(255) NOT NULL,
  `operator` VARCHAR(255) NOT NULL,
  `operation` VARCHAR(128) NOT NULL,
  `updated_at` DATETIME(6) NOT NULL,
  `detail` LONGTEXT,
  KEY `idx_dtable_app_pages_operation_log_update_at` (`updated_at`),
  KEY `idx_dtable_app_pages_operation_log_app_uuid_page_id` (`app_uuid`, `page_id`)
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

CREATE TABLE `app_abuse_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reporter` varchar(255) NOT NULL,
  `app_uuid` varchar(36) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `abuse_type` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `handled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `app_abuse_report_app_uuid` (`app_uuid`),
  KEY `app_abuse_report_create_time` (`create_time`),
  KEY `app_abuse_report_handled` (`handled`)
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

CREATE TABLE `ai_assistant_mcp_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assistant_uuid` varchar(36) NOT NULL,
  `token` varchar(40) NOT NULL,
  `generated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `generated_by` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_ai_assistant_mcp_token_token` (`token`),
  KEY `idx_ai_assistant_mcp_token_assistant_uuid` (`assistant_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dtable_automation_rules_navigation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `detail` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_uuid_h4k2p2b7_uniq_key` (`dtable_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `stats_ai_by_dtable` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dtable_uuid` varchar(36) NOT NULL,
  `date` date DEFAULT NULL,
  `model` varchar(100) NOT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `org_id` bigint(20) DEFAULT NULL,
  `input_tokens` int(11) DEFAULT NULL,
  `output_tokens` int(11) DEFAULT NULL,
  `cost` double NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dtable_date_model_uniq_key` (`dtable_uuid`,`date`,`model`),
  KEY `date_owner_j3g9o2p1_key` (`date`,`owner`),
  KEY `date_org_id_owner_h4b5k3v9_key` (`date`,`org_id`,`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `html_page_chat_sessions` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`app_uuid` VARCHAR(36) NOT NULL,
	`session_uuid` VARCHAR(36) NOT NULL,
	`username` VARCHAR(255) NOT NULL,
	`session_name` VARCHAR(255) NOT NULL,
	`related_tables` TEXT NULL,
	`created_at` DATETIME(6) NOT NULL,
	`updated_at` DATETIME(6) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniq_session_uuid` (`session_uuid`),
	KEY `idx_app_uuid` (`app_uuid`),
	KEY `idx_username` (`username`),
	KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `html_page_chat_messages` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`session_uuid` VARCHAR(36) NOT NULL,
	`username` VARCHAR(255) NOT NULL,
	`role` VARCHAR(20) NOT NULL,
	`content` LONGTEXT DEFAULT NULL,
	`created_at` DATETIME(6) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `idx_session_uuid` (`session_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
