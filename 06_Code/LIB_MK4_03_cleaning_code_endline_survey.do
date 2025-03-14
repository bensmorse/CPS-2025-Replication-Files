/***************************************************************************
*			Description: Cleaning file for LIB_MK4 Endline Survey Data
*			Inputs:  /03_Raw De-Indentified Data/LIB_MK4_raw_data_endline.csv
*			Outputs:  /05_Processed Data/LIB_MK4_processed_data_endline.dta
*			Notes: This file
*				1. calls up "LIB_MK4_04_cleaning_code_endline_survey.do", which labels and cleans data
*				2. constructs outcome variables for each hypothesis
*				3. constructs liberia specific outcomes
*				4. constructs covariates
*				5. saves the analysis-ready dataset as /05_Processed Data/LIB_MK4_processed_data_endline.dta
****************************************************************************/

	
/******* CONTENTS ************

MISCELLANEOUS CLEANING:
	CODE NA, RTA, AND DNK RESPONSES AS .a, .b, and .c
	
CONSTRUCT VARIABLES:
	H1A INCIDENCE OF CRIME
	H1B PERCEPTIONS OF SAFETY (PERSONAL, LAND, AND POSSESSIONS)
	H2 PERCEPTIONS OF POLICE
	H3A PERCEPTIONS OF POLICE EMPATHY, ACCOUNTABILITY, AND ABUSE AND CORRUPTION CONCERNS
	H4A. POSITIVE EFFECT ON REPORTING OF CRIME VICTIMIZATION	
	H4B COOPERATION IN CRIME PREVENTION / CRIME TIPS
	H4C. WILLINGNESS TO REPORT POLICE ABUSE		

	M1A BELIEFS ABOUT POLICE INTENTIONS
	M1B KNOWLEDGE OF CRIMINAL JUSTICE SYSTEM	
	M1C  NORMS OF CITIZEN COOPERATION WITH POLICE

	M2A  BELIEFS ABOUT POLICE CAPACITY / RETURNS TO COOPERATION
	M2B PERCEPTIONS OF RESPONSIVENESS TO CITIZEN FEEDBACK
	
	S1 TRUST IN THE STATE
	S2 COMMUNAL TRUST
	COMPLIANCE WITH TREATMENT: CITIZEN INTERACTIONS WITH POLICE
	
	LIBERIA SPECIFIC HYPOTHESES
	
	COVARIATES
	
COLLAPSE TO COMMUNITY-LEVEL DATASET
	
*****************************/	
	
	
/*******************************
// MISCELLANEOUS CLEANING
*******************************/

	/* 	CODE NA, RTA, AND DNK RESPONSES AS .a, .b, and .c */
	
	gl h1b_security fear_violent fear_nonviolent feared_walk feared_home
	gl h2_perceptions_police satis_trust satis_general
	gl norms_coop reportnorm_theft reportnorm_abuse obeynorm
	gl h4b_coop_crime_prevention contact_pol_susp_activity  contact_pol_find_suspect give_info_pol_investigation testify_police_investigation name_witness identify_hideout identify_ghetto guide_police give_testimony
	gl h4c_report_police_abuse checkpoint_report dutydrink_report policebeating_report
	gl m1a_intentions polint_corrupt polint_quality polcaseserious polcasefair pol_care polint_digresp polint_decfact polcaserespect
	gl m1b_knowledge know_wacps know_psd
	gl m1c_norms reportnorm_land obeynorm helppolnorm_armedrob helppolnorm_domviol helppolnorm_moto helppolnorm_childabuse
	gl m2a_police_capacity polcap_timely polcap_investigate
	gl m2b_responsiveness responsive_act responsive_listen
	gl s1_trust_in_state legit_trust
	gl s2_communal_trust trust_community days_comm_work cgroups trust_keys comm_help
	gl compliance compliance_patrol compliance_freq compliance_meeting
	gl liberia_specific_outcomes mobviol1 mobviol2 mobviol3 sec_mtg_attend_hyp sec_group_money_hyp sec_group_food_hyp sec_group_torch_hyp sec_group_attend_hyp sec_mtg_1m sec_mtg_attend_1m sec_patrol_1m sec_patrol_attend_1m sec_patrol_contr_1m cwteam cwteamnightpatrol cwteammtgs cwteamregistered ca_town_organized ca_town_ldrshelppol ca_town_worktogether ca_town_ldrsorganize town_chair_pplsame town_chair_corr town_chair_open 
	gl vignette vig_pol_professional vig_pol_respect vig_pol_satisfied vig_pol_thorough vig_pol_invest vig_pol_interview vig_pol_paysmall vig_pol_professional2 vig_pol_respect2 vig_pol_satisfied2 vig_pol_thorough2 vig_pol_invest2 vig_pol_interview2 vig_pol_paysmall2
		
	foreach x of varlist $h1b_security $norms_coop $h2_perceptions_police $h4b_coop_crime_prevention $h4c_report_police_abuse $m1a_intentions $m1b_knowledge $m1c_norms $m2a_police_capacity $m2b_responsiveness $s1_trust_in_state $s2_communal_trust $compliance $liberia_specific_outcomes $vignette {

		replace `x'=.a if `x'==97
		replace `x'=.b if `x'==98
		replace `x'=.c if `x'==88

	}
	
	
	/* Standardize variables for indices by baseline mean and sd */
	/* note: for some indices, we standarized later, below, after constructing input vars at endline */
	
	foreach x of varlist $h1b_security $h2_perceptions_police $h4b_coop_crime_prevention $h4c_report_police_abuse $m1a_intentions $m2a_police_capacity $m2b_responsiveness $s2_communal_trust $compliance {
		
		/* call up `x' from baseline dataset */
		append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
		/* summarize `x' at basline to capture mean and sd */
		qui sum `x' if baseline==1
		/* standardize `x' at endline by baseline mean and sd */
		gen s_`x'=(`x'-`r(mean)')/`r(sd)'
		/* organize in existing dataset */
		placevar s_`x', after(`x')
		
		/* drop baseline obs, drop baseline identifier */
		drop if baseline==1
		drop baseline
	}
	

/*******************************
// CONSTRUCT OUTCOMES
*******************************/


