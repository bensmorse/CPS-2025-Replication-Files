README

LIB_MK4_processed_data_baseline: This is the clean baseline data, with all outcomes constructed following the mpap codebook. It is the output of "$LIB_MK4/06_Code/LIB_MK4_01_cleaning_code_baseline_survey.do". It will be used for descriptives and for showing baseline balance. 

LIB_MK4_processed_data_baseline_commlevel: This is the clean baseline data, collapsed to the community level. It gets merged to the endline data, and community level lagged DVs are used in the analysis (since the study is not an individual level panel). This file is prouced by "$LIB_MK4/08_Code/LIB_MK4_03_cleaning_code_baseline_survey.do". 

LIB_MK4_processed_data_endline: This is the clean endline data, with all outcomes constructed following the mpap codebook. It is the output of "$LIB_MK4/06_Code/LIB_MK4_03_cleaning_code_endline_survey.do". It is the main file used in the analysis.

LIB_MK4_processed_data_lnp_admin.dta: This is clean lip admin data on crime reports. It gets merged to the endline survey data in LIB_MK4_08_analysis_code

