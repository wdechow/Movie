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
  MOL_ID bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  MOL_MOV_ID bigint unsigned NOT NULL,
  MOL_LAN_ID bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