// H1A INCIDENCE OF CRIME 
	
	gen H1A_INCIDENCE_OF_CRIME=.
		la var H1A_INCIDENCE_OF_CRIME "====================================="
		placevar H1A_INCIDENCE_OF_CRIME, f
	
	/* In SurveyCTO, crime module delivered via a repeat group (See SurveyCTO >> Help >> Designing-forms >> additional-topics )*/
	/* Each iteration is denoted with a subscript (1, 2, ..., n), rather than name of the type of crime */
	/* Here we relabel raw variables from this module to correspond to actual crimes */
	
	gl self_victimization armedrob burglary aggassault simpleassault sexual domestic_phys domestic_verbal land_viol land_nviol other

	local n = 1
	foreach x in $self_victimization {
		
		/* drop variables not relevant to MK4_LIB evaluation */		
		drop crime_id_`n' crime_name_`n'  crime_des_`n' crime_name_occur_`n' crime_perp_known_`n' crime_pol_avail_`n' crime_pol_fair_`n' crime_pol_respect_`n' crime_pol_serious_`n' crime_pol_satisfied_`n' crime_pol_invest_`n' crime_pol_interview_`n' crime_pol_paysmall_`n' crime_polstatus_`n' crime_polreport_again_`n' crime_polcommvex_`n' crime_polcommretri_`n' crime_polcommgiveinfo_`n' crime_polcommtestify_`n' crime_polcommcoop_`n' crime_court_avail_`n' crime_court_fair_`n' crime_court_respect_`n' crime_court_serious_`n' crime_court_paysmall_`n' crime_courtreport_again_`n' crime_ldr_avail_`n' crime_ldr_fair_`n' crime_ldr_respect_`n' crime_ldr_serious_`n' crime_ldr_paysmall_`n' crime_ldrreport_again_`n' crime_justice_`n' crime_resolved_`n' crime_res_satis_`n'
		
		/* rename variables */ 
		ren crime_any_`n' `x'_any
		ren crime_num_`n' `x'_num
		ren crimewhat_`n' `x'_what
		ren crime_other_des_`n' `x'_other_des
		ren crime_report_`n' `x'_report
		ren crime_report_0_`n' `x'_report_0
		ren crime_report_1_`n' `x'_report_1
		ren crime_report_2_`n' `x'_report_2
		ren crime_report_3_`n' `x'_report_3
		ren crime_report_4_`n' `x'_report_4
		ren crime_report_5_`n' `x'_report_5
		ren crime_report_6_`n' `x'_report_6
		ren crime_report_88_`n' `x'_report_88
		ren crime_report_97_`n' `x'_report_97
		ren crime_report_98_`n' `x'_report_98
		
		local n = `n'+1
	}


	/* [crime]_other_des not asked for non-other crimes */
	drop armedrob_other_des burglary_other_des aggassault_other_des simpleassault_other_des sexual_other_des domestic_phys_other_des domestic_verbal_other_des land_viol_other_des land_nviol_other_des

	
	/* we do the same as above, but for others victimization crime vars */
	
	gl others_victimization carmedrob cburglary caggassault csimpleassault csexual cdomestic_phys cdomestic_verbal cland_viol cland_nviol cmurder cchildabuse cother

	local n = 1
	foreach x in $others_victimization {
		
		/* drop variables not relevant to MK4_LIB evaluation */
		
		drop ccrime_id_`n' ccrime_name_`n' ccrime_des_`n' ccrime_pol_avail_`n' ccrime_pol_fair_`n' ccrime_pol_respect_`n' ccrime_pol_serious_`n'  ccrime_pol_paysmall_`n' ccrime_polstatus_`n'  ccrime_polcommvex_`n' ccrime_court_avail_`n' ccrime_court_fair_`n' ccrime_court_respect_`n' ccrime_court_serious_`n' ccrime_court_paysmall_`n' ccrime_ldr_avail_`n' ccrime_ldr_fair_`n' ccrime_ldr_respect_`n' ccrime_ldr_serious_`n' ccrime_ldr_paysmall_`n' ccrime_justice_`n' ccrime_resolved_`n' ccrime_rel_`n' ccrime_register_`n' ccrime_polcommtestify_`n' ccrime_polcommcoop_`n'
		
		/* rename variables */ 
		ren ccrime_any_`n' `x'_any
		ren ccrime_num_`n' `x'_num
		ren ccrime_what_`n' `x'_what
		ren ccrime_report_`n' `x'_report
		ren ccrime_report_0_`n' `x'_report_0
		ren ccrime_report_1_`n' `x'_report_1
		ren ccrime_report_2_`n' `x'_report_2
		ren ccrime_report_3_`n' `x'_report_3
		ren ccrime_report_4_`n' `x'_report_4
		ren ccrime_report_5_`n' `x'_report_5
		ren ccrime_report_6_`n' `x'_report_6
		ren ccrime_report_88_`n' `x'_report_88
		ren ccrime_report_97_`n' `x'_report_97
		ren ccrime_report_98_`n' `x'_report_98
		
		local n = `n'+1
	}

	
	
	/* coding other crimes as violent or non violent here */
		*bro respid other_any other_other_des other_num other_what other_report if other_any==1
		*bro respid cother_any cother_num cother_what cother_report if cother_any==1	
		
	gen other_any_violent=0
		replace other_any_violent=1 if respid==5000253 | respid==9020145 | respid==4014281 | respid==4027161 | respid==6004232 | respid==1008281 | respid==1002313 | respid==1004215 | respid==1007233 | respid==2027273 | respid==3014302
	gen other_any_nonviolent=other_any
		replace other_any_nonviolent=0 if other_any_violent==1
	
	gen cother_any_violent=0
		replace cother_any_violent=1 if respid==5013302 | respid==9028282 | respid==5010151 | respid==4024294 | respid==9999202 | respid==1002285 | respid==1004164 | respid==6666291 | respid==2005315 | respid==2037303 | respid==3024162 | respid==3019236 
	gen cother_any_nonviolent=cother_any
		replace cother_any_nonviolent=0 if cother_any_violent==1
	
	
	/* note the presence of outliers in crime vars */
	/* per mpap, no action taken */
	
	foreach x in armedrob burglary aggassault simpleassault sexual domestic_phys domestic_verbal land_viol land_nviol {
			
		 sum `x'_num,d
		 sum c`x'_num,d

	}	

	
	/* In raw form, [crime]_num is . if [crime]_any = "No"; here, replace [crime]_num with 0 where [crime]_any = "No" */
	
	foreach x in armedrob  burglary  aggassault  simpleassault  sexual  domestic_phys  domestic_verbal  land_viol  land_nviol    carmedrob  cburglary  caggassault  csimpleassault  csexual  cdomestic_phys  cdomestic_verbal  cland_viol  cland_nviol    cmurder  cchildabuse {
	
		replace `x'_num=0 if `x'_any==0
	}

	replace cmurder_num=0 if cmurder_any==0
	replace cchildabuse_num=0 if cchildabuse_any==0
	replace cmob_num=0 if cmob_any==0
	
	gen land_any = cond(land_nviol_any ==1 | land_viol_any ==1,1,0)
	gen land_num = land_nviol_num + land_viol_num
	
	gen cland_any = cond(cland_nviol_any ==1 | cland_viol_any ==1,1,0)
	gen cland_num = cland_nviol_num + cland_viol_num
	
	
	/* create binary versions of [crime]_num, equal to 1 if greater than 0 instances */
	
	foreach x in armedrob simpleassault aggassault sexual domestic_phys burglary domestic_verbal ///
	land_nviol land_viol other carmedrob csimpleassault caggassault csexual cdomestic_phys ///
	cburglary cdomestic_verbal cland_nviol cland_viol cother cmob cmurder cchildabuse {
	
	gen `x'_bin=`x'_any
	
	}	
	

	/* Construct crime variables for meta-analysis */

	gen violentcrime_num = armedrob_num  + simpleassault_num + other_any_violent  
	gen violentcrime_num_exp = armedrob_num + aggassault_num +sexual_num + domestic_phys_num  + simpleassault_num + other_any_violent  
	gen violentcrime_bin = armedrob_bin + simpleassault_bin + other_any_violent
	
	gen nonviolentcrime_num = burglary_num + other_any_nonviolent  
	gen nonviolentcrime_num_exp = burglary_num + domestic_verbal_num + land_any + other_any_nonviolent  
	gen nonviolentcrime_bin = burglary_bin + other_any_nonviolent
	
	
	gen cviolentcrime_num = carmedrob_num + caggassault_num + csimpleassault_num + csexual_num + cdomestic_phys_num + cmurder_num  + cother_any_violent
	gen cviolentcrime_bin = carmedrob_bin + caggassault_bin + csimpleassault_bin + csexual_bin + cdomestic_phys_bin + cmurder_bin  + cother_any_violent
	gen cviolentcrime_num_exp = carmedrob_num + caggassault_num + csimpleassault_num + csexual_num + cdomestic_phys_num + cmurder_num  + cother_any_violent + cmob_num
	
	gen cnonviolentcrime_num = cburglary_num + cother_any_nonviolent
	gen cnonviolentcrime_bin = cburglary_bin + cother_any_nonviolent
	gen cnonviolentcrime_num_exp = cburglary_num + cland_any + cdomestic_verbal_num + cother_any_nonviolent	

	/* first need to standardize input vars by baseline mean */
	foreach x of varlist violentcrime_num nonviolentcrime_num cviolentcrime_num cnonviolentcrime_num violentcrime_num_exp nonviolentcrime_num_exp  cviolentcrime_num_exp cnonviolentcrime_num_exp violentcrime_bin nonviolentcrime_bin cviolentcrime_bin cnonviolentcrime_bin {			
		/* call up `x' from baseline dataset */
		append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
		/* summarize `x' at basline to capture mean and sd */
		qui sum `x' if baseline==1
		/* standardize `x' at endline by baseline mean and sd */
		gen s_`x'=(`x'-`r(mean)')/`r(sd)'
		/* organize in existing dataset */
		placevar s_`x', after(`x')
			
		/* drop baseline obs, drop baseline identifier */
		drop if baseline==1
		drop baseline
		}
	
	
	gen crime_victim_idx = (s_violentcrime_num + s_nonviolentcrime_num + s_cviolentcrime_num+ s_cnonviolentcrime_num) /4
	gen crime_victim_idx_exp = (s_violentcrime_num_exp + s_nonviolentcrime_num_exp + s_cviolentcrime_num_exp+ s_cnonviolentcrime_num_exp) / 4
	gen crime_victim_idx_bin = (s_violentcrime_bin + s_nonviolentcrime_bin + s_violentcrime_bin+ s_cnonviolentcrime_bin) /4

	
	/* Construct crime variables unique to Liberia */

		/* total number of crimes by category, combining self and others victimization */
		
		foreach x in armedrob burglary aggassault simpleassault sexual domestic_phys domestic_verbal land_viol land_nviol  {
			
			gen `x'_num_sc=`x'_num + c`x'_num
		}
		
	
	gen other_any_sc = other_any + cother_any
	gen other_any_violent_sc = other_any_violent + cother_any_violent
		
	gen crime_num_lbr = armedrob_num + burglary_num + aggassault_num + simpleassault_num + sexual_num + domestic_phys_num + domestic_verbal_num + land_viol_num + land_nviol_num + other_any + carmedrob_num + cburglary_num + caggassault_num + csimpleassault_num + csexual_num + cdomestic_phys_num + cdomestic_verbal_num + cland_viol_num + cland_nviol_num + cother_any + cmurder_num + cchildabuse_num 
	gen crime_num_felony = armedrob_num_sc + aggassault_num_sc + sexual_num_sc + domestic_phys_num_sc + other_any_violent_sc + land_viol_num_sc + cmurder_num
	gen crime_num_msdmnr = burglary_num_sc + simpleassault_num_sc + domestic_verbal_num_sc + land_nviol_num_sc + cchildabuse_num
	
	/* note the presence of outliers */
	sum crime_num_lbr crime_num_felony crime_num_msdmnr,d
	
	/* cap number of crimes at 50, the highest plausible number of victimizations */
	
	replace crime_num_lbr = 50 if crime_num_lbr>50 & crime_num_lbr!=.
	
	/* standardize crime_num_lbr by baseline mean */
	foreach x of varlist crime_num_lbr {			
		/* call up `x' from baseline dataset */
		append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
		/* summarize `x' at basline to capture mean and sd */
		qui sum `x' if baseline==1
		/* standardize `x' at endline by baseline mean and sd */
		gen s_`x'=(`x'-`r(mean)')/`r(sd)'
		/* organize in existing dataset */
		placevar s_`x', after(`x')
			
		/* drop baseline obs, drop baseline identifier */
		drop if baseline==1
		drop baseline
		}
			
	gen crime_vict=cond(armedrob_any==1 | burglary_any==1 | aggassault_any==1 | simpleassault_any==1 | sexual_any==1, 1,0) 

	/* label vars for tables */
	la var crime_num_lbr "Total \# crimes reported"
	la var armedrob_num_sc "\# of armed robberies"
	la var aggassault_num_sc "\# of aggravated assaults"
	la var sexual_num_sc "\# of sexual violence"
	la var domestic_phys_num_sc "\# of domestic violence"
	la var land_viol_num_sc "\# of violence land disputes"
	la var cmurder_num "\# of murders"
	la var other_any_sc "Any other crime"
	la var other_any_violent_sc "Any other violent crime"
	la var burglary_num_sc "\# of burglaries"
	la var simpleassault_num_sc "\# of simple assaults"
	la var domestic_verbal_num_sc "\# of domestic verbal abuse"
	la var land_nviol_num_sc "\# of non violent land disputes"
	la var cchildabuse_num "\# of child abuse"
	
	placevar crime_victim_idx - crime_num_felony s_crime_num_lbr, after(H1A_INCIDENCE_OF_CRIME)
	
	
	// ADMINISTRATIVE CRIME DATA
	
		/* 
		aarmedrob_num Number of reports of armed robbery in community in past 6 months 
		aburglary_num Number of reports of burglary or theft in community in past 6 months 
		aaggassault_num Number of reports of aggravated assault in community in past 6 months 
		asimpleassault_num Number of reports of simple assault in community in past 6 months
		asexual_num Number of reports of sexual abuse in community in past 6 months
		adomestic_phys_num Number of reports of domestic violence (physical) in community in past 6 months
		adomestic_verbal_num Number of reports of domestic violence (verbal) in community in past 6 months
		aland_num Number of reports of land disputes in community in past 6 months 
		aland_violent_num Number of reports of violent land disputes in community in past 6 months
		amob_num Number of reports of mob justice in community in past 6 months
		ariot_num Number of reports of riots in community in past 6 months
		amurder_num Number of reports of murder in community in past 6 months
		aother_num Number of reports of other crimes in community in past 6 months
		acrime_num Sum of aarmedrob_num, aburglary_num, aaggassault_num, asimpleassault_num, asexual_num, adomestic_phys_num, adomestic_verbal_num, aland_num, aland_violent_num, amob_num, ariot_num, amurder_num, aother_any
		aviolentcrime_num Sum of aarmedrob_num, aaggassault_num, asimpleassault_num, asexual_num, adomestic_phys_num, aland_violent_num, amob_num, ariot_num, amurder_num
		*/
	
	
	
	
