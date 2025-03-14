/***************************************************************************
*			Description: Analysis file for LIB_MK4
*			Inputs:  
*			Outputs:  
*			Notes: 
****************************************************************************/


	use "$LIB_MK4/05_Processed Data/LIB_MK4_analysis.dta",clear				
		
	gl ctrls male age hhsize_big rel_Christian educ literate
	/*note: PAP specifies no indv level controls*/
		

/***************************************	
// Table 2 - Intensity of treatment
****************************************/	
	
	gl y_compliance s_compliance_idx compliance_patrol_dum compliance_freq_dum compliance_meeting
	
	eststo clear
	

	des $y_compliance
	foreach y in $y_compliance  {
	

		eststo: areg `y' treatment cb_compliance_idx /* $ctrls */ [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
		qui sum `y' if treatment==0
		estadd scalar Ctrl_mean = r(mean)	
	
	}
	
	esttab _all, keep(treatment) se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label
	
	
	esttab _all using "$LIB_MK4/07_Results/tables/Table2_compliance.tex", tex keep(treatment) se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
		
	// FULL TABLE FOR THE APPENDIX Table A.6
	
	esttab _all using "$LIB_MK4/07_Results/tables/app_a6_compliance_ctrls.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	

	
	
/***************************************	
// FIGURE 1: MECHANISMS
****************************************/	

		
	gl y_costs know_pol_idx know_idx_lbr intentions_idx_lbr norm_idx_lbr
	gl y_benefits police_capacity_idx pol_responsiveness_lbr
	gl y_coproduction ca_sec_idx sup_mobviol_idx know_cwt_idx
	gl y_mechanisms $y_costs $y_benefits $y_coproduction

	eststo clear
	
	foreach y in $y_mechanisms  {
	

		capture confirm variable cb_`y'
		
		/*if DV measured at baseline, included lagged DV*/
		if !_rc {
			eststo: areg `y' treatment cb_`y' [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			//eststo: areg `y' treatment cb_`y' [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)

		}
			
		/*if DV not measured at baseline, omitted lagged DV*/
		else {
			eststo: areg `y' treatment [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			//eststo: areg `y' treatment $ctrls [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)

		}

	}
	
				
	/* OUTSHEET RESULTS */
		
		esttab est1 est2 est3 est4 est5, keep(treatment) se(2) b(2)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )
		esttab est6 est7 est8 est9, keep(treatment) se(2) b(2)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )
		
	/* outsheet results for plotting figure in R*/

	esttab _all using "$LIB_MK4/07_Results/figure1_mechanisms.csv", keep(treatment) se(3) b(3) noobs depvar plain replace

	// FULL TABLE FOR THE APPENDIX Table A.7 and A.8
	
	esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a7_figure1_mechanisms_row1.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	
	esttab est6 est7 est8 est9 using "$LIB_MK4/07_Results/tables/app_a8_figure1_mechanisms_row2.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	
		
		
		
