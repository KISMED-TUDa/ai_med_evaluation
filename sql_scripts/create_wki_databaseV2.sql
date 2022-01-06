CREATE DATABASE `wki_main` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE wki_main;
-- create all tables
CREATE TABLE `wki_teams` (
  `team_id` int NOT NULL AUTO_INCREMENT,
  `team_name` varchar(45) DEFAULT NULL,
  `comment` varchar(300) DEFAULT NULL,
  `repositories` varchar(500) DEFAULT NULL,
  `nr_test_runs` int DEFAULT NULL,
  PRIMARY KEY (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `wki_students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `email` varchar(80) DEFAULT NULL,
  `mtr_nr` int DEFAULT NULL,
  `tu_id` varchar(12) DEFAULT NULL,
  `team_nr` int DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `tu_id_UNIQUE` (`tu_id`),
  UNIQUE KEY `mtr_nr_UNIQUE` (`mtr_nr`),
  KEY `fk_s_team` (`team_nr`),
  CONSTRAINT `fk_s_team` FOREIGN KEY (`team_nr`) REFERENCES `wki_teams` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `wki_datasets` (
  `dataset_id` int NOT NULL,
  `folder_name` varchar(45) DEFAULT NULL,
  `nr_recordings` varchar(45) DEFAULT NULL,
  `recording_len_min` varchar(45) DEFAULT NULL,
  `recording_len_max` varchar(45) DEFAULT NULL,
  `is_testset` tinyint(1) DEFAULT NULL,
  `dataset_description` varchar(300) DEFAULT NULL,
  `nr_classes` int DEFAULT NULL,
  PRIMARY KEY (`dataset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `wki_models` (
  `model_id` int NOT NULL AUTO_INCREMENT,
  `team_nr` int DEFAULT NULL,
  `model_name` varchar(100) DEFAULT NULL,
  `is_binary_classifier` tinyint DEFAULT NULL,
  `parameters` json DEFAULT NULL,
  PRIMARY KEY (`model_id`),
  KEY `fk_team_idx` (`team_nr`),
  CONSTRAINT `fk_m_team` FOREIGN KEY (`team_nr`) REFERENCES `wki_teams` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `wki_scored_runs` (
  `scored_run_id` int NOT NULL AUTO_INCREMENT,
  `dataset_nr` int DEFAULT NULL,
  `team_nr` int DEFAULT NULL,
  `run_count_team` int DEFAULT NULL,
  `datetime` datetime DEFAULT NULL,
  `f1_score` float DEFAULT NULL,
  `multi_score` float DEFAULT NULL,
  `model_nr` int DEFAULT NULL,
  `run_time` time DEFAULT NULL,
  PRIMARY KEY (`scored_run_id`),
  KEY `dataset_id_idx` (`dataset_nr`),
  KEY `fk_model` (`model_nr`),
  KEY `fk_team_nr` (`team_nr`),
  CONSTRAINT `fk_dataset` FOREIGN KEY (`dataset_nr`) REFERENCES `wki_datasets` (`dataset_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_model` FOREIGN KEY (`model_nr`) REFERENCES `wki_models` (`model_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_team_nr` FOREIGN KEY (`team_nr`) REFERENCES `wki_teams` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `wki_confusion_tables` (
  `confusion_id` int NOT NULL AUTO_INCREMENT,
  `scored_run_id` int DEFAULT NULL,
  `Nn` int DEFAULT NULL,
  `Na` int DEFAULT NULL,
  `No` int DEFAULT NULL,
  `Np` int DEFAULT NULL,
  `An` int DEFAULT NULL,
  `Aa` int DEFAULT NULL,
  `Ao` int DEFAULT NULL,
  `Ap` int DEFAULT NULL,
  `On` int DEFAULT NULL,
  `Oa` int DEFAULT NULL,
  `Oo` int DEFAULT NULL,
  `Op` int DEFAULT NULL,
  `Pn` int DEFAULT NULL,
  `Pa` int DEFAULT NULL,
  `Po` int DEFAULT NULL,
  `Pp` int DEFAULT NULL,
  PRIMARY KEY (`confusion_id`),
  KEY `fk_scored_runs_idx` (`scored_run_id`),
  CONSTRAINT `fk_scored_runs` FOREIGN KEY (`scored_run_id`) REFERENCES `wki_scored_runs` (`scored_run_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `wki_unscored_runs` (
  `unscored_run_id` int NOT NULL AUTO_INCREMENT,
  `dataset_nr` int DEFAULT NULL,
  `team_nr` int DEFAULT NULL,
  `datetime` datetime DEFAULT NULL,
  `model_nr` int DEFAULT NULL,
  `run_time` time DEFAULT NULL,
  `output_file` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`unscored_run_id`),
  KEY `fk_u_dataset` (`dataset_nr`),
  KEY `fk_u_model` (`model_nr`),
  KEY `fk_u_team_nr_idx` (`team_nr`),
  CONSTRAINT `fk_u_dataset` FOREIGN KEY (`dataset_nr`) REFERENCES `wki_datasets` (`dataset_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_u_model` FOREIGN KEY (`model_nr`) REFERENCES `wki_models` (`model_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_u_team_nr` FOREIGN KEY (`team_nr`) REFERENCES `wki_teams` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create Views
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `preliminary_ranking` AS select rank() OVER (ORDER BY `wki_scored_runs`.`f1_score` desc )  AS `Pos`,`wki_teams`.`team_name` AS `Team`,if((`wki_scored_runs`.`dataset_nr` = 1),`wki_scored_runs`.`f1_score`,NULL) AS `F1 HiddenSetA`,if((`wki_scored_runs`.`dataset_nr` = 1),`wki_scored_runs`.`multi_score`,NULL) AS `Multi HiddenSetA`,if((`wki_scored_runs`.`dataset_nr` = 2),`wki_scored_runs`.`f1_score`,(select max(`t2`.`f1_score`) from `wki_scored_runs` `t2` where ((`t2`.`team_nr` = `wki_scored_runs`.`team_nr`) and (`t2`.`dataset_nr` = 2)) limit 1)) AS `F1 HiddenSetB`,if((`wki_scored_runs`.`dataset_nr` = 2),`wki_scored_runs`.`multi_score`,(select max(`t2`.`multi_score`) from `wki_scored_runs` `t2` where ((`t2`.`team_nr` = `wki_scored_runs`.`team_nr`) and (`t2`.`dataset_nr` = 2)))) AS `Multi HiddenSetB`,`wki_scored_runs`.`run_time` AS `run_time`,`wki_scored_runs`.`run_count_team` AS `run`,`wki_scored_runs`.`datetime` AS `time` from ((`wki_scored_runs` join `wki_teams` on((`wki_scored_runs`.`team_nr` = `wki_teams`.`team_id`))) join `wki_datasets` on((`wki_scored_runs`.`dataset_nr` = `wki_datasets`.`dataset_id`))) where ((`wki_scored_runs`.`f1_score` = (select max(`t2`.`f1_score`) AS `t3_max` from `wki_scored_runs` `t2` where ((`wki_scored_runs`.`team_nr` = `t2`.`team_nr`) and (`t2`.`dataset_nr` = 1)) limit 1)) and (`wki_scored_runs`.`datetime` = (select max(`t3`.`datetime`) from `wki_scored_runs` `t3` where ((`wki_scored_runs`.`team_nr` = `t3`.`team_nr`) and (`t3`.`dataset_nr` = 1) and (`wki_scored_runs`.`f1_score` = `t3`.`f1_score`)) limit 1))) order by `wki_scored_runs`.`f1_score` desc;
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `number_of_runs` AS select `wki_teams`.`team_id` AS `team_id`,`wki_teams`.`team_name` AS `team_name`,max(`wki_scored_runs`.`run_count_team`) AS `runs` from (`wki_scored_runs` join `wki_teams` on((`wki_teams`.`team_id` = `wki_scored_runs`.`team_nr`))) group by `wki_teams`.`team_id`;
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `Runs_with_names` AS select `wki_scored_runs`.`scored_run_id` AS `scored_run_id`,`wki_datasets`.`folder_name` AS `Dataset`,`wki_teams`.`team_name` AS `team_name`,`wki_scored_runs`.`run_count_team` AS `run_count_team`,`wki_scored_runs`.`f1_score` AS `f1_score`,`wki_scored_runs`.`multi_score` AS `multi_score`,`wki_scored_runs`.`run_time` AS `run_time`,`wki_scored_runs`.`run_count_team` AS `run`,`wki_scored_runs`.`datetime` AS `time` from (((`wki_scored_runs` join `wki_models` on((`wki_models`.`model_id` = `wki_scored_runs`.`model_nr`))) join `wki_teams` on((`wki_models`.`team_nr` = `wki_teams`.`team_id`))) join `wki_datasets` on((`wki_scored_runs`.`dataset_nr` = `wki_datasets`.`dataset_id`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `show_teams` AS select `wki_students`.`last_name` AS `last_name`,`wki_students`.`first_name` AS `first_name`,`wki_students`.`tu_id` AS `tu_id`,`wki_teams`.`team_name` AS `team_name` from (`wki_students` join `wki_teams` on((`wki_teams`.`team_id` = `wki_students`.`team_nr`))) order by `wki_teams`.`team_name`;
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `Unscored_Runs_with_names` AS select `wki_unscored_runs`.`unscored_run_id` AS `unscored_run_id`,`wki_datasets`.`folder_name` AS `Dataset`,`wki_teams`.`team_name` AS `team_name`, `wki_unscored_runs`.`output_file`,`wki_unscored_runs`.`datetime` AS `time` from (((`wki_unscored_runs` join `wki_models` on((`wki_models`.`model_id` = `wki_unscored_runs`.`model_nr`))) join `wki_teams` on((`wki_models`.`team_nr` = `wki_teams`.`team_id`))) join `wki_datasets` on((`wki_unscored_runs`.`dataset_nr` = `wki_datasets`.`dataset_id`)));