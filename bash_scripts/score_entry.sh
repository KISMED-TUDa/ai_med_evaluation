#!/bin/bash
eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)"

team_id=$1

model_variants=$2 # binary,multi,both
model_name=$3
code_folder=$team_id

if [ $team_id -eq 0 ]; then
  team_id=0
  code_folder=18-ha-2010-pj
fi

conda_env="WKI-T${team_id}"

data_folder="../DataSets/"
current_time="$(command date +'%Y-%m-%d-%H-%M-%S')"
error_file="./error_out/${team_id}_${current_time}.txt"
echo "Running model of team ${team_id}" >> $error_file 

conda deactivate

if ! conda activate $conda_env; then
  echo "could not activate Conda Env $conda_env"
else 
  cd $code_folder
  if [ $team_id!="0" ]; then
     pip install -r wki_requirements.txt
  fi
  pip install -r requirements.txt >> "../${error_file}" 2>&1

  python wki_evaluate.py $data_folder $team_id --model_variants $model_variants --model_name $model_name --output_file $error_file >> "../${error_file}" 2>&1
fi