//  PERCEPTIONS OF SAFETY (PERSONAL, LAND, AND POSSESSIONS)
	
	gen H1B_SECURITY=.
	la var H1B_SECURITY "====================================="
	placevar H1B_SECURITY, f
		
	/* create variables for descriptive tables */
		
	gen fear_violent_yes=cond(fear_violent==1 | fear_violent==2 | fear_violent==3,1,0)
	gen fear_nonviolent_yes=cond(fear_nonviolent==1 | fear_nonviolent==2 | fear_nonviolent==3,1,0)
	gen feared_walk_yes=cond(feared_walk==1 | feared_walk==2 | feared_walk==3 | feared_walk==4,1,0)
	gen feared_home_yes=cond(feared_home==1 | feared_home==2 | feared_home==3 | feared_home==4,1,0)
	gen motosecure_yes=cond(motosecure==2 | motosecure==3,1,0)
	gen generatorsecure_yes=cond(generatorsecure==2 | generatorsecure==3,1,0)
	gen hssecure_yes=cond(hssecure==2 | hssecure==3,1,0)
	gen hsitemssecure_yes=cond(hsitemssecure==2 | hsitemssecure==3,1,0)
		
	
	/* for some Liberia specific indices, endline vars not measured at baselie */
	/* for these, we standardize by endline mean and sd */
	
	foreach x of varlist hsitemssecure motosecure generatorsecure {
		
	egen s_`x'=std(`x')
	/* and we reverse code so positive values equate to less security */
	gen s_`x'_rev=s_`x'*(-1)
	
	}		
	
	gen future_insecurity_idx = (s_fear_violent + s_fear_nonviolent + s_feared_walk)/3
	gen future_insecurity_idx_lbr=(s_fear_violent + s_fear_nonviolent + s_feared_walk + s_feared_home + s_hsitemssecure_rev + s_motosecure_rev + s_generatorsecure_rev)/7

	/* reverse code so positive values equate to greater security*/
	
	gen future_security_idx=future_insecurity_idx*-1
	gen future_security_idx_lbr=future_insecurity_idx_lbr*-1	
	
	/* labels for tables */
	la var future_insecurity_idx "Insecurity idx (std)"
	la var future_insecurity_idx_lbr "Insecurity idx (std)" 
	la var fear_violent_yes "Fears violent crime"
	la var fear_nonviolent_yes "Fears non-violent crime" 
	la var feared_walk_yes "Fears walking at night"
	la var feared_home_yes "Fears home invasions"
	la var motosecure_yes "Motorbike secure outside"
	la var generatorsecure_yes "Generator secure outside"
	la var hssecure_yes "House boundaries secure"
	la var hsitemssecure_yes "House items secure"
	
	
	placevar future_insecurity_idx future_insecurity_idx_lbr fear_violent_yes fear_nonviolent_yes feared_walk_yes feared_home_yes motosecure_yes generatorsecure_yes hssecure_yes hsitemssecure_yes, after(H1B_SECURITY)
	

