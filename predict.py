#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

Example script for prediction. Uses a learned threshold to classifiy ECG signals based on BBIs.


@author: Christoph Hoog Antink, Maurice Rohr
version ='1.0'
"""

import csv
import scipy.io as sio
import matplotlib.pyplot as plt
import numpy as np
from ecgdetectors import Detectors
import os
from typing import List, Tuple

###function signature (parameters and number of return values) must not be changed
def predict_labels(ecg_leads : List[np.ndarray], fs : float, ecg_names : List[str], model_name : str='model.npy',is_binary_classifier : bool=False) -> List[Tuple[str,str]]:
    '''
    Parameters
    ----------
    
    ecg_leads : list of numpy-Arrays
        ECG signals
    fs : float
        sampling frequency
    ecg_names : list of str
        identifier for each signal
    model_name : str
        optional parameter used to load the correct model
    is_binary_classifier : bool
        if there are different models for binary and 4 class problem to be scored (F1 or multilabel score),  this can be chosen True for the binary case (F1) and False for 4 class
    Returns
    -------
    predictions : list of tuples
        ecg_name and prediction
    '''

#------------------------------------------------------------------------------
# YOUR CODE HERE  
    with open(model_name, 'rb') as f:  
        th_opt = np.load(f)         # load simple model (1 Parameter)

    detectors = Detectors(fs)        # Initialization of the QRS detector

    predictions = list()
    
    for idx,ecg_lead in enumerate(ecg_leads):
        r_peaks = detectors.hamilton_detector(ecg_lead)     # detection of QRS complexes
        sdnn = np.std(np.diff(r_peaks)/fs*1000) 
        if sdnn < th_opt:
            predictions.append((ecg_names[idx], 'N'))
        else:
            predictions.append((ecg_names[idx], 'A'))
        if ((idx+1) % 100)==0:
            print(str(idx+1) + "\t files processed.")
            
            
#------------------------------------------------------------------------------    
    return predictions # Liste of tupels in format (ecg_name,label) - Must not be changed!
                               
                               
        
