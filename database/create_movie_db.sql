create database if not exists MovieDB_1_0 character set utf8 collate utf8_general_ci;

use MovieDB_1_0;


create table if not exists TBL_MOVIE (
  MOV_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  MOV_TITLE varchar(100),
  MOV_SUBTITLE varchar(100),
  MOV_TITLE_ORIGINAL varchar(100),
  MOV_SUBTITLE_ORIGINAL varchar(100),
  MOV_FSK tinyint,
  MOV_RUNTIME_MINUTE smallint,
  MOV_RELEASE_DATE date,
  MOV_PATH varchar(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_ACTOR (
  ACT_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ACT_FORENAME varchar(100),
  ACT_SURNAME varchar(100),
  ACT_ALIAS varchar(100),
  ACT_BIRTHDAY date
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_MOVIE_ACTOR (
  MOA_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  MOA_MOV_ID bigint unsigned NOT NULL,
  MOA_ACT_ID bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_LANGUAGE (
  LAN_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  LAN_NAME varchar(100),
  LAN_SHORT varchar(5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_MOVIE_LANGUAGE (
  MOL_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  MOL_MOV_ID bigint unsigned NOT NULL,
  MOL_LAN_ID bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_MOVIE_SUBTITLE (
  MOS_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  MOS_MOV_ID bigint unsigned NOT NULL,
  MOS_LAN_ID bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_SONG (
  SON_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  SON_TITLE varchar(100),
  SON_ARTIST varchar(100),
  SON_PATH varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_MOVIE_SONG (
  MON_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  MON_MOV_ID bigint unsigned NOT NULL,
  MON_SON_ID bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_WATCH (
  WAT_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  WAT_DATE_TIME datetime DEFAULT CURRENT_TIMESTAMP,
  WAT_CMD varchar(255),
  WAT_MOV_ID bigint unsigned,
  WAT_LANGUAGE_LAN_ID bigint unsigned,
  WAT_SUBTITLE_LAN_ID bigint unsigned
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_GENRE (
  GEN_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  GEN_NAME varchar(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table if not exists TBL_MOVIE_GENRE (
  MOG_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  MOG_MOV_ID bigint unsigned NOT NULL,
  MOG_GEN_ID bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;