// H2 PERCEPTIONS OF POLICE

	gen H2_PERCEPTIONS_POLICE=.
	la var H2_PERCEPTIONS_POLICE "====================================="
	placevar H2_PERCEPTIONS_POLICE, f
	
	gen satis_idx = (s_satis_trust + s_satis_general)/2

	
	/* agree disagree coding  for descriptive tables */
	
	foreach x of varlist satis_trust satis_general {
	
		gen `x'_agree=cond(`x'==3 | `x'==4,1,0)
	}

	
	/* labels for tables */
	
	la var satis_idx "Satisfaction w/ police performance idx"
	la var satis_trust_agree "Trusts police"
	la var satis_general_agree "Satisfied w/ police performance"
	
	placevar satis_idx satis_trust_agree satis_general_agree, after(H2_PERCEPTIONS_POLICE)

		
// 3A PERCEPTIONS OF POLICE EMPATHY, ACCOUNTABILITY, AND ABUSE AND CORRUPTION CONCERNS

	/* excluded from liberia study */


// 3B REPORTING OF POLICE ABUSE AND BRIBERY
	
	/* excluded from hypotheses & analysis for liberia, but vars still constructed here */

	gen H3B_POLICE_ABUSE=.
	la var H3B_POLICE_ABUSE "====================================="
	placevar H3B_POLICE_ABUSE, f
	
	gen policeabuse_any=cond(policeabuse_verbal_any ==1 | policeabuse_phys_any==1,1,0)
	
	/* per survey skip order, [x]_num is NA if [x]_any is 0 */
	replace policeabuse_verbal_num=0 if policeabuse_verbal_any==0
	replace policeabuse_phys_num=0 if policeabuse_phys_any==0
	
	gen policeabuse_num=policeabuse_verbal_num + policeabuse_phys_num
	
	/* abuse reported to police if reported to police station or commander (2) or LNP's professional standards division (6) */ 
	gen policeabuse_report=cond(policeabuse_phys_report_2==1 | policeabuse_phys_report_6==1 | policeabuse_verbal_report_2==1 | policeabuse_verbal_report_6==1,1,0)
	
	replace bribe_amt=bribe_amt/100 if bribe_amt_unit==1
	/* per survey skip order, [x]_amt is NA if [x]_freq is "1-None" */
		replace bribe_amt=0 if bribe_freq==1 
		
		drop bribe_amt_unit
		la var bribe_amt "bribe amt (USD)"
		
	
	/* construct police abuse index */
	
		/* first need to standardize input vars by baseline mean */
		foreach x of varlist policeabuse_any policeabuse_num policeabuse_report bribe_freq bribe_amt {
			
			/* call up `x' from baseline dataset */
			append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
			/* summarize `x' at basline to capture mean and sd */
			qui sum `x' if baseline==1
			/* standardize `x' at endline by baseline mean and sd */
			gen s_`x'=(`x'-`r(mean)')/`r(sd)'
			/* organize in existing dataset */
			placevar s_`x', after(`x')
			
			/* drop baseline obs, drop baseline identifier */
			drop if baseline==1
			drop baseline
		}
		
	gen police_abuse_idx=(s_policeabuse_any + s_policeabuse_num + s_policeabuse_report + s_bribe_freq + s_bribe_amt)/5 

	/* labels for tables */
	la var police_abuse_idx "Police abuse idx"
	la var policeabuse_any "Seen police abuse past 6m"
	la var policeabuse_num "Num police abuse past 6m"
	la var policeabuse_report "Reported abuse to police" 
	la var bribe_freq "Num bribes past 6m"
	la var bribe_amt "Bribe amt past 6m"
	
	placevar police_abuse_idx policeabuse_any policeabuse_num policeabuse_report bribe_freq bribe_amt , after(H2_PERCEPTIONS_POLICE)
	