/***************************************	
// FIGURE 2: EFFECTS ON COPRODUCTION DISAGGREGATED BY COMPONENT VARIABLES FOR INDICES			
***************************************/

			
		gl y_ca_sec_idx sec_mtg_1m sec_mtg_attend_1m sec_patrol_1m sec_patrol_attend_1m sec_patrol_contr_1m cwteam cwteamnightpatrol_dum cwteammtgs_dum cwteamregistered
		gl y_sup_mobviol_idx mobviol1_dum mobviol2_dum mobviol3_dum
		gl y_know_cwt_idx know_cwt_cutlass_correct know_cwt_beat_correct know_cwt_risk_correct know_cwt_checkpoint_correct know_cwt_jurisdiction_correct know_cwt_arrest_correct 

		
		eststo clear
		foreach y in $y_ca_sec_idx {
	
		eststo: areg `y' treatment cb_ca_sec_idx /*$ctrls*/ [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
		
		}
		foreach y in $y_sup_mobviol_idx {
	
		eststo: areg `y' treatment cb_sup_mobviol_idx /*$ctrls*/ [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
		
		}
		foreach y in $y_know_cwt_idx {
	
		eststo: areg `y' treatment cb_know_cwt_idx /*$ctrls*/ [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
		
		}
		
		
	/* OUTSHEET RESULTS */
		
		esttab est1 est2 est3 est4 est5, keep(treatment) se(2) b(2)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )
		esttab est6 est7 est8 est9 est10, keep(treatment) se(2) b(2)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )
		esttab est11 est12 est13 est14 est15, keep(treatment) se(2) b(2)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )
		esttab est16 est17 est18, keep(treatment) se(2) b(2)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )
		
	/* outsheet results for plotting figure in R*/
		
		esttab _all using "$LIB_MK4/07_Results/figure2_coproduction.csv", keep(treatment) se(3) b(3) noobs depvar plain replace
				
	// FULL TABLE FOR THE APPENDIX Table A.9 to A.12
				
	esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a9_figure2_coproduction_row1.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	
	esttab est6 est7 est8 est9 est10 using "$LIB_MK4/07_Results/tables/app_a10_figure2_coproduction_row2.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	
	esttab est11 est12 est13 est14 est15 using "$LIB_MK4/07_Results/tables/app_a11_figure2_coproduction_row3.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	
	esttab est16 est17 est18 using "$LIB_MK4/07_Results/tables/app_a12_figure2_coproduction_row4.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	

	
	
/*******************************************				
	// FIGURE 3: EFFECTS ON PRIMARY OUTCOMES
***************************************/
				
				
	gl y_cooperation crimeres_idx_lbr crime_tips_idx_lbr police_abuse_report_idx_lbr
	gl y_security s_crime_num_lbr future_security_idx_lbr satis_idx cmob_num


		// store p-values for B-H p-value adjust
		
		matrix storeMyP = J(7, 1, .)  //create empty matrix with 7 (as many variables as we are looping over) rows, 1 column
		matrix list storeMyP  //look at the matrix
		loc n = 0 //count the iterations
	
	
		eststo clear
		foreach y in $y_cooperation  $y_security  {
					
		loc n = `n' + 1  //each iteration, adjust the count

		capture confirm variable cb_`y'
		
		/*if DV measured at baseline, included lagged DV*/
		if !_rc {
			//eststo: areg `y' treatment cb_`y' [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			eststo: areg `y' treatment cb_`y' $ctrls [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			  test treatment //this does an F-test, but for one variable it's equivalent to a t-test (check: -help test- there is lots this can do)
			  matrix storeMyP[`n', 1] = `r(p)'  //save the p-value in the matrix 
			estadd scalar p_value = `r(p)'
		}
			
		/*if DV not measured at baseline, omitted lagged DV*/
		
		else {
			//eststo: areg `y' treatment [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			eststo: areg `y' treatment $ctrls [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			  test treatment //this does an F-test, but for one variable it's equivalent to a t-test (check: -help test- there is lots this can do)
			  matrix storeMyP[`n', 1] = `r(p)'  //save the p-value in the matrix 
			estadd scalar p_value = `r(p)'
			
		}	
		}
		
		matrix list storeMyP  // look at your p-values 
		// send these p-values over to R for BH p-value calculation via p.adjust command
		// resulting adjusted p-values: 0.932 0.850 0.932 0.932 0.850 0.850 0.011
		// note that having duplicate p-values is not an error -- it's a not uncommon result of the adjustment algorithm
			
		
	/* OUTSHEET RESULTS */
		
	esttab est1 est2 est3 est4, keep(treatment) se(2) b(2)  depvar replace star(+ 0.10 * 0.05 ** .01 *** .001 ) stats(p_value, fmt(3) labels(`"P value"' )) 	
	esttab est5 est6 est7, keep(treatment) se(2) b(2)  depvar replace star(+ 0.10 * 0.05 ** .01 *** .001 ) stats(p_value, fmt(3) labels(`"P value"' )) 	
	
	/* outsheet results for plotting figure in R*/
	
	esttab _all using "$LIB_MK4/07_Results/figure3_primaryoutcomes.csv", keep(treatment) se(2) b(2) noobs depvar plain replace stats(p_value, fmt(5) labels(`"P value"' )) 
	
	
	// FULL TABLE FOR THE APPENDIX Table A.13 to A.14
				
	esttab est1 est2 est3 est4 using "$LIB_MK4/07_Results/tables/app_a13_figure3_primary_row1.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	
	esttab est5 est6 est7 using "$LIB_MK4/07_Results/tables/app_a14_figure3_primary_row2.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) scalars(Ctrl_mean) obslast label ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") ///
		mtitles("Intensity of treatment index" "Sees foot patrols daily or weekly" "Sees vehicle patrols daily or weekly" "Attended police mtg past 6m")
	
	
	
/*************************
// Table 3 Effect on mob violence (police survey)		
*************************/	
	
	
	eststo clear
	eststo: reg num_mob_viol treatment if towncount==1	
	eststo: areg num_mob_viol treatment if towncount==1, ab(policezone)	
	esttab _all, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 )
	esttab _all using "$LIB_MK4/07_Results/tables/table3_mobviolence.tex", tex se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 )
	
	
	
	
	
/*************************
// TABLE 4 T vs C Differences in local security groups
*************************/	
		
	gen local_security_group=cond(sec_mtg_attend_1m==1 | sec_patrol_attend_1m==1 ,1,0)
	
	eststo clear
	foreach y of varlist know_pol_idx know_idx_lbr intentions_idx_lbr norm_idx_lbr police_capacity_idx pol_responsiveness_lbr sup_mobviol_idx know_cwt_idx {
		
	eststo: areg `y' treatment if local_security_group==1, ab(policezone) cl(towncode)
		
	}
		
	esttab est1 est2 est3 est4, se(2) b(2) keep(treatment)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )  
	esttab est5 est6 est7 est8, se(2) b(2) keep(treatment)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )  		
	
	esttab est1 est2 est3 est4 using "$LIB_MK4/07_Results/tables/table4_groups_orientation_row1.tex", se(2) b(2) keep(treatment)   depvar replace star(+ 0.10 * 0.05 ** .01 *** .001 )  tex  nol 
	esttab est5 est6 est7 est8 using "$LIB_MK4/07_Results/tables/table4_groups_orientation_row2.tex", se(2) b(2) keep(treatment)   depvar replace star(+ 0.10 * 0.05 ** .01 *** .001 )  tex  nol 
		
	

	
	
/**********************
*** APPENDIX ANALYSIS
*********************/	


/************************************
ENDLINE DESCRIPTIVES - APPENDIX TABLES A.1 TO A.3
*****************************/
			
	// MECHANISMS

	gl demographics male age rel_Christian edu_none edu_abc edu_jh edu_hs edu_post literate
	gl y_know_pol_idx know_wacps_correct know_psd_correct know_csd_name_correct know_wacps_name_correct know_psd_name_correct know_localcommander know_anyofficer know_policenumber
	gl y_know_idx_lbr know_law_statrape_correct know_law_habeasc_correct know_law_lawyer_correct know_law_complain_correct know_law_childsup_correct know_law_suspect_correct know_law_fees_correct know_law_bondfee_correct
	gl y_intentions_idx_lbr polint_corrupt_agree polint_quality_agree polcaseserious_agree polcasefair_agree pol_care_agree polint_digresp_agree polint_decfact_agree polcaserespect_agree
	gl y_norm_idx_lbr reportnorm_theft_agree reportnorm_abuse_agree reportnorm_land_agree obeynorm_agree helppolnorm_armedrob_agree helppolnorm_domviol_agree helppolnorm_moto_agree helppolnorm_childabuse_agree
	gl y_police_capacity_idx polcap_timely_agree polcap_investigate_agree
	gl y_pol_responsiveness_lbr responsive_act_agree responsive_listen_agree
	gl y_ca_sec_idx sec_mtg_1m sec_mtg_attend_1m sec_patrol_1m sec_patrol_attend_1m sec_patrol_contr_1m cwteam cwteamnightpatrol_dum cwteammtgs_dum cwteamregistered
	gl y_sup_mobviol_idx mobviol1_dum mobviol2_dum mobviol3_dum
	gl y_know_cwt_idx know_cwt_cutlass_correct know_cwt_beat_correct know_cwt_risk_correct know_cwt_checkpoint_correct know_cwt_jurisdiction_correct know_cwt_arrest_correct 

	//  EFFECTS ON PRIMARY OUTCOMES BROKEN DOWN BY CATEGORY

	gl y_crimeres_idx_lbr landres_pol landresviol_pol burglaryres_pol dviolres_pol armedrobres_pol
	gl y_crime_tips_idx_lbr contact_pol_susp_activity contact_pol_find_suspect give_info_pol_investigation testify_police_investigation
	gl y_police_abuse_report_idx_lbr checkpoint_report_likely dutydrink_report_likely policebeating_report_likely			
	gl y_crime_num_lbr armedrob_num_sc burglary_num_sc aggassault_num_sc simpleassault_num_sc sexual_num_sc domestic_phys_num_sc domestic_verbal_num_sc land_viol_num_sc land_nviol_num_sc  cmurder_num cchildabuse_num
	gl y_future_security_idx_lbr fear_violent_yes fear_nonviolent_yes feared_walk_yes feared_home_yes hssecure_yes hsitemssecure_yes motosecure_yes generatorsecure_yes
	gl y_satis_idx satis_trust_agree satis_general_agree

	/* too many vars to fit on a page; split into three tables */
	gl app_descriptives1 $demographics $y_know_pol_idx $y_know_idx_lbr $y_intentions_idx_lbr   
	gl app_descriptives2 $y_norm_idx_lbr $y_police_capacity_idx  $y_pol_responsiveness_lbr $y_sup_mobviol_idx $y_ca_sec_idx $y_know_cwt_idx
	gl app_descriptives3 $y_crimeres_idx_lbr $y_crime_tips_idx_lbr $y_police_abuse_report_idx_lbr $y_crime_num_lbr $y_future_security_idx_lbr $y_satis_idx

	des $app_descriptives1
	des $app_descriptives2
	des $app_descriptives3
			
	preserve
	keep $app_descriptives1 
	placevar $app_descriptives1, f
	outreg2 using "$LIB_MK4/07_Results/tables/app_a1_table.tex",  replace sum(log) keep($app_descriptives1) auto(2) eqkeep(mean N) label tex(frag)	
		cap erase "$LIB_MK4/07_Results/tables/app_a1_table.txt"
	restore
	
	preserve
	keep $app_descriptives2 
	placevar $app_descriptives2, f
	outreg2 using "$LIB_MK4/07_Results/tables/app_a2_table.tex",  replace sum(log) keep($app_descriptives2) auto(2) eqkeep(mean N) label tex(frag)	
		cap erase "$LIB_MK4/07_Results/tables/app_a2_table.txt"
	restore
	
	preserve
	keep $app_descriptives3 
	placevar $app_descriptives3, f
	outreg2 using "$LIB_MK4/07_Results/tables/app_a3_table.tex",  replace sum(log) keep($app_descriptives3) auto(2) eqkeep(mean N) label tex(frag)	
		cap erase "$LIB_MK4/07_Results/tables/app_a3_table.txt"
	restore
	
	

/************************************
TESTS OF BALANCE - APPENDIX TABLES A.4 - A.5
*****************************/
	
	
preserve
	
// LOAD TOWN-LEVEL TREATMENT ASSIGNMENT DATA	
	
	insheet using "$LIB_MK4/01_Randomization/LIB_MK4_sample.csv",clear
	tempfile assignment
	save `assignment',replace	
	

// LOAD BASELINE DATA AND MERGE WITH ADMIN DATA

	use "$LIB_MK4\05_Processed Data\LIB_MK4_processed_data_baseline.dta", clear

		merge m:1 towncode using `assignment',gen(adminmerge)
		list communityname policezone if adminmerge==2		
		drop if adminmerge==2
		
		/* Intervention not conducted in Police Zone 6. Police Zone 6 dropped from sample */
			drop if policezone=="ZONE 6"
		
// BASELINE BALANCE TESTS

	/* CODE SOURCE: https://www.stata.com/statalist/archive/2009-01/msg01084.html */
	
	gl ctrls male age rel_Christian education literate
	gl y_costs know_pol_idx know_idx_lbr intentions_idx_lbr norm_idx_lbr
 	gl y_benefits police_capacity_idx responsive_act
	gl y_coproduction ca_sec_idx sup_mobviol_idx
	gl y_cooperation crimeres_idx_lbr crime_tips_idx_lbr police_abuse_report_idx_lbr
	gl y_crime crime_num_lbr cmob_num future_security_idx_lbr
	
	
	/* STANDARD VARIABLES FOR COMPARABILITY*/
	
	foreach x of varlist $y_costs $y_benefits $y_coproduction $y_cooperation $y_crime {
		
		qui sum `x',d
		replace `x'=(`x'-`r(mean)')/`r(sd)'
	
	}

	
	eststo clear	

	foreach y of varlist $ctrls $y_costs $y_benefits $y_coproduction $y_cooperation $y_crime {
	eststo `y': quietly areg `y' treatment, cl(towncode) ab(policezone)
	}

	esttab, se nostar
	matrix C = r(coefs) 


//for unknown reason, code below reverses sign of treatment coef so that it appears as C-T difference in means rather than T-C difference in means


eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0

foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}


esttab, se mtitle("T-C Difference in means" "Control mean") b(2)
esttab using "$LIB_MK4/07_Results/tables/app_a4a5_tests_of_balance.tex", se mtitle("Difference in means" "Control mean") b(2) tex replace nogaps

restore
	
	
	
/************************************
INTENSITY OF TREATMENT - APPENDIX TABLES A.6
*****************************/

	*see code for Table 1, above
	
	
/************************************
FIGURE 1 IN TABLE FORMAT - APPENDIX TABLES A.7 TO A.8
*****************************/

	*see code for figure 1, above

	
/************************************
FIGURE 2 IN TABLE FORMAT - APPENDIX TABLES A.9 TO A.12
*****************************/

	*see code for figure 2, above	

	
/************************************
FIGURE 3 IN TABLE FORMAT - APPENDIX TABLES A.13 TO A.14
*****************************/

	*see code for figure 3, above	
	
	
	
/******************************************************
*** APPENDIX SECTION 10 -  EFFECTS ON MECHANISMS BROKEN DOWN BY CONSTITUENT VARIABLES *****
******************************************************/
 
		
		// TABLE A.15 to A.16 FAMILIARITY WITH POLICE
		
		gl y_know_pol_idx know_wacps_correct know_psd_correct know_csd_name_correct know_wacps_name_correct know_psd_name_correct know_localcommander know_anyofficer know_policenumber
		

		eststo clear
		foreach y in know_pol_idx $y_know_pol_idx {
		
		eststo: areg `y' treatment cb_know_pol_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}

		
		esttab est1 est2 est3 est4 est5, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
		esttab est6 est7 est8 est9, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
			

		esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a15_know_pol_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Familiarity with police index" "Knows about WACPS" "Knows about PSD" "Knows about CSD" "Knows WACPS by name")
		
		esttab est6 est7 est8 est9 using "$LIB_MK4/07_Results/tables/app_a16_know_pol_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Knows PSD by name" "Knows Commander by name" "Knows officer by name" "Knows officer's number")
				
			
		
		
	// A.17 TO A.18 KNOWLEDGE OF THE LAW
	
	
	gl y_know_idx_lbr know_law_statrape_correct know_law_habeasc_correct know_law_lawyer_correct know_law_complain_correct know_law_childsup_correct know_law_suspect_correct know_law_fees_correct know_law_bondfee_correct

	
		eststo clear
		foreach y in know_idx_lbr $y_know_idx_lbr {
		
		eststo: areg `y' treatment cb_know_law_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}

		
		esttab est1 est2 est3 est4 est5, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
		esttab est6 est7 est8 est9, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		

		esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a17_know_law_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles ("Knowledge of law index" "Knows statutory rape illegal" "Knows about habeas corpus" "Knows right to lawyer" "Knows rights when reporting")
		
		esttab est6 est7 est8 est9 using "$LIB_MK4/07_Results/tables/app_a18_know_law_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles ("Knows about child support" "Knows obligation to report" "Knows informal fees illegal" "Knows bond fees illegal")
				
		
		
		
	// Table A.19 to A.20 PERCEPTIONS OF POLICE INTENTIONS	
		
	gl y_intentions_idx_lbr polint_corrupt_agree polint_quality_agree polcaseserious_agree polcasefair_agree pol_care_agree polint_digresp_agree polint_decfact_agree polcaserespect_agree
		
		eststo clear
		foreach y in intentions_idx_lbr $y_intentions_idx_lbr {
		
		eststo: areg `y' treatment cb_intentions_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
	
		
		esttab est1 est2 est3 est4 est5, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
		esttab est6 est7 est8 est9, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
		
		
		esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a19_intentions_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles ("Police intentions Index" "Police corrupt?" "Police treat all equal?" "Police take cases seriously?" "Police fair to all sides?")
		
		esttab est6 est7 est8 est9 using "$LIB_MK4/07_Results/tables/app_a20_intentions_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles ("Police care about citizens' safety?" "Police respect citizens?" "Police objective?" "Police respect victims?")


	// Table A.21 to A.22 NORMS SUPPORTING COOPERATION
	
	
		gl y_norm_idx_lbr reportnorm_theft_agree reportnorm_abuse_agree reportnorm_land_agree obeynorm_agree helppolnorm_armedrob_agree helppolnorm_domviol_agree helppolnorm_moto_agree helppolnorm_childabuse_agree
			
		eststo clear
		foreach y in norm_idx_lbr $y_norm_idx_lbr {
		
		eststo: areg `y' treatment cb_norm_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
	
		
		esttab est1 est2 est3 est4 est5, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
		esttab est6 est7 est8 est9, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
			
		
		
		esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a21_norm_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Cooperation norms index" "A burglary?" "Domestic violence?" "Land disputes?" "Ppl should always obey the police")
		
		esttab est6 est7 est8 est9 using "$LIB_MK4/07_Results/tables/app_a22_norm_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Armed robbery?" "Domestic violence?" "Stolen motorcycle?" "Child abuse?")

		
	// Table A.23 PERCEPTIONS OF POLICE CAPACITY	
		
		
		gl y_police_capacity_idx polcap_timely_agree polcap_investigate_agree
		
		eststo clear
		foreach y in police_capacity_idx $y_police_capacity_idx {
		
		eststo: areg `y' treatment cb_police_capacity_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
		
		esttab est1 est2 est3, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		esttab est1 est2 est3 using "$LIB_MK4/07_Results/tables/app_a23_police_capacity_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Police capacity index" "Police able to respond quickly?" "Police able to investigate effectively?")
	
	
	
	
	// Table A.24 PERCEPTIONS OF POLICE RESPONSIVENESS
	
		gl y_pol_responsiveness_lbr responsive_act_agree responsive_listen_agree
	
		eststo clear
		foreach y in pol_responsiveness_lbr $y_pol_responsiveness_lbr {
		
		eststo: areg `y' treatment cb_pol_responsiveness_lbr [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
		
		esttab est1 est2 est3, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		esttab est1 est2 est3 using "$LIB_MK4/07_Results/tables/app_a24_pol_responsiveness_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Police responsiveness index" "Police act on citizens' feedback?" "Police include citizens in decision making?")
		
	
	// A.25 to A.26 CONTRIBUTIONS TO COMMUNITY COPRODUCTION
	
	
		gl y_ca_sec_idx sec_mtg_1m sec_mtg_attend_1m sec_patrol_1m sec_patrol_attend_1m sec_patrol_contr_1m cwteam cwteamnightpatrol_dum cwteammtgs_dum cwteamregistered
	

		eststo clear
		foreach y in ca_sec_idx $y_ca_sec_idx {
		
		eststo: areg `y' treatment cb_ca_sec_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
		

		esttab est1 est2 est3 est4 est5, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
		esttab est6 est7 est8 est9 est10, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
		
		
		esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a25_ca_sec_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles ("Coproduction contributions index" "Seen security mtg past month" "Attended security mtg past month" "Seen CWF patrol past month" "Attended CWF patrol past month")
		
		esttab est6 est7 est8 est9 est10 using "$LIB_MK4/07_Results/tables/app_a26_ca_sec_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles ("Gave food / tea past month" "Town has watch forum" "Forum patrols at night" "Forum meets regularly" "Forum registered with police")
	
	
	
	// Table A.27 SUPPORT FOR MOB VIOLENCE
	
	
		gl y_sup_mobviol_idx mobviol1_dum mobviol2_dum mobviol3_dum
	

		eststo clear
		foreach y in sup_mobviol_idx $y_sup_mobviol_idx {
		
		eststo: areg `y' treatment cb_sup_mobviol_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
		
		esttab est1 est2 est3 est4, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		esttab est1 est2 est3 est4 using "$LIB_MK4/07_Results/tables/app_a27_sup_mobviol_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Support for mob violence index" "Mob violence justified for: rape?" "Mob violence justified for: armed robbery?" "Mob violence justified for: burglary?")
		
		
		
		
	// Table A.28 to A.29 KNOWLEDGE OF WATCH FORUM RULES
	
	
	gl y_know_cwt_idx know_cwt_cutlass_correct know_cwt_beat_correct know_cwt_risk_correct know_cwt_checkpoint_correct know_cwt_jurisdiction_correct know_cwt_arrest_correct 
		
		eststo clear
		foreach y in know_cwt_idx $y_know_cwt_idx {
		
		eststo: areg `y' treatment cb_know_cwt_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
		
		esttab est1 est2 est3 est4, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		esttab est5 est6 est7, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		
		
		esttab est1 est2 est3 est4 using "$LIB_MK4/07_Results/tables/app_a28_know_cwt_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Knowledge of security group rules index" "Weapons prohibited" "Physical harm prohibited" "Must avoid danger")

		esttab est5 est6 est7 using "$LIB_MK4/07_Results/tables/app_a29_know_cwt_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Checkpoints prohibited" "Only operate in home community" "Can perform citizens arrest")	
	
	
	
/*********************************************************
** EFFECTS ON PRIMARY OUTCOMES BROKEN DOWN BY CATEGORY ***
**********************************************************/
		
	
	// Table A.30 to A.31 WILLINGNESS TO REPORT CRIMES TO POLICE
	
	gl y_crimeres_idx_lbr landres_pol landresviol_pol burglaryres_pol dviolres_pol armedrobres_pol

		eststo clear
		foreach y in crimeres_idx_lbr $y_crimeres_idx_lbr {
		
		eststo: areg `y' treatment cb_crimeres_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
		
		
		esttab est1 est2 est3, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		esttab est4 est5 est6, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		
		esttab est1 est2 est3 using "$LIB_MK4/07_Results/tables/app_a30_crimeres_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Crime resolution index" "Land disputes?" "Violent land disputes?")
		
		esttab est4 est5 est6 using "$LIB_MK4/07_Results/tables/app_a31_crimeres_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles ("Burglaries?" "Domestic violence?" "Armed robbery?")
		
		
		
	
	// Table A.32 CRIME TIPS AND INFORMATION SHARING
	
	gl y_crime_tips_idx_lbr contact_pol_susp_activity contact_pol_find_suspect give_info_pol_investigation testify_police_investigation
	
		eststo clear
		foreach y in crime_tips_idx_lbr $y_crime_tips_idx_lbr {
		
		eststo: areg `y' treatment cb_crime_tips_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
		
		esttab est1 est2 est3 est4 est5, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		
		
		esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a32_crime_tips_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Crime tips \& info sharing index" "Reported suspicious activity past 6 months" "Helped police find suspect past 6 months" "Gave info for police investigation past 6 months" "Provided testimony past 6 months")
	
	
	
	
	
	// Table A.33 WILLINGNESS TO REPORT POLICE MISCONDUCT 
	
	gl y_police_abuse_report_idx_lbr checkpoint_report_likely dutydrink_report_likely policebeating_report_likely				
	
		eststo clear
		foreach y in police_abuse_report_idx_lbr $y_police_abuse_report_idx_lbr {
		
		eststo: areg `y' treatment cb_police_abuse_report_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
		
		esttab est1 est2 est3 est4, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
			
		esttab est1 est2 est3 est4 using "$LIB_MK4/07_Results/tables/app_a33_police_abuse_report_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Willingness to report police misconduct" "Would report illegal checkpoint" "Would report drunk officer" "Would report police beating")		
		
	
	
	
		
	// Tables A.34 to A.36 INCIDENCE OF CRIME	
		
		
	gl y_crime_num_lbr armedrob_num_sc burglary_num_sc aggassault_num_sc simpleassault_num_sc sexual_num_sc domestic_phys_num_sc domestic_verbal_num_sc land_viol_num_sc land_nviol_num_sc cmurder_num cchildabuse_num 
		
		
		eststo clear
		foreach y in crime_num_lbr $y_crime_num_lbr {
		
		eststo: areg `y' treatment cb_crime_num [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
			
			
		esttab est1 est2 est3 est4, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		esttab est5 est6 est7 est8, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		esttab est9 est10 est11 est12, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
			
			
		
		esttab est1 est2 est3 est4 using "$LIB_MK4/07_Results/tables/app_a34_crime_num_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Total \# crimes reported" "\# of armed robberies" "\# of burglaries" "\# of aggravated assaults")		
		
		esttab est5 est6 est7 est8 using "$LIB_MK4/07_Results/tables/app_a35_crime_num_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("\# of simple assaults" "\# of sexual violence" "\# of domestic violence" "\# of domestic verbal abuse")		
		
		esttab est9 est10 est11 est12 using "$LIB_MK4/07_Results/tables/app_a36_crime_num_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("\# of violent land disputes" "\# of non violent land disputes" "\# of murders" "\# of child abuse")		
		
		
		
		
		
	// Table A.37 to A.38PERCEPTIONS OF SECURITY	
		
	gl y_future_security_idx_lbr fear_violent_yes fear_nonviolent_yes feared_walk_yes feared_home_yes hssecure_yes hsitemssecure_yes motosecure_yes generatorsecure_yes
	gl y_satis_idx satis_trust_agree satis_general_agree	
		
		eststo clear
		foreach y in future_security_idx $y_future_security_idx_lbr {
		
		eststo: areg `y' treatment cb_future_insecurity_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
			
		esttab est1 est2 est3 est4 est5, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))
		esttab est6 est7 est8 est9, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		
		esttab est1 est2 est3 est4 est5 using "$LIB_MK4/07_Results/tables/app_a37_future_security_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Perceptions of security" "Fears violent crime" "Fears non violent crime" "Fears walking at night" "Fears home invasions")
		
		esttab est6 est7 est8 est9 using "$LIB_MK4/07_Results/tables/app_a38_future_security_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("House boundaries secure" "House items secure" "Motorbike secure" "Generator secure outside")
		
		
		
	// Table A.39 SATISFACTION WITH POLICE	
		
	gl y_satis_idx satis_trust_agree satis_general_agree	
		
		eststo clear
		foreach y in satis_idx $y_satis_idx {
		
		eststo: areg `y' treatment cb_satis_idx [pweight=1/(sampling_prob*assignment_prob)], ab(policezone) cl(towncode)
			test treatment
			estadd scalar p_value = `r(p)'	
			
		}
			
		esttab est1 est2 est3, se(2) b(2)  depvar  replace star(+ 0.10 * 0.05 ** .01 *** .001 ) ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' ))

		esttab est1 est2 est3  using "$LIB_MK4/07_Results/tables/app_a39_satis_idx.tex", se(2) b(2) depvar tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(N p_value, fmt(0 2) labels(`"N"' `"P value"' )) ///
		nolabel nonotes addnotes("Weighted least squares with block fixed effects, following Section 5.3 of the main text. Cluster robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\). ") ///
		mtitles("Satisfaction w. police performance index" "Trusts police" "Satisfied w. police performance")			
		
		

/*****************
APPENDIX 12 RESULTS FOR ANALYSES INCLUDED IN PAP BUT EXCLUDED FROM PAPER
******************/	


	// Table A.40 secondary outcomes excluded from paper
	
	
	la var legit_trust "Trust in government"
	la var trust_community "Trust in other community members"

		eststo clear
		foreach y in legit_trust trust_community {
		
		/* no controls */
		eststo: areg `y' treatment, ab(policezone) cl(towncode)
			estadd scalar Obs = e(N)
			qui sum `y' if treatment==0
			estadd scalar ctrl_mean = r(mean)
			local t = _b[treatment]/_se[treatment]
			estadd scalar p_value=2*ttail(e(df_r),abs(`t'))				
							
		}

		esttab _all, keep(treatment) se(2) b(2)  depvar label replace star(+ 0.10 * 0.05 ** .01 *** .001 )  stats(Obs ctrl_mean, fmt(0 2) labels(`"N"' `"Ctrl mean"')) 
		
		
		esttab _all using "$LIB_MK4/07_Results/tables/app_a40_secondaryoutcomes.tex", ///
		keep(treatment) se(2) b(2) depvar label tex replace star(+ 0.10 * 0.05 ** .01 *** .001 )  ///
		stats(Obs ctrl_mean p_value, fmt(0 2 2)  labels(`"N"' `"Ctrl mean"' "P-value"))  ///
		nonotes addnotes("Robust standard errors in parenthesis, clustered by community. \sym{+} \(p<0.10\), \sym{*} \(p<0.05\), \sym{**} \(p<.01\), \sym{***} \(p<.001\)") 


	
	





		
		
	