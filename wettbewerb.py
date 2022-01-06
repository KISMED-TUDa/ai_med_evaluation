#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

Helper functions for loading references and storing predictions.

Load reference ecg signals saved as .mat per recording and one .csv-file that lists all .mat names and respective labels.


This file must not be changed for the evaluation system to work and will be reset by us.

@author:  Maurice Rohr
version ='1.0'
"""
__author__ = "Maurice Rohr und Christoph Reich"

from typing import List, Tuple
import csv
import scipy.io as sio
import numpy as np
import os


### Attention! Do not change this function.

def load_references(folder: str = '../training') -> Tuple[List[np.ndarray], List[str], int, List[str]]:
    """
    Parameters
    ----------
    folder : str, optional
        source folder for training data. Default  '../training'.

    Returns
    -------
    ecg_leads : List[np.ndarray]
        ECG signals.
    ecg_labels : List[str]
        same lengths as ecg_leads. values: 'N','A','O','~'
    fs : int
        sampling frequency.
    ecg_names : List[str]
        names of loaded files
    """
    # Check Parameter
    assert isinstance(folder, str), "parameter folder must be of type string but is {} ".format(type(folder))
    assert os.path.exists(folder), 'Parameter folder does not exist!'
    # Initialisiere Listen für leads, labels und names
    ecg_leads: List[np.ndarray] = []
    ecg_labels: List[str] = []
    ecg_names: List[str] = []
    # Setze sampling Frequenz
    fs: int = 300
    # Lade references Datei
    with open(os.path.join(folder, 'REFERENCE.csv')) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        # Iteriere über jede Zeile
        for row in csv_reader:
            # Lade MatLab Datei mit EKG lead and label
            data = sio.loadmat(os.path.join(folder, row[0] + '.mat'))
            ecg_leads.append(data['val'][0])
            ecg_labels.append(row[1])
            ecg_names.append(row[0])
    # Zeige an wie viele Daten geladen wurden
    print("{}\t files loaded.".format(len(ecg_leads)))
    return ecg_leads, ecg_labels, fs, ecg_names




### Attention! Do not change this function.

def save_predictions(predictions: List[Tuple[str, str]], folder: str=None) -> None:
    """
    function saves predictions as file named PREDICTIONS.csv
    Parameters
    ----------
    predictions : List[Tuple[str, str]]
        list of tuples, where each tuple contains name and label ('N','A','O','~') 
        Example [('train_ecg_03183.mat', 'N'), ('train_ecg_03184.mat', "~"), ('train_ecg_03185.mat', 'A'),
                  ('train_ecg_03186.mat', 'N'), ('train_ecg_03187.mat', 'O')]
	folder : str
		save destination folder for predctions
    Returns
    -------
    None.

    """    
	# Check Parameter
    assert isinstance(predictions, list), \
        "Parameter predictions musst be of type List, but {} given.".format(type(predictions))
    assert len(predictions) > 0, 'Parameter predictions must be non-empty list.'
    assert isinstance(predictions[0], tuple), \
        "Elements of list predictions must be of type Tuple, but {} given.".format(type(predictions[0]))
	
    if folder==None:
        file = "PREDICTIONS.csv"
    else:
        file = os.path.join(folder, "PREDICTIONS.csv")
    # Check ob Datei schon existiert wenn ja loesche Datei
    if os.path.exists(file):
        os.remove(file)

    with open(file, mode='w', newline='') as predictions_file:

        # Init CSV writer um Datei zu beschreiben
        predictions_writer = csv.writer(predictions_file, delimiter=',')
        # Iteriere über jede prediction
        for prediction in predictions:
            predictions_writer.writerow([prediction[0], prediction[1]])
        # Gebe Info aus wie viele labels (predictions) gespeichert werden
        print("{}\t Labels wurden geschrieben.".format(len(predictions)))
