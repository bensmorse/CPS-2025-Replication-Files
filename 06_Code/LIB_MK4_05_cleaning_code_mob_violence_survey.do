/***************************************************************************
*			Description: Cleaning file for LIB_MK4 Endline Survey Data
*			Inputs:  
*			Outputs:  
*			Notes: This file
*				1. runs on raw de identified lnp admin data on crime reports
*				2. constructs outcome variables for hypothesis tk
*				3. saves the analysis-ready dataset as /07_Processed Data/LIB_MK4_processed_data_endline.dta
****************************************************************************/



	insheet using "$LIB_MK4/03_Raw De-Identified Data/MobViolenceSurvey_deid.csv",clear


	/* dataset includes incidents reported from communities across Monrovia -- here, we keep only those attributed to in-sample communities */
	
	keep if in_sample==1
	
	
	bysort towncode: gen num_mob_viol=_N
	la var num_mob_viol "Acts of mob violence in town past 8 months"
	
	bys towncode: gen count=_n
	keep if count==1
	keep towncode num_mob_viol
	
	
	save "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_mob_violence.dta",replace
	
	
