/***************************************************************************
*			Description: Cleaning file for LIB_MK4 Endline Survey Data
*			Inputs:  06_Raw Administrative Data/LIB_MK4_raw_data_lnp_admin.csv
*			Outputs:  /07_Processed Data/LIB_MK4_processed_data_lnp_admin.dta
*			Notes: This file
*				1. runs on raw de identified lnp admin data on crime reports
*				2. constructs outcome variables for hypothesis tk
*				3. saves the analysis-ready dataset as /07_Processed Data/LIB_MK4_processed_data_endline.dta
****************************************************************************/
	
	
insheet using "$LIB_MK4/04_Raw Administrative Data/LIB_MK4_raw_data_lnp_admin.csv",clear


	tab charge if other==1
	gen other_violent = cond(charge=="ARSON" | charge =="CORRUPTION OF MINOR" | charge=="CRIMINAL COERCION" ///
	| charge=="FELONIOUS RESTRAINT" | charge=="HUMAN TRAFFICKING" | charge=="KIDNAPPING" /// 
	| charge=="MANSLAUGHTER" | charge=="MENACING" | charge=="NEGLIGENT HOMICID" /// 
	| charge=="TERRORISTIC THREAT" | charge=="TERRORISTIC THREATS",1,0)
			
	gen other_nonviolent = cond(other==1 & other_violent==0,1,0)

// CONVERT DATASET FROM CRIME LEVEL TO COMMUNITY-LEVEL

	// FIRST, WE CREATE 6 MONTH WINDOWS CORRESPONDING TO "BASELINE" AND "ENDLINE"


		/* NOTE THE STUDY TIMELINE: 
		JULY 2017 - BASELINE SURVEY
		FEBRUARY 2018 - START OF INTERVENTION
		OCTOBER / NOVEMBER 2018 - END OF INTERVENTION
		JANUARY / FEBRUARY 2019 - ENDLINE SURVEY
		CRIME REPORTS COVER JUNE 2017 THROUGH OCTOBER 2018
		*/
		
		/* "baseline" refers to 6 months prior to start of intervention */

		gen baseline = cond((year==2017 &  month >7) | (year==2018 & month==1),1,0)

		/* "endline" refers to last 6 months of intervention */

		gen endline = cond(year==2018 &  month>4,1,0)

	//  BASELINE and ENDLINE CRIME COUNTS
	
			foreach x of varlist armedrob burglary aggassault simpleassault sexual domestic_phys domestic_verbal land land_violent mob riot murder other other_violent other_nonviolent {
			
				/* baseline crimes */
				gen cb_a`x'=`x'*baseline
				
				/* endline crimes */
				gen a`x'=`x'*endline
			
			}
			
			
			
	/* COLLAPSE DATA, CREATING TOWN-LEVEL CRIMES COUNTS AT BASELINE AND ENDLINE */
	
		collapse (sum) cb_* a*, by (towncode)	
			
	/* vars are now counts, rather than indicators. rename accordingly */
	
		renvars cb_* a*,  suffix(_num)
				
	
	/* WE NOW HAVE A TOWN-LEVEL DATASET */
	/* HOWEVER, TOWNS WITH NO REPORTED CRIMES ARE MISSING */
	/* SO WE MERGE THEM IN: */
	
		preserve
		insheet using "$LIB_MK4/01_Randomization/LIB_MK4_sample.csv",clear
		keep towncode
		tempfile sample
		save `sample',replace
		restore
		
		merge m:1 towncode using `sample',gen(samplemerge)
	

	/* replace [x]_crime_num with 0 */
	foreach x of varlist cb_aarmedrob_num - aother_nonviolent_num {
	
		replace `x'=0 if samplemerge==2
	
	}
	
	
	/* lastly, construct total crime counts */
	
	egen cb_acrime_num = rowtotal(cb_aarmedrob_num cb_aburglary_num cb_aaggassault_num cb_asimpleassault_num cb_asexual_num cb_adomestic_phys_num cb_adomestic_verbal_num cb_aland_num cb_aland_violent_num cb_ariot_num cb_aother_num) 
	egen cb_aviolentcrime_num = rowtotal(cb_aarmedrob_num cb_aburglary_num cb_aaggassault_num cb_asimpleassault_num cb_asexual_num cb_adomestic_phys_num cb_aland_violent_num cb_ariot_num) 
	
	
	egen acrime_num = rowtotal(armedrob_num aggassault_num aarmedrob_num aburglary_num ///
	aaggassault_num asimpleassault_num asexual_num adomestic_phys_num adomestic_verbal_num ///
	aland_num aland_violent_num amob_num ariot_num amurder_num aother_num) 
	
	/* egen aviolentcrime_num = rowtotal(armedrob_num aggassault_num aarmedrob_num aburglary_num ///
	aaggassault_num asimpleassault_num asexual_num adomestic_phys_num aland_violent_num ///
	amob_num ariot_num amurder_num) */

	egen aviolentcrime_num = rowtotal(armedrob_num aggassault_num asimpleassault_num asexual_num adomestic_phys_num ///
	amurder_num aother_violent_num) 
	
	egen anonviolentcrime_num = rowtotal(aburglary_num aother_nonviolent_num) 
	
	drop samplemerge
	
	save "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_lnp_admin.dta",replace
	
	
	
	