// 4A. POSITIVE EFFECT ON REPORTING OF CRIME VICTIMIZATION

		gen H4A_CRIME_REPORTING=.
		la var H4A_CRIME_REPORTING "========================="
		placevar H4A_CRIME_REPORTING, f
	
		/* Not relevant in Liberia (no hotline) 
		acrime_hline ADMIN: Total number of reports of crimes to hotline
		aviolent_hline ADMIN: Number of reports of violent crimes to hotline
		anonviolent_hline ADMIN: Number of reports of non-violent crimes to hotline
		*/

		/* For these vars, see admin cleaning file
		acrime_station ADMIN: Total number of reports of crimes to nearest police station
		aviolent_station ADMIN: Number of reports of violent crimes to nearest police station
		anonviolent_station ADMIN: Number of reports of non-violent crimes to nearest police station 
		aburglary_hline ADMIN: Number of reports of burglary to hotline
		aarmedrob_hline ADMIN: Number of reports of armed robbery to hotline
		arape_hline ADMIN: Number of reports of rape to hotline
		amurder_hline ADMIN: Number of reports of murder to hotline
		asimpleassault_hline ADMIN: Number of reports of simple assault to hotline
		aaggassault_hline ADMIN: Number of reports of aggravated assault to hotline
		atheft_hline ADMIN: Number of reports of theft to hotline
		aburglary_station ADMIN: Number of reports of burglary to nearest police station
		aarmedrob_station ADMIN: Number of reports of armed robbery to nearest police station
		arape_station ADMIN: Number of reports of rape to nearest police station
		amurder_station ADMIN: Number of reports of murder to nearest police station
		asimpleassault_station ADMIN: Number of reports of simple assault to nearest police station
		aaggassault_station ADMIN: Number of reports of aggravated assault to nearest police station
		atheft_station ADMIN: Number of reports of theft to nearest police station */

		/* Crime reporting - self victimization crime vars */
		
			* [crime]_report were select all that apply, separated by a space
			* below, we parse these responses before recoding following guidelines in MPAP
			* to preserve raw survey var, we create a duplicate with suffix "raw"
		
		foreach x of varlist armedrob_report burglary_report simpleassault_report other_report  {
			
			* preserve raw survey var
			ren `x' `x'_raw
			
			/* recode [x]_report as: 1 if reported, 0 if either i) no crime or ii) crime not reported */
			/* `x'_1 is a dummy for whether "1-Police" selected */
			gen `x' = cond(`x'_1==1,1,0)
			placevar `x', before(`x'_raw)
		}
		gen other_report_violent=cond(other_report==1 & other_any_violent==1,1,0)
		
		gen crime_report_num = armedrob_report + burglary_report + simpleassault_report + other_report
		gen violentcrime_report_num = armedrob_report + burglary_report + simpleassault_report + other_report_violent

		
		/* Crime reporting - others victimization crime vars */
		
			* [crime]_report were select all that apply, separated by a space
			* below, we parse these responses before recoding following guidelines in MPAP
			* to preserve raw survey var, we create a duplicate with suffix "raw"
		
		foreach x of varlist carmedrob_report cburglary_report caggassault_report csimpleassault_report csexual_report cdomestic_phys_report cmurder_report cother_report {
			
			* preserve raw survey var
			ren `x' `x'_raw
			
			/* recode [x]_report as: 1 if reported, 0 if either i) no crime or ii) crime not reported */
			/* `x'_1 is a dummy for whether "1-Police" selected */
			gen `x' = cond(`x'_1==1,1,0)
			placevar `x', before(`x'_raw)
		}
		
		gen cother_report_violent=cond(cother_report==1 & cother_any_violent==1,1,0)		
		gen ccrime_report_num = carmedrob_report + cburglary_report + caggassault_report + csimpleassault_report + csexual_report + cdomestic_phys_report + cmurder_report + cother_report
		gen cviolentcrime_report_num = carmedrob_report + cburglary_report + caggassault_report + csimpleassault_report + csexual_report + cdomestic_phys_report + cmurder_report + cother_report_violent
			
		/* hypothetical crime reporting index */
		
		
		foreach x of varlist landres landresviol burglaryres dviolres armedrobres {
			
			gen `x'_pol=cond(`x'==1,1,0)
			gen `x'_formal=cond(`x'==1 | `x'==2,1,0)
		
		}
		
		
		/* standarize index input vars by baseline mean */
		
		foreach x of varlist burglaryres_pol dviolres_pol armedrobres_pol  {
			
			/* call up `x' from baseline dataset */
			append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
			/* summarize `x' at basline to capture mean and sd */
			qui sum `x' if baseline==1
			/* standardize `x' at endline by baseline mean and sd */
			gen s_`x'=(`x'-`r(mean)')/`r(sd)'
			/* organize in existing dataset */
			placevar s_`x', after(`x')
			
			/* drop baseline obs, drop baseline identifier */
			drop if baseline==1
			drop baseline
		}
			
		/* for vars not measured at baseline, standardize by endline mean and sd */
		egen s_landres_pol=std(landres_pol)
		egen s_landresviol_pol=std(landresviol_pol)
		
		gen crimeres_idx = (s_burglaryres_pol + s_dviolres_pol + s_armedrobres_pol)/3
		gen crimeres_idx_lbr = (s_landres_pol + s_landresviol_pol + s_burglaryres_pol + s_dviolres_pol + s_armedrobres_pol)/5
		
		
		/* aggregate crime reporting index */
		
		foreach x of varlist crime_report_num violentcrime_report_num ccrime_report_num cviolentcrime_report_num crimeres_idx {
			
			/* call up `x' from baseline dataset */
			append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
			/* summarize `x' at basline to capture mean and sd */
			qui sum `x' if baseline==1
			/* standardize `x' at endline by baseline mean and sd */
			gen s_`x'=(`x'-`r(mean)')/`r(sd)'
			/* organize in existing dataset */
			placevar s_`x', after(`x')
			
			/* drop baseline obs, drop baseline identifier */
			drop if baseline==1
			drop baseline
		}		
		
		
		gen crime_reporting_idx = (s_crime_report_num + s_violentcrime_report_num + s_ccrime_report_num + s_cviolentcrime_report_num + s_crimeres_idx)/5
		
	
		/*lables for tables */
		
		la var crimeres_idx_lbr "Crime resolution idx (std)"
		la var landres_pol "Land disputes"
		la var landresviol_pol "Violent land disputes"
		la var burglaryres_pol "Burglaries"
		la var dviolres_pol "Domestic violence"
		la var armedrobres_pol "Armed robbery"
		
		placevar landres_pol - armedrobres_formal crimeres_idx crimeres_idx_lbr, after(H4A_CRIME_REPORTING)
		
		
		
// 4B COOPERATION IN CRIME PREVENTION
	
	gen H4B_COOPERATION_CRIME_PREVENTION=.
		la var H4B_COOPERATION_CRIME_PREVENTION "========================="
		placevar H4B_COOPERATION_CRIME_PREVENTION, f
		
	/* NA in Liberia: atips_hline atips_box */
		
	gen crime_tips_idx=(s_contact_pol_susp_activity + s_give_info_pol_investigation)/2 
	gen tips_idx=(s_contact_pol_susp_activity + s_give_info_pol_investigation)/2 /* excluded: atips_hline atips_box */
	gen crime_tips_idx_lbr=(s_contact_pol_susp_activity + s_contact_pol_find_suspect + s_give_info_pol_investigation + s_testify_police_investigation)/4
	gen crime_tips_idx_lbr2=(s_name_witness + s_identify_hideout +s_identify_ghetto +s_guide_police + s_give_testimony)/5
	

	/* labels for tables */
	
	la var crime_tips_idx_lbr "Crime tips \& info sharing idx (std)"
	la var contact_pol_susp_activity  "Reported suspicious activity past 6m"
	la var contact_pol_find_suspect "Helped police find suspect past 6m"
	la var give_info_pol_investigation "Given info for investigation past 6m" 
	la var testify_police_investigation "Provided testimony past 6m"

	placevar crime_tips_idx crime_tips_idx_lbr crime_tips_idx_lbr2, after(H4B_COOPERATION_CRIME_PREVENTION)
	
	
// 4C. WILLINGNESS TO REPORT POLICE ABUSE	
	
	gen H4C_REPORT_POLICE_ABUSE=.
		la var H4C_REPORT_POLICE_ABUSE "========================="
		placevar H4C_REPORT_POLICE_ABUSE, f		
		
	/* NA in Liberia: apolvtm_hline apolvtm_cmtbox apolvtm_station */

	gen police_abuse_report_idx = (s_policeabuse_report + s_dutydrink_report + s_policebeating_report)/3
	gen police_abuse_report_idx_lbr = (s_policeabuse_report + s_checkpoint_report + s_dutydrink_report + s_policebeating_report)/4
	
	/* unlikely/likely coding for descriptives */
	foreach x of varlist checkpoint_report dutydrink_report policebeating_report {
	
		gen `x'_likely=cond(`x'==3 | `x'==4,1,0) if `x'!=.
	}
	
	/* labels for tables */
	
	la var police_abuse_report_idx_lbr "Willingness to report police misconduct"
	la var checkpoint_report_likely "Would report illegal checkpoint"
	la var dutydrink_report_likely "Would report drunk officer"
	la var policebeating_report_likely "Would report police beating"
	
	placevar police_abuse_report_idx police_abuse_report_idx_lbr checkpoint_report_likely dutydrink_report_likely policebeating_report_likely, after(H4C_REPORT_POLICE_ABUSE)
	
	
// M1A BELIEFS ABOUT POLICE INTENTIONS	

	gen M1A_POLICE_INTENTIONS=.
		la var M1A_POLICE_INTENTIONS "========================="
		placevar M1A_POLICE_INTENTIONS, f

	/* reverse code polint_corrupt so higher values are 'good' */
	gen s_polint_corrupt_rev=s_polint_corrupt*-1
	
	gen polint_idx = (s_polint_corrupt_rev + s_polint_quality)/2
	gen intentions_idx = (s_polint_corrupt_rev + s_polint_quality + s_polcaseserious + s_polcasefair)/4
	gen intentions_idx_lbr = (s_polint_corrupt_rev + s_polint_quality + s_polcaseserious + s_polcasefair +s_pol_care + s_polint_digresp + s_polint_decfact + s_polcaserespect)/8
	
		
	/* agree disagree coding for descriptives */
	foreach x of varlist polint_corrupt polint_quality polcaseserious polcasefair pol_care polint_digresp polint_decfact polcaserespect {
	
		gen `x'_agree=cond(`x'==3 | `x'==4,1,0) if `x'!=.
	}

	
	/* labels for tables */
	
	la var intentions_idx_lbr "Trust police intentions idx (std)"
	la var polint_corrupt_agree "Police corrupt" 
	la var polint_quality_agree "Police treat all equal" 
	la var polcaseserious_agree "Police take cases seriously"
	la var polcasefair_agree "Police fair to all sides" 
	la var pol_care_agree "Police care about citizens' safety"
	la var polint_digresp_agree "Police respect citizens" 
	la var polint_decfact_agree "Police objective" 
	la var polcaserespect_agree "Police respect victims"
	
	placevar polint_idx intentions_idx intentions_idx_lbr polint_corrupt_agree-polcaserespect_agree, after(M1A_POLICE_INTENTIONS)
	

	
