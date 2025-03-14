/***************************************************************************
*			Title: LIB_MK4 MASTER DO FILE
*			Inputs:  
*			Outputs:  
*			Notes: 
****************************************************************************/



// SET PROJECT GLOBAL 
	
	gl LIB_MK4 "YOUR DIRECTORY\08_CPS_Replication\"
	
	version 15
			
	// CLEAN BASELINE DATA, CONSTRUCT OUTCOMES
		/* Inputs:  /03_Raw De-Indentified Data/LIB_MK4_raw_data_baseline.csv */
		/* Outputs:  /05_Processed Data/LIB_MK4_processed_data_baseline.dta */
	
		do "$LIB_MK4/06_Code/LIB_MK4_01_cleaning_code_baseline_survey.do"
	
	
	// CLEAN ENDLINE DATA, CONSTRUCT OUTCOMES
		/* Inputs:  /03_Raw De-Indentified Data/LIB_MK4_raw_data_baseline.csv */
		/* Outputs:  /05_Processed Data/LIB_MK4_processed_data_baseline.dta */
	
		/* label variables */
		do "$LIB_MK4/06_Code/LIB_MK4_02_cleaning_code_endline_survey.do"
		/* cleana& construct indices */
		do "$LIB_MK4/06_Code/LIB_MK4_03_cleaning_code_endline_survey.do"
	
	// CLEAN LNP ADMINISTRATIVE CRIME DATA
		
		do "$LIB_MK4/06_Code/LIB_MK4_04_cleaning_code_LNP_admin.do"
	
	// CLEAN MOB VIOLENCE SURVEY DATA
		
		do "$LIB_MK4/06_Code/LIB_MK4_05_cleaning_code_mob_violence_survey.do"
	
	// MERGE ALL DATA INTO ONE ANALYSIS READY DATASET
	
		do "$LIB_MK4/06_Code/LIB_MK4_06_cleaning_code_merge_all_data.do"
	
	// ANALYSIS
		/* generates all tables, and results for plots Figures 1-3 */
		
		do "$LIB_MK4/06_Code/LIB_MK4_07_data_analysis_code.do"

	// Plot Figures 1 - 3
	
		/* run MK4_08_construct_figures.r */
		/* this file takes results generated in 07_data_analysis_code.do and plots as figures */ 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
