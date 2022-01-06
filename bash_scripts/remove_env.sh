#!/bin/bash

team_id=$1
v_env="WKI-T${team_id}"

# always clone base env for each group
conda remove env --name $v_env


