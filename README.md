# musicGenrePrediction
Repo contains full feature extraction and analysis Matlab code set for cluster-based automated genre classification on a large library of songs. 
Requires: MA toolbox (http://www.pampalk.at/ma/) which requires the Netlab toolbox (http://www.aston.ac.uk/eas/research/groups/ncrg/resources/netlab/) in turn.

Typical run setup: 
-Run algoSettingsTop.m to generate data paths, feature extraction settings 
-Use extractFeatures.m to generate full feature set of time series analytics for each song in the library. 
-Dimensionality reduction, training, and performance scoring performed by trainingModel.m 
-Support plotting utilities for feature and data visualization are included in \plotUtils.
