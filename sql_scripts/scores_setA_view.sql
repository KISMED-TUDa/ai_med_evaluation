CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `admin`@`%` 
    SQL SECURITY DEFINER
VIEW `wki_main`.`scores_hiddensetA` AS
    SELECT 
        `wki_main`.`wki_teams`.`team_name` AS `team_name`,
        `wki_main`.`wki_scored_runs`.`f1_score` AS `f1_score`,
        `wki_main`.`wki_scored_runs`.`multi_score` AS `multi_score`,
        `wki_main`.`wki_scored_runs`.`run_time` AS `run_time`,
        `wki_main`.`wki_scored_runs`.`run_count_team` AS `run`,
        `wki_main`.`wki_scored_runs`.`datetime` AS `time`
    FROM
        ((`wki_main`.`wki_scored_runs`
        JOIN `wki_main`.`wki_teams` ON `wki_main`.`wki_scored_runs`.`team_nr`=`wki_main`.`wki_teams`.`team_id`)
        JOIN `wki_main`.`wki_datasets` ON `wki_main`.`wki_scored_runs`.`dataset_nr`=`wki_main`.`wki_datasets`.`dataset_id`)
    WHERE
        (`wki_main`.`wki_scored_runs`.`dataset_nr` = 1)
    ORDER BY `wki_main`.`wki_scored_runs`.`f1_score`