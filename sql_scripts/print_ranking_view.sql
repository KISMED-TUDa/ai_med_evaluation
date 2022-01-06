CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `admin`@`%` 
    SQL SECURITY DEFINER
VIEW `print_ranking` AS
    SELECT 
        `preliminary_ranking`.`Pos` AS `Pos`,
        `preliminary_ranking`.`Team` AS `Team`,
        FORMAT(`preliminary_ranking`.`F1 HiddenSetA`,
            4,
            'de_DE') AS `F1 HiddenSetA`,
        
        FORMAT(`preliminary_ranking`.`F1 HiddenSetB`,
            4,
            'de_DE') AS `F1 HiddenSetB`,
		FORMAT(`preliminary_ranking`.`Multi HiddenSetA`,
            4,
            'de_DE') AS `Multi HiddenSetA`,
        FORMAT(`preliminary_ranking`.`Multi HiddenSetB`,
            4,
            'de_DE') AS `Multi HiddenSetB`,
        `preliminary_ranking`.`run_time` AS `run_time`,
        `preliminary_ranking`.`run` AS `Abgabe`,
        DATE_FORMAT(`preliminary_ranking`.`time`, '%d.%m.%y') AS `Datum`
    FROM
        `preliminary_ranking`