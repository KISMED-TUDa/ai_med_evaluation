#!/bin/bash

team_dir="${1}/"
req_text="${team_dir}wki_requirements.txt"

ppret=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/predict_pretrained.py
sscore=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/save_score.py
sscoreV2=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/save_scoreV2.py
score=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/score.py
wettb=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/wettbewerb.py
sscoreV3=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/save_scoreV3.py
wkie=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/wki_evaluate.py
wkiu=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/wki_utilities.py
req=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/requirements.txt
db=/home/rohr/WettbewerbKI/Workspace/18-ha-2010-pj/database_config.json

cp $ppret $team_dir
cp $sscore $team_dir
cp $score $team_dir
cp $wettb $team_dir
cp $sscoreV2 $team_dir
cp $sscoreV3 $team_dir
cp $wkie $team_dir
cp $wkiu $team_dir
cp $db $team_dir
cp $req $req_text