// M1B KNOWLEDGE OF CRIMINAL JUSTICE SYSTEM	
	
	gen M1B_KNOWLEDGE=.
		la var M1B_KNOWLEDGE "========================="
		placevar M1B_KNOWLEDGE, f

	/* know_report_station labeled know_polstation in liberia, so we duplicate*/
	gen know_report_station=know_polstation
	
	/* KNOWLEDGE QUESTIONS - CORRECT ANSWER IS TRUE */
	foreach x of varlist know_law_statrape know_law_habeasc know_law_lawyer know_law_complain know_cwt_arrest know_cwt_violent know_wacps know_psd know_csd_name know_psd_name know_wacps_name {
	
	gen `x'_correct=cond(`x'==1,1,0)
	
	}
	
	/* KNOWLEDGE QUESTIONS - CORRECT ANSWER IS  FALSE */
	
	foreach x of varlist know_law_childsup know_law_suspect know_cwt_cutlass know_cwt_beat know_law_fees know_law_bondfee know_cwt_risk know_cwt_checkpoint know_cwt_jurisdiction {
	
	gen `x'_correct=cond(`x'==0,1,0)
	
	}
	
	
	/* standarize index vars by baseline mean */
		
	foreach x of varlist know_law_statrape_correct know_law_habeasc_correct know_law_lawyer_correct know_law_complain_correct know_law_childsup_correct know_law_suspect_correct know_law_fees_correct know_law_bondfee_correct know_wacps_correct know_psd_correct know_csd_name_correct know_psd_name_correct know_wacps_name_correct know_localcommander know_anyofficer know_policenumber know_cwt_cutlass_correct know_cwt_beat_correct know_report_station know_cwt_violent_correct {
		
		/* call up `x' from baseline dataset */
		append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
		/* summarize `x' at basline to capture mean and sd */
		qui sum `x' if baseline==1
		/* standardize `x' at endline by baseline mean and sd */
		gen s_`x'=(`x'-`r(mean)')/`r(sd)'
		/* organize in existing dataset */
		placevar s_`x', after(`x')
			
		/* drop baseline obs, drop baseline identifier */
		drop if baseline==1
		drop baseline
	}
	
	
	/* for vars not measured at baseline, standardize by endline mean and sd */
	
	foreach x of varlist know_cwt_risk_correct know_cwt_checkpoint_correct know_cwt_jurisdiction_correct know_cwt_arrest_correct {
		
		egen s_`x'=std(`x')
	
	}
	
	/* know_report_followup, a question about following up on police hotlines, is NA in Liberia, so is excluded */
	/* know_law_vaw not measured in Liberia by oversight */
	
	gen know_law_idx = (s_know_law_suspect_correct + s_know_law_lawyer_correct + s_know_law_fees_correct)/3 
	gen know_report_idx = s_know_report_station /* know_report_followup NA in Liberia, excluded here */
	gen know_idx = (s_know_law_suspect_correct + s_know_law_lawyer_correct + s_know_law_fees_correct +s_know_report_station)/4
	gen know_idx_lbr = (s_know_law_statrape_correct + s_know_law_habeasc_correct +s_know_law_lawyer_correct + s_know_law_complain_correct + s_know_law_childsup_correct + s_know_law_suspect_correct + s_know_law_fees_correct +s_know_law_bondfee_correct)/8
	
	
	/* Liberia specific hypothesis H1 - familiarity with police */
	gen know_pol_idx = (s_know_wacps_correct + s_know_psd_correct + s_know_csd_name_correct + s_know_psd_name_correct + s_know_wacps_name_correct +s_know_localcommander +s_know_anyofficer +s_know_policenumber)/8
	gen know_pol_idx2 = (s_know_localcommander + s_know_anyofficer +s_know_policenumber)/3
		
	/* component index for Liberia specific hypothesis H8a - coproduction of security index */
		/* component index - knowledge of watch team rules */
		
		gen know_cwt_idx = (s_know_cwt_cutlass_correct +s_know_cwt_beat_correct +s_know_cwt_risk_correct + s_know_cwt_checkpoint_correct + s_know_cwt_jurisdiction_correct +s_know_cwt_arrest_correct +s_know_cwt_violent_correct)/7
	
	
	/* labels for tables */ 
	
	la var know_idx_lbr "Knowledge of law idx (std)"
	la var know_law_statrape_correct "Knows statutory rape illegal"
	la var know_law_habeasc_correct "Knows about habeas corpus"
	la var know_law_lawyer_correct "Knows right to lawyer"
	la var know_law_complain_correct "Knows rights when reporting"
	la var know_law_childsup_correct "Knows about child support"
	la var know_law_suspect_correct "Knows obligation to report serious crimes"
	la var know_law_fees_correct "Knows informal fees illegal"
	la var know_law_bondfee_correct "Knows bond fees illegal"

	la var know_pol_idx "Knowledge of police index (std)"
	la var know_wacps_correct "Knows about WACPS"
	la var know_psd_correct "Knows about PSD"
	la var know_csd_name_correct "Knows about CSD"
	la var know_wacps_name_correct "Knows WACPS by name"
	la var know_psd_name_correct "Knows PSD by name" 
	la var know_localcommander "Knows local commander"
	la var know_anyofficer "Knows officer by name"
	la var know_policenumber "Knows officer's number"

	la var know_cwt_cutlass_correct "Weapons prohibited"
	la var know_cwt_beat_correct "Physical harm prohibited"
	la var know_cwt_risk_correct "Must avoid risks \& danger"
	la var know_cwt_checkpoint_correct "Checkpoints prohibited"
	la var know_cwt_jurisdiction_correct "Only operate in home community"
	la var know_cwt_arrest_correct "Can perform citizens' arrest"

	placevar know_law_idx know_report_idx know_idx know_idx_lbr know_pol_idx know_cwt_idx, after(M1B_KNOWLEDGE)


