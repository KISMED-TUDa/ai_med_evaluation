CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `preliminary_ranking` AS select rank() OVER (ORDER BY `wki_scored_runs`.`f1_score` desc )  AS `Pos`,`wki_teams`.`team_name` AS `Team`,if((`wki_scored_runs`.`dataset_nr` = 1),`wki_scored_runs`.`f1_score`,NULL) AS `F1 HiddenSetA`,if((`wki_scored_runs`.`dataset_nr` = 1),`wki_scored_runs`.`multi_score`,NULL) AS `Multi HiddenSetA`,if((`wki_scored_runs`.`dataset_nr` = 2),`wki_scored_runs`.`f1_score`,(select max(`t2`.`f1_score`) from `wki_scored_runs` `t2` where ((`t2`.`team_nr` = `wki_scored_runs`.`team_nr`) and (`t2`.`dataset_nr` = 2)))) AS `F1 HiddenSetB`,if((`wki_scored_runs`.`dataset_nr` = 2),`wki_scored_runs`.`multi_score`,(select max(`t2`.`multi_score`) from `wki_scored_runs` `t2` where ((`t2`.`team_nr` = `wki_scored_runs`.`team_nr`) and (`t2`.`dataset_nr` = 2)))) AS `Multi HiddenSetB`,`wki_scored_runs`.`run_time` AS `run_time`,`wki_scored_runs`.`run_count_team` AS `run`,`wki_scored_runs`.`datetime` AS `time` from ((`wki_scored_runs` join `wki_teams` on((`wki_scored_runs`.`team_nr` = `wki_teams`.`team_id`))) join `wki_datasets` on((`wki_scored_runs`.`dataset_nr` = `wki_datasets`.`dataset_id`))) where (`wki_scored_runs`.`f1_score` = (select max(`t2`.`f1_score`) from `wki_scored_runs` `t2` where ((`wki_scored_runs`.`team_nr` = `t2`.`team_nr`) and (`t2`.`dataset_nr` = 1)))) order by `wki_scored_runs`.`f1_score` desc