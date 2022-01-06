#!/bin/bash

team_id=$1
v_env="WKI-T${team_id}"

# always clone base env for each group
conda create --name $v_env python=3.8