// M1C  NORMS OF CITIZEN COOPERATION WITH POLICE

	gen M1C_NORMS=.
		la var M1C_NORMS "========================="
		placevar M1C_NORMS, f

		
	/* standarize index vars by baseline mean */
		
	foreach x of varlist reportnorm_theft reportnorm_abuse reportnorm_land obeynorm  {
		
		/* call up `x' from baseline dataset */
		append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
		/* summarize `x' at basline to capture mean and sd */
		qui sum `x' if baseline==1
		/* standardize `x' at endline by baseline mean and sd */
		gen s_`x'=(`x'-`r(mean)')/`r(sd)'
		/* organize in existing dataset */
		placevar s_`x', after(`x')
			
		/* drop baseline obs, drop baseline identifier */
		drop if baseline==1
		drop baseline
	}
	
	
	/* for vars not measured at baseline, standardize by endline mean and sd */
	
	foreach x of varlist helppolnorm_armedrob helppolnorm_domviol helppolnorm_moto helppolnorm_childabuse {
		
		egen s_`x'=std(`x')
	
	}
		

	/* reverse code so higher equals greater support for reporting / cooperating */
	
	foreach x of varlist s_reportnorm_theft s_reportnorm_abuse s_reportnorm_land s_helppolnorm_armedrob s_helppolnorm_domviol s_helppolnorm_moto s_helppolnorm_childabuse {
	
		gen `x'_rev=`x'*-1
	
	}
	
	
	gen norm_idx=(s_reportnorm_theft_rev +s_reportnorm_abuse_rev + s_obeynorm)/3
	gen norm_idx_lbr=(s_reportnorm_theft_rev + s_reportnorm_abuse_rev +s_reportnorm_land +s_obeynorm +s_helppolnorm_armedrob_rev + s_helppolnorm_domviol_rev +s_helppolnorm_moto_rev +s_helppolnorm_childabuse_rev)/8
	
	
	/* agree disagree coding for descriptive tables */
	foreach x of varlist reportnorm_theft reportnorm_abuse reportnorm_land obeynorm helppolnorm_armedrob helppolnorm_domviol helppolnorm_moto helppolnorm_childabuse {
		gen `x'_agree=cond(`x'==3 | `x'==4,1,0)
	}
	
	
	/*labels for tables */
	la var norm_idx_lbr "Norms against cooperation idx (std)"
	la var reportnorm_theft_agree "Ppl get mad if you report a burglary?"
	la var reportnorm_abuse_agree "Ppl get mad if you report domestic violence?"
	la var reportnorm_land_agree "Ppl get mad if you report land disputes?"
	la var obeynorm_agree "Ppl should always obey the police"
	la var helppolnorm_armedrob_agree "Ppl get mad if you give info about armed robbery?"
	la var helppolnorm_domviol_agree "Ppl get mad if you give info about domestic violence?"
	la var helppolnorm_moto_agree "Ppl get mad if you give info about stolen motorcycle?"
	la var helppolnorm_childabuse_agree	"Ppl get mad if you give info about child abuse?"
		
	placevar norm_idx norm_idx_lbr reportnorm_theft_agree - helppolnorm_childabuse_agree , after(M1C_NORMS)


	
	
// M2A  BELIEFS ABOUT POLICE CAPACITY

	gen M2A_POLICE_CAPACITY=.
		la var M2A_POLICE_CAPACITY "========================="
		placevar M2A_POLICE_CAPACITY, f
	
	gen police_capacity_idx = (s_polcap_timely + s_polcap_investigate)/2

	/* agree disagree coding just for descriptives */
	foreach x of varlist polcap_timely polcap_investigate {
	
		gen `x'_agree=cond(`x'==3 | `x'==4,1,0)
	}
	
	/*labels for tables */
	la var police_capacity_idx "Trust police capacity idx (std)"
	la var polcap_timely_agree "Police able to respond quickly"
	la var polcap_investigate_agree "Police able to investigate effectively"
	
	placevar police_capacity_idx polcap_timely_agree polcap_investigate_agree, after(M2A_POLICE_CAPACITY)
	

// M2B PERCEPTIONS OF RESPONSIVENESS TO CITIZEN FEEDBACK

	gen M2B_RESPONSIVENESS=.
		la var M2B_RESPONSIVENESS "========================="
		placevar M2B_RESPONSIVENESS, f
	
	
	gen pol_responsiveness_lbr = ( s_responsive_act +s_responsive_listen)/2
	
	
	/* agree disagree coding just for descriptives */
	foreach x of varlist responsive_act responsive_listen {
	
		gen `x'_agree=cond(`x'==3 | `x'==4,1,0)
	}
		

	/*labels for tables */
	la var pol_responsiveness_lbr "Police responsiveness idx (std)"
	la var responsive_act_agree "Police act on citizens' feedback"
	la var responsive_listen_agree "Police include citizens in decision making"
		
	placevar pol_responsiveness_lbr responsive_act responsive_act_agree responsive_listen_agree, after(M2B_RESPONSIVENESS)


// S1 TRUST IN THE STATE

	gen S1_TRUST_IN_STATE=.
		la var S1_TRUST_IN_STATE "========================="
		placevar S1_TRUST_IN_STATE, f

	
	/* standarize var by baseline mean */
		
	foreach x of varlist legit_trust {
		
		/* call up `x' from baseline dataset */
		append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
		/* summarize `x' at basline to capture mean and sd */
		qui sum `x' if baseline==1
		/* standardize `x' at endline by baseline mean and sd */
		gen s_`x'=(`x'-`r(mean)')/`r(sd)'
		/* organize in existing dataset */
		placevar s_`x', after(`x')
			
		/* drop baseline obs, drop baseline identifier */
		drop if baseline==1
		drop baseline
	}
		
	
	/*labels for tables */
	la var legit_trust "Trust in govt"
	la var s_legit_trust "Trust in govt"

	placevar s_legit_trust legit_trust, after(S1_TRUST_IN_STATE)

// S2 COMMUNAL TRUST
	
	gen S2_COMMUNAL_TRUST=.
		la var S2_COMMUNAL_TRUST "========================="
		placevar S2_COMMUNAL_TRUST, f
	
	/* liberia specific index */	
	gen comm_cohesion=(s_trust_community + s_days_comm_work + s_cgroups + s_trust_keys + s_comm_help)/5
	
	/*labels for tables */
	la var comm_cohesion "Trust in govt"
	la var days_comm_work "# days volunteer for community past month"
	la var cgroups "# groups a member of"
	la var trust_keys "Can trust neighbors with keys"
	la var comm_help "Neighbors would help when needed"
	
	placevar comm_cohesion , after(S2_COMMUNAL_TRUST)
	

// COMPLIANCE WITH TREATMENT: CITIZEN INTERACTIONS WITH POLICE
	
	gen COMPLIANCE=.
		la var COMPLIANCE "========================="
		placevar COMPLIANCE, f
		

	/* reverse code so higher equates to more presence */
	
	gen s_compliance_patrol_rev = s_compliance_patrol*-1
	gen s_compliance_freq_rev = s_compliance_freq*-1
		
	gen compliance_idx = (s_compliance_patrol_rev + s_compliance_freq_rev +s_compliance_meeting)/3
	
	
	/* standarize var by baseline mean */
		
	foreach x of varlist compliance_idx {
		
		/* call up `x' from baseline dataset */
		append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
		/* summarize `x' at basline to capture mean and sd */
		qui sum `x' if baseline==1
		/* standardize `x' at endline by baseline mean and sd */
		gen s_`x'=(`x'-`r(mean)')/`r(sd)'
		/* organize in existing dataset */
		placevar s_`x', after(`x')
			
		/* drop baseline obs, drop baseline identifier */
		drop if baseline==1
		drop baseline
	}
		
		

	/* descriptives for tables */
	

	gen compliance_patrol_dum=cond(compliance_patrol<3,1,0)
	gen compliance_freq_dum=cond(compliance_freq<3,1,0)
	
	
	/*labels for tables */
	la var compliance_idx "Compliance idx (std)"
	la var compliance_patrol_dum "Sees foot patrols daily or weekly"
	la var compliance_freq_dum "Sees vehicles patrols daily or weekly"
	la var compliance_meeting "Attended police mtg past 6m"
			
	placevar compliance_idx s_compliance_idx compliance_patrol_dum compliance_freq_dum, after(COMPLIANCE)
		


