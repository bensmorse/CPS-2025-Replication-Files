/***************************************************************************
*			Description: Cleaning file for LIB_MK4 Endline Survey Data
*			Inputs:  06_Raw Administrative Data/LIB_MK4_raw_data_lnp_admin.csv
*			Outputs:  /07_Processed Data/LIB_MK4_processed_data_lnp_admin.dta
*			Notes: This file
*				1. runs on raw de identified lnp admin data on crime reports
*				2. constructs outcome variables for hypothesis tk
*				3. saves the analysis-ready dataset as /07_Processed Data/LIB_MK4_processed_data_endline.dta
****************************************************************************/

	

// LOAD TOWN-LEVEL TREATMENT ASSIGNMENT DATA	
	
	insheet using "$LIB_MK4/01_Randomization/LIB_MK4_sample.csv",clear
	tempfile assignment
	save `assignment',replace		
	
	
// LOAD 2008 CENSUS DATA ON TOWN POPULATIONS

	insheet using "$LIB_MK4/04_Raw Administrative Data/LIB_MK4_2008_census.csv",clear
	tempfile census
	save `census',replace	 	
	
// MERGE FILES TO ENDLINE SURVEY DATA
	
	use "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_endline.dta",clear
	 
	gen BASELINE_VARS=.
		la var BASELINE_VARS "========================="
	merge m:1 towncode using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline_commlevel.dta",gen(cb_baselinemerge)
		
	gen MOB_VIOLENCE_DATA=.
		la var MOB_VIOLENCE_DATA "========================="
	merge m:1 towncode using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_mob_violence.dta",gen(mobviolencemerge)
		/* LIB_MK4_processed_data_mob_violence.dta only contains data for communities with reported acts of mob violence -- the remaining communities had zero acts, but currently coded as missing. so we replace with 0*/
		replace num_mob_viol=0 if num_mob_viol==.

	gen ASSIGNMENT_DATA=.
		la var ASSIGNMENT_DATA "========================="
	merge m:1 towncode using `assignment',gen(assignmentmerge)

	gen LNP_ADMIN_DATA=.
		la var LNP_ADMIN_DATA "========================="
	merge m:1 towncode using "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_lnp_admin.dta",gen(lnpadminmerge)
		
	gen CENSUS_DATA=.
		la var CENSUS_DATA "========================="
	merge m:1 towncode using `census',gen(censusmerge)
				
				
				
		
	/* Intervention not conducted in Police Zone 6. Police Zone 6 dropped from sample */
		
		drop if policezone=="ZONE 6"
		
		
	// CONSTRUCT SAMPLING WEIGHTS
	
		/* Following the LIB_MK4 PAP, P. 18: 
		"I will use weighted least squares (OLS) regression of the outcome on a dummy variable indicating 
		whether or not the community was assigned to the treatment group, with weights constructed as 
		the product of i) the inverse of the probability of assignment to treatment/control, and 
		ii) the inverse of the probability that an individual was selected for the endline survey. 
		The former accounts for the fact that the probability that a community is assigned to treatment 
		or control varies across randomization blocks (i.e. police zones) (see Gerber and Green (2012), 
		Section 3.4.3); the latter accounts for the fact that individuals from relatively large communities 
		have a lower likelihood of being included in the endline sample compared to those from relatively 
		small communities */
		
		/* sampling_prob denotes the probability that an observation is included because of sampling design */
		/* Recall that communities are subdivided into anywhere from three to six blocks, 
		and that the intervention and survey covered the THREE most central blocks within each community. 
		I make the simplifying assumption all blocks within a community are of the same size, 
		and calculate the sampling probability for individual $i$ in community $c$ as: */
		/* 20/(3*(localitypop/num_blocks)*/
		/* where 20 denotes the number sampled at endline */		
		
		gen sampling_prob = 20/(3*(localitypop/num_blocks))
		
		/* next, we construct assignment_prob, denoting the probability of assignment to treatment / control */
		
		bys towncode: gen towncount=_n
		/* this shows you what the weights should be within each strata */
		tab treatment policezone if towncount==1		
		
		gen assignment_prob = .
			replace assignment_prob = 4 / 9 if treatment == 1 & policezone=="ZONE 1"
			replace assignment_prob = 5 / 9 if treatment == 0 & policezone=="ZONE 1"
			
			replace assignment_prob = 6 / 13 if treatment == 1 & policezone=="ZONE 2"
			replace assignment_prob = 7 / 13 if treatment == 0 & policezone=="ZONE 2"
			
			replace assignment_prob = 8 / 15 if treatment == 1 & policezone=="ZONE 3"
			replace assignment_prob = 7 / 15 if treatment == 0 & policezone=="ZONE 3"
			
			replace assignment_prob = 5 / 10 if treatment == 1 & policezone=="ZONE 4"
			replace assignment_prob = 5 / 10 if treatment == 0 & policezone=="ZONE 4"
			
			replace assignment_prob = 4 / 9 if treatment == 1 & policezone=="ZONE 5"
			replace assignment_prob = 5 / 9 if treatment == 0 & policezone=="ZONE 5"
						
			replace assignment_prob = 4 / 9 if treatment == 1 & policezone=="ZONE 10"
			replace assignment_prob = 5 / 9 if treatment == 0 & policezone=="ZONE 10"
			
			replace assignment_prob = 4 / 7 if treatment == 1 & policezone=="ZONE 7"
			replace assignment_prob = 3 / 7 if treatment == 0 & policezone=="ZONE 7"
			
			replace assignment_prob = 4 / 9 if treatment == 1 & policezone=="ZONE 8"
			replace assignment_prob = 5 / 9 if treatment == 0 & policezone=="ZONE 8"
			
			replace assignment_prob = 6 / 12 if treatment == 1 & policezone=="ZONE 9"
			replace assignment_prob = 6 / 12 if treatment == 0 & policezone=="ZONE 9"
	
		
	codebook future_insecurity_idx satis_idx police_abuse_idx crime_reporting_idx tips_idx ///
	police_abuse_report_idx intentions_idx know_idx norm_idx police_capacity_idx s_responsive_act ///
	s_legit_trust s_trust_community compliance_idx

	
	
	/* labels for tables */
	
	la var crime_num_lbr "Total \# crimes reported"
	la var armedrob_num_sc "\# of armed robberies"
	la var aggassault_num_sc "\# of aggravated assaults"
	la var sexual_num_sc "\# of sexual violence"
	la var domestic_phys_num_sc "\# of domestic violence"
	la var land_viol_num_sc "\# of violence land disputes"
	la var cmurder_num "\# of murders"
	la var burglary_num_sc "\# of burglaries"
	la var simpleassault_num_sc "\# of simple assaults"
	la var domestic_verbal_num_sc "\# of domestic verbal abuse"
	la var land_nviol_num_sc "\# of non violent land disputes"
	la var cchildabuse_num "\# of child abuse"

	la var fear_violent_yes "Fears violent crime"
	la var fear_nonviolent_yes "Fears non-violent crime" 
	la var feared_walk_yes "Fears walking at night"
	la var feared_home_yes "Fears home invasions"
	la var motosecure_yes "Motorbike secure outside"
	la var generatorsecure_yes "Generator secure outside"
	la var hssecure_yes "House boundaries secure"
	la var hsitemssecure_yes "House items secure"
	
	la var satis_idx "Satisfaction w/ police performance idx"
	la var satis_trust_agree "Trusts police"
	la var satis_general_agree "Satisfied w/ police performance"
	
	la var police_abuse_idx "Police abuse idx"
	la var policeabuse_any "Seen police abuse past 6m"
	la var policeabuse_num "Num police abuse past 6m"
	la var policeabuse_report "Reported abuse to police" 
	la var bribe_freq "Num bribes past 6m"
	la var bribe_amt "Bribe amt past 6m"
	
	la var crimeres_idx_lbr "Crime resolution idx (std)"
	la var landres_pol "Land disputes"
	la var landresviol_pol "Violent land disputes"
	la var burglaryres_pol "Burglaries"
	la var dviolres_pol "Domestic violence"
	la var armedrobres_pol "Armed robbery"
		
		
	la var crime_tips_idx_lbr "Crime tips \& info sharing idx (std)"
	la var contact_pol_susp_activity  "Reported suspicious activity past 6m"
	la var contact_pol_find_suspect "Helped police find suspect past 6m"
	la var give_info_pol_investigation "Given info for investigation past 6m" 
	la var testify_police_investigation "Provided testimony past 6m"
	
	
	
	la var police_abuse_report_idx_lbr "Willingness to report police misconduct"
	la var checkpoint_report_likely "Would report illegal checkpoint"
	la var dutydrink_report_likely "Would report drunk officer"
	la var policebeating_report_likely "Would report police beating"
	
	
	
	la var intentions_idx_lbr "Trust police intentions idx (std)"
	la var polint_corrupt_agree "Police corrupt" 
	la var polint_quality_agree "Police treat all equal" 
	la var polcaseserious_agree "Police take cases seriously"
	la var polcasefair_agree "Police fair to all sides" 
	la var pol_care_agree "Police care about citizens' safety"
	la var polint_digresp_agree "Police respect citizens" 
	la var polint_decfact_agree "Police objective" 
	la var polcaserespect_agree "Police respect victims"
	
	
	
	la var intentions_idx_lbr "Trust police intentions idx (std)"
	la var polint_corrupt_agree "Police corrupt" 
	la var polint_quality_agree "Police treat all equal" 
	la var polcaseserious_agree "Police take cases seriously"
	la var polcasefair_agree "Police fair to all sides" 
	la var pol_care_agree "Police care about citizens' safety"
	la var polint_digresp_agree "Police respect citizens" 
	la var polint_decfact_agree "Police objective" 
	la var polcaserespect_agree "Police respect victims"
	
	
	
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
	
	
	la var norm_idx_lbr "Norms supporting cooperation idx (std)"
	la var reportnorm_theft_agree "Ppl get mad if you report a burglary?"
	la var reportnorm_abuse_agree "Ppl get mad if you report domestic violence?"
	la var reportnorm_land_agree "Ppl get mad if you report land disputes?"
	la var obeynorm_agree "Ppl should always obey the police"
	la var helppolnorm_armedrob_agree "Ppl get mad if you give info about armed robbery?"
	la var helppolnorm_domviol_agree "Ppl get mad if you give info about domestic violence?"
	la var helppolnorm_moto_agree "Ppl get mad if you give info about stolen motorcycle?"
	la var helppolnorm_childabuse_agree	"Ppl get mad if you give info about child abuse?"
	
	
	la var police_capacity_idx "Trust police capacity idx (std)"
	la var polcap_timely_agree "Police able to respond quickly"
	la var polcap_investigate_agree "Police able to investigate effectively"
	
	
	la var pol_responsiveness_lbr "Police responsiveness idx (std)"
	la var responsive_act_agree "Police act on citizens' feedback"
	la var responsive_listen_agree "Police include citizens in decision making"
	
	
	la var comm_cohesion "Trust in govt"
	la var days_comm_work "# days volunteer for community past month"
	la var cgroups "# groups a member of"
	la var trust_keys "Can trust neighbors with keys"
	la var comm_help "Neighbors would help when needed"
	
	
	la var compliance_idx "Compliance idx (std)"
	la var compliance_patrol_dum "Sees foot patrols daily or weekly"
	la var compliance_freq_dum "Sees vehicles patrols daily or weekly"
	la var compliance_meeting "Attended police mtg past 6m"
	
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
	
	
	/* save analysis ready dataset */
	
	saveold "$LIB_MK4/05_Processed Data/LIB_MK4_analysis.dta",replace version(12)
	