/*******************************
// LIBERIA SPECIFIC HYPOTHESES 
*******************************/

	gen LIBERIA_SPECIFIC_OUTCOMES=.
		la var LIBERIA_SPECIFIC_OUTCOMES "========================="
		placevar LIBERIA_SPECIFIC_OUTCOMES, f
			
	
	/* per survey skip order, these variables NA if cwteam=0. But should be replaced with 0 */
	
	replace cwteamnightpatrol=0 if cwteam==0
	replace cwteammtgs=0 if cwteam==0
	replace cwteamregistered=0 if cwteam==0
	replace sec_patrol_1m=1 if sec_patrol_attend_1m==1

	gen cwteamnightpatrol_dum=cond(cwteamnightpatrol==1 | cwteamnightpatrol==2 | cwteamnightpatrol==3,1,0)
	gen cwteammtgs_dum=cond(cwteammtgs==1 | cwteammtgs==2 | cwteammtgs==3,1,0)
	
	/* hypothesis 8a - coproduction of security */
	
	/* community coproduction indices */
	gen ca_sec_idx = (sec_mtg_1m + sec_mtg_attend_1m + sec_patrol_1m + sec_patrol_attend_1m + sec_patrol_contr_1m + cwteam + cwteamnightpatrol_dum + cwteammtgs_dum + cwteamregistered)/9
	gen ca_sec_hyp_idx = (sec_mtg_attend_hyp + sec_group_money_hyp + sec_group_food_hyp + sec_group_torch_hyp + sec_group_attend_hyp)/5
		
	/* per PAP, Appendix A.2- coproduction of security idx is constructed from three sub indices */
	/* note there was a descrepancy in PAP. A.2 says coproduction of security idx is constructed 
	the following three sub indices, whereas Table 1 has it tested using only ca_sec_idx. Going with 
	the more detailed instructions in the appendix, true to my original intent */
	
	egen s_ca_sec_idx=std(ca_sec_idx)
	egen s_ca_sec_hyp_idx=std(ca_sec_hyp_idx)
	egen s_know_cwt_idx=std(know_cwt_idx)
	
	
	gen local_security_idx = (s_ca_sec_idx + s_ca_sec_hyp_idx + s_know_cwt_idx)/3
	
	
	
	/* SUPPORT FOR MOB VIOLENCE INDEX */
	
	
	/* standarize index vars by baseline mean */
		
	foreach x of varlist mobviol1 mobviol2 mobviol3 cmob_num {
		
		/* call up `x' from baseline dataset */
		append using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta", keep(`x') gen(baseline) nolabel
		/* summarize `x' at basline to capture mean and sd */
		qui sum `x' if baseline==1
		/* standardize `x' at endline by baseline mean and sd */
		gen s_`x'=(`x'-`r(mean)')/`r(sd)'
		/* organize in existing dataset */
		placevar s_`x', after(`x')
			
		/* drop baseline obs, drop baseline identifier */
		drop if baseline==1
		drop baseline
	}
		
	gen sup_mobviol_idx = (s_mobviol1 + s_mobviol2 + s_mobviol3)/3
	
	/* recode so higher values equate to greater support for mob violence */
	/* note - raw vars at baseline were coded so higher values equate to greater support, making this unnecesary in baseline data cleaning file */
	
	replace sup_mobviol_idx=sup_mobviol_idx*-1

	
	/* alternative version of mobviol index using raw vars coded as dummies */
	gen mobviol1_dum=cond(mobviol1==0 | mobviol1==1,1,0) // 1 if "justified" or "somewhat justified"
	gen mobviol2_dum=cond(mobviol2==0 | mobviol2==1,1,0)
	gen mobviol3_dum=cond(mobviol3==0 | mobviol3==1,1,0)
	
	egen sup_mobviol_idx2=rowtotal(mobviol1_dum mobviol2_dum mobviol3_dum)

	/* now standardize */
	qui sum sup_mobviol_idx2,d
	replace sup_mobviol_idx2=(sup_mobviol_idx2-`r(mean)')/`r(sd)'
				
				
	/* community coproduction indices */
	
	egen town_organized_sec=rowtotal(ca_town_organized ca_town_ldrshelppol ca_town_worktogether ca_town_ldrsorganize)
	gen town_chair_corr_rev=town_chair_corr*-1
	egen town_ldr_prcptns=rowmean(town_chair_pplsame town_chair_corr_rev town_chair_open)
	
	/* agree disagree for tables */
		foreach x of varlist town_chair_pplsame town_chair_corr town_chair_open {
			gen `x'_agree=cond(`x'==3 | `x'==4,1,0)
		}	
	
	/*labels for tables */
	
	la var town_ldr_prcptns "Leader perceptions idx (std)"
	la var town_chair_pplsame_agree "Leaders treat all equal"
	la var town_chair_corr_agree "Leaders corrupt"
	la var town_chair_open_agree "Leaders rule transparently"
	la var sup_mobviol_idx "Support for mob violence idx (std)"
	la var mobviol1_dum "Mob violence justified for rape?"
	la var mobviol2_dum "Mob violence justified for armed robbery?"
	la var mobviol3_dum "Mob violence justified for burglary?"
	la var ca_sec_idx "Coproduction idx (std)"
	la var sec_mtg_1m "Seen security mtg past month"
	la var sec_mtg_attend_1m "Attended security mtg past month"
	la var sec_patrol_1m "Seen patrol past month"
	la var sec_patrol_attend_1m "Attended patrol past month"
	la var sec_patrol_contr_1m "Gave food/tea past month"
	la var cwteam "Town has Watch Forum?"
	la var cwteamnightpatrol_dum "Forum patrols at night"
	la var cwteammtgs_dum "Forum meets regularly"
	la var cwteamregistered "Forum registered with police"
	
	placevar local_security_idx ca_sec_idx ca_sec_hyp_idx sup_mobviol_idx town_ldr_prcptns town_chair_pplsame_agree town_chair_corr_agree town_chair_open_agree, after(LIBERIA_SPECIFIC_OUTCOMES)
	
	
		
/*******************************
// CONSTRUCT COVARIATES
*******************************/

	
	gen COVARIATES=.
		la var COVARIATES "========================="
	placevar COVARIATES, f
		
	gen rel_Christian=cond(religion==1,1,0)
	gen rel_Muslim=cond(religion==2,1,0)
	gen tribe_Muslim=cond(tribe==13 | tribe==16 | tribe==15 | tribe==18,1,0) // Mandingo, Vai, Mende, Fula
	
	gen edu_none=cond(education==0,1,0)
	gen edu_abc=cond(education==1 | education==2,1,0)
	gen edu_jh=cond(education==3 | education==4,1,0)
	gen edu_hs=cond(education==5 | education==6,1,0)
	gen edu_post=cond(education==7 | education==8,1,0)
	gen high_edu=cond(education>=5,1,0) if education!=.
	
	gen age1830=cond(age<31,1,0)
	gen age3140=cond(age>30 & age<41,1,0)
	gen age4150=cond(age>40 & age<51,1,0)
	gen age5160=cond(age>50 & age<61,1,0)
	gen age6180=cond(age>60,1,0)
	
	qui sum hhsize,d
	gen hhsize_big=cond(hhsize>`r(p50)',1,0)
	
	replace income_personal=income_personal/100 if income_personal_unit==1
	replace income_hh=income_hh/100 if income_hh_unit==1

		qui sum income_personal, d
		gen low_income_personal=cond(income_personal<=`r(p50)',1,0)
		gen low_income_hh=cond(income_hh<=`r(p50)',1,0)

	gen literate=news
	gen rel_bigman_any=cond(rel_town_bigman==1 | rel_govt_bigman==1,1,0)

	gen cdc2017=cond(party2017r1==4,1,0)

	
	/* lables for tables */
	
	la var male "Male"
	la var age "Age"
	la var rel_Christian "Christian"
	la var edu_none "No education"
	la var edu_abc "Elementary education"
	la var edu_jh "Junior High education"
	la var edu_hs "High schools education"
	la var edu_post "Post secondary education"
	la var literate "Literate"

	placevar male age hhsize hhsize_big rel_Christian rel_bigman_any rel_town_bigman rel_govt_bigman edu_none edu_abc edu_jh edu_hs edu_post literate, after(COVARIATES)

	
// save dataset

save "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_endline.dta",replace
	

	
	
	
