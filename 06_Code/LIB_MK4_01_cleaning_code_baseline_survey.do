/***************************************************************************
*			Description: Cleaning File for LIB_MK4 Baseline
*			Inputs:  /05_Raw De-Identified Data/LIB_MK4_raw_data_baseline.csv
*			Outputs:  
*				/07_Processed Data/LIB_MK4_processed_data_baseline.dta 
*				/07_Processed Data/LIB_MK4_processed_data_baseline_commlevel.dta
*			Notes: 
****************************************************************************/


	insheet using "$LIB_MK4/03_Raw De-Identified Data/LIB_MK4_raw_data_baseline.csv",clear

	
	
/******* CONTENTS ************
MISCELLANEOUS CLEANING:
	CONVERT STRING VARS TO NUMERIC (ORDINAL VARIABLES) 
	CONVERT Y OR N STRING VARIABLES TO NUMERIC 0 OR 1
	DEFINE VARIABLE LABELS
	LABEL VARIABLE VALUES
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
	
	COVARIATES & DESCRIPTIVES
	
COLLAPSE TO COMMUNITY-LEVEL DATASET
	
*****************************/	


	/* town identifier, towncode, is missing for respid==10022003 */ 
	
	replace towncode = 1002 if respid==100218003
	
// CONVERT STRING VARS TO NUMERIC (ORDINAL VARIABLES) 

	gl demo income_personal_unit income_hh_unit employed male religion tribe education occupation assets_roof assets_walls assets_fuel assets_water reside_unit
 	gl community trust_community town_chair_pplsame town_chair_corr town_chair_open comm_help   
	gl knowledge know_law_statrape know_law_habeasc know_law_lawyer know_law_complain know_cwt_violent know_wacps know_psd know_law_suspect know_law_childsup know_law_fees know_law_bondfee know_cwt_petty know_cwt_beat know_cwt_cutlass
 	gl govt_legit vote2017 party2017 legit_trust legit_dem legit_respect legit_all
	gl perceptions responsive_act   responsive_listen pol_care pol_heart pol_empathy polint_corrupt polint_digresp polint_decfact polint_quality polcaseserious polcaserespect polcasefair suspect_fairtreat suspect_avoidprosec polcap_timely polcap_investigate satis_trust satis_general
	gl police_abuse bribe_freq bribe_amt_unit 
	gl norms reportnorm_theft reportnorm_abuse reportnorm_land obeynorm
	gl crime_prevention name_witness identify_hideout identify_ghetto guide_police give_testimony checkpoint_report dutydrink_report policebeating_report
	gl security fear_violent fear_nonviolent feared_walk feared_home hssecure compliance_patrol compliance_freq
	gl liberia_specific cwteamnightpatrol mobviol1 mobviol2 mobviol3
	
	foreach x of varlist $demo $community $perceptions $knowledge $govt_legit $police_abuse $norms $crime_prevention $security $liberia_specific {
			
			qui tab `x'

			cap local lbl: variable label `x'
			cap rename `x' `x'_
			cap egen `x' = ends (`x'_), punct(-) head
			cap move `x' `x'_
			cap drop `x'_
			cap destring `x', replace
			cap replace `x'=.a if `x'==97
			cap replace `x'=.b if `x'==98
			cap replace `x'=.c if `x'==88
			cap la var `x' "`lbl'"
 
		}
	 
	
// CONVERT Y OR N STRING VARIABLES TO NUMERIC 0 OR 1

	gl demo_yn phone readnews society rel_town_bigman rel_govt_bigman rel_pol_officer own_house trust_keys  
	gl knowledge_yn know_csd_name know_localcommander know_anyofficer know_policenumber policeabuse_phys_any policeabuse_verbal_any know_psd_name know_wacps_name know_report_station
	gl coop_crime_prevention_yn contact_pol_susp_activity  contact_pol_find_suspect give_info_pol_investigation testify_police_investigation
	gl treatment_compliance_yn cwteam compliance_meeting 
	gl crime_yn cmurder_any cchildabuse_any cmob_any
		
	foreach x of varlist $demo_yn $knowledge_yn $treatment_compliance_yn $coop_crime_prevention_yn $crime_yn {
	
		cap local lbl: variable label `x'
		cap rename `x' `x'_
		gen `x'=cond(`x'_=="Y",1,cond(`x'_=="N",0,.))
		la var `x' "`lbl'"
		move `x' `x'_
		drop `x'_
	
	}

	
// DEFINE  VARIABLE LABELS
	
	label drop _all
	label define frequency 1 "Everyday" 2 "Weekly" 3 "Monthly" 4 "Not too often"
	label define yesnodkrta 0 "No" 1 "Yes" .a "Don't know" .b "Refuse to answer"
	label define agreedisagree4point 0 "Strongly disagree" 1 "Disagree" 2 "Agree" 3 "Strongly agree" .a "Do not know " .b "Refuse to answer"
	label define agreedisagree5point 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" .a "Do not know " .b "Refuse to answer"
	label define extent 0 "Not at all" 1 "Just a little" 2 "Somewhat" 3 "A lot" .a "Don't know" .b "Refuse to answer"
	label define agreedisagree 0 "Disagree" 1 "Agree" .a "Don't know" .b "Refuse to answer"
	label define whorules 1 "Govt" 2 "NGOs" 3 "UNMIL" 4 "Community Leaders" 5 "Traditional Leaders" 6 "Community residents" 88 "Other"
	label define ability 0 "Very bad" 1 "Bad" 2 "Good" 3 "Very good"
	label define actor 1 "Anti government rebel group" 2 "LNP" 3 "Criminals" 4 "Traditional or village leaders" 5 "No one" 6 "Other" .a "Do not know " .b "Refuse to answer"
	label define respond 1 "Female LNP" 2 "Male LNP " 3 "Female traditional leader " 4 "Male traditional leader " .a "Do not know " .b "Refuse to answer"
	label define months 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec" .a "Do not know"
	label define months_since_July2017 1 "July 2017" 2 "June 2017" 3 "May 2017" 4 "April 2017" 5 "March 2017" 6 "February 2017" 7 "January" 8 "December 2016" 9 "November 2016" 10 "October 2016" 11 "September 2016" 12 "August 2016" .a "Do not know"
	label define howlikely 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" .a "Do not know" .b "Refuse to answer"
	label define howworied 1 "Somewhat worried" 2 "Worried" 3 "Very worried"
	label define gender 1 "Male" 2 "Female"
	label define education 0 "None" 1 "Some ABC" 2 "Completed ABC" 3 "Some JH" 4 "Completed JH" 5 "Some HS" 6 "Completed HS" 7 "Some University" 8 "Completed University" 88 "Other"
	label define religion 1 "Christian" 2 "Muslim" 3 "Other"
	label define tribe 1 "Bassa" 2 "Gbandi" 3 "Belle" 4 "Gbei" 5 "Gio" 6 "Gola" 7 "Grebo" 8 "Kissi" 9 "Kpelle" 10 "Krahn" 11 "Kru" 12 "Lorma" 13 "Mandingo" 14 "Mano" 15 "Mende" 16 "Vai" 17 "Congo" 18 "Fula" 19 "Other"
		// Note: occupation options don't match the common arm
	label define occupation 0 "None" 1 "Petty business" 2 "Buying and selling" 3 "Mining" 4 "Rubber tapping" 5 "Hunting" 6 "Road work" 8 "Daily hire" 9 "Peim peim" 10 "Making farm" 11 "Skilled trade" 12 "Office work" 13 "Hustling" 14 "Other" 88 "Other"
	label define employed 1 "Employed full time" 2 "Employed part time" 3 "Retired" 4 "Chose not to work" 5 "Unemployed" 98 "Refuse to answer"
	label define assets_roof 1 "Thatch" 2 "Wood" 3 "Plastic" 4 "Zinc" 5 "Concrete" 6 "Mud" 7 "Other"
	label define assets_walls 1 "Mud and sticks" 2 "Thatch or plants" 3 "Cardboard or plastic" 4 "Cement or Mud and Cement" 5 "Bricks" 88 "Other"
	label define assets_fuel 1 "Wood" 2 "Coal" 3 "Gas"
	label define assets_water 1 "Personal faucet" 2 "Shared faucet" 3 "Well" 4 "Spring or stream" 5 "Mineral water" 88 "Other"
	label define reside_unit 1 "One to three years" 2 "Four to ten years" 3 "More than than 10 years"
	label define truefalse 0 "False" 1 "True" .a "Do not know" .b "Refuse to answer"
	label define bribe_freq 1 "None" 2 "Once" 3 "Between 2 and 5 times" 4 "More than 5 times" .a "Do not know" .b "Refuse to answer"
	

// LABEL VARIABLE VALUES

	la values male gender
	la values religion religion
	la values tribe tribe
	la values education education
	la values occupation occupation
	la values employed employed
	la values assets_roof assets_roof
	la values assets_walls assets_walls
	la values assets_fuel assets_fuel
	la values assets_water assets_water
	la values reside_unit reside_unit
	la values know_law_statrape know_law_habeasc know_law_lawyer know_law_complain know_cwt_violent know_wacps know_psd know_csd_name know_law_suspect know_law_childsup know_law_fees know_law_bondfee know_cwt_petty know_cwt_beat know_cwt_cutlass truefalse
	la values bribe_freq bribe_freq
	la values name_witness identify_hideout identify_ghetto guide_police give_testimony checkpoint_report dutydrink_report policebeating_report howlikely
	la values reportnorm_abuse reportnorm_land obeynorm agreedisagree5point
	la values legit_respect legit_all agreedisagree5point
	la values fear_violent fear_nonviolent howworried
		
			

// H1A INCIDENCE OF CRIME 
	
	gen H1A_INCIDENCE_OF_CRIME=.
		la var H1A_INCIDENCE_OF_CRIME "====================================="
		placevar H1A_INCIDENCE_OF_CRIME, f

	
	/* questions on crime at baseline asked categorically but measured continuously at baseline. here we convert to numeric, imputing lowest number in category*/
	
	foreach x of varlist cmurder_num cchildabuse_num carmedrob_num csimpleassault_num caggassault_num csexual_num cdomestic_phys_num cburglary_num  cdomestic_verbal_num cland_num cother_num {
	
	replace `x'="1" if `x'=="1-Once"
	replace `x'="2" if `x'=="2-Two to three times" | `x'=="2-Two to five times"
	replace `x'="4" if `x'=="3-Four to five times"
	replace `x'="6" if `x'=="4-Six to ten times"
	replace `x'="15" if `x'=="4-More than ten times" | `x'=="5-More than ten times"
	replace `x'="" if `x'=="97-Do not know"
	destring `x', replace
	
	}

	
	/* In raw form, [crime]_num is . if [crime]_any = "No"; here, replace [crime]_num with 0 where [crime]_any = "No" */
	
	foreach x in armedrob simpleassault aggassault sexual domestic_phys burglary domestic_verbal land other carmedrob csimpleassault caggassault csexual cdomestic_phys cburglary cdomestic_verbal cland cother cmob cmurder cchildabuse {
	
	replace `x'_num=0 if `x'_any==0
	
	}
	
	/* create binary versions of [crime]_num, equal to 1 if greater than 0 instances */
	
	
	foreach x in armedrob simpleassault aggassault sexual domestic_phys burglary domestic_verbal ///
	land other carmedrob csimpleassault caggassault csexual cdomestic_phys cburglary cdomestic_verbal ///
	cland cother cmob cmurder cchildabuse {
	
	gen `x'_bin=`x'_any
	
	}	

		
	/* Code other_any crimes as violent or non violent based on other_any_des */
	/* To verify these changes: browse respid other_any_des if other_any==1 */
	
	gen other_any_violent = 0 
	replace other_any_violent=1 if respid==10051404 | respid==20041601 | respid==20051402 | respid==20051404 | respid==20161404 | respid==30001403 | respid==30211401 | respid==40191401 | respid==70021403 | respid==90272201 | respid==100021401 | respid==100022204 | respid==100141401 | respid==100201601 | respid==100201604	
	
	gen other_any_nonviolent = other_any
		replace other_any_nonviolent = 0 if other_any_violent==1
	
	gen other_report_violent = ""
	replace other_report_violent = other_report if respid==10051404 | respid==20041601 | respid==20051402 | respid==20051404 | respid==20161404 | respid==30001403 | respid==30211401 | respid==40191401 | respid==70021403 | respid==90272201 | respid==100021401 | respid==100022204 | respid==100141401 | respid==100201601 | respid==100201604	
	
	gen other_report_nonviolent = other_report
	replace other_report_nonviolent = "" if other_any_violent==1
	
	
	
	
	/* Do the same for cother_any */
	
	gen cother_any_violent = 0
		replace cother_any_violent = 1 if respid==10011502 | respid==10081202 | respid==10111904 | respid==10141703 | respid==10221201 | respid==10221202 | respid==10221203 | respid==10221204 | respid==10221205 | respid==10221601 | respid==10221602 | respid==10221603 | respid==10221604 | respid==10221605 | respid==20011701 | respid==20011703 | respid==20011704 | respid==20041602 | respid==20042303 | respid==20042304 | respid==20052201 | respid==20052204 | respid==20161403 | respid==20232205 | respid==20251203 | respid==20271702 | respid==20271703 | respid==20281202 | respid==20282301 | respid==20321704 | respid==20372301 | respid==20401701 | respid==30001303 | respid==30001304 | respid==30021704 | respid==30021705 | respid==30051701 | respid==30051702 | respid==30051705 | respid==30092302 | respid==30121204 | respid==30121502 | respid==30241702 | respid==30242102 | respid==30271802 | respid==40052001 | respid==40052101 | respid==40141902 | respid==40191405 | respid==40242304 | respid==40271305 | respid==50051905 | respid==50131302 | respid==50131303 | respid==50131305 | respid==50131403 | respid==50131901 | respid==60032202 | respid==60111202 | respid==60111503 | respid==60111505 | respid==60112301 | respid==70021405 | respid==70032302 | respid==70051902 | respid==70111301 | respid==70111304 | respid==70111903 | respid==80062004 | respid==80151202 | respid==90271304 | respid==90281702 | respid==100021302 | respid==100022203 | respid==100041702 | respid==100141301 | respid==100141304 | respid==100141405 | respid==100161703 | respid==100201603 | respid==100201605 | respid==100341701
	
	gen cother_any_nonviolent = cother_any
		replace cother_any_nonviolent = 0 if cother_any_violent==1
	
	gen cother_report_violent = ""
	replace cother_report_violent = cother_report if respid==10011502 | respid==10081202 | respid==10111904 | respid==10141703 | respid==10221201 | respid==10221202 | respid==10221203 | respid==10221204 | respid==10221205 | respid==10221601 | respid==10221602 | respid==10221603 | respid==10221604 | respid==10221605 | respid==20011701 | respid==20011703 | respid==20011704 | respid==20041602 | respid==20042303 | respid==20042304 | respid==20052201 | respid==20052204 | respid==20161403 | respid==20232205 | respid==20251203 | respid==20271702 | respid==20271703 | respid==20281202 | respid==20282301 | respid==20321704 | respid==20372301 | respid==20401701 | respid==30001303 | respid==30001304 | respid==30021704 | respid==30021705 | respid==30051701 | respid==30051702 | respid==30051705 | respid==30092302 | respid==30121204 | respid==30121502 | respid==30241702 | respid==30242102 | respid==30271802 | respid==40052001 | respid==40052101 | respid==40141902 | respid==40191405 | respid==40242304 | respid==40271305 | respid==50051905 | respid==50131302 | respid==50131303 | respid==50131305 | respid==50131403 | respid==50131901 | respid==60032202 | respid==60111202 | respid==60111503 | respid==60111505 | respid==60112301 | respid==70021405 | respid==70032302 | respid==70051902 | respid==70111301 | respid==70111304 | respid==70111903 | respid==80062004 | respid==80151202 | respid==90271304 | respid==90281702 | respid==100021302 | respid==100022203 | respid==100041702 | respid==100141301 | respid==100141304 | respid==100141405 | respid==100161703 | respid==100201603 | respid==100201605 | respid==100341701
	
	gen cother_report_nonviolent = cother_report
	replace cother_report_nonviolent = "" if cother_any_violent==1
	
	
	
	/* note: cother_report all missing values due to coding error */

	
	
	// CONSTRUCT INDICES PERTAINING TO H1A
	/* note: other_any incldues other violent crimes, hence these are double counted below. */
	/* following mpap, so no change made here */
	
	//gen crime_num = armedrob_num + burglary_num + simpleassault_num + other_any
	gen violentcrime_num = armedrob_num  + simpleassault_num + other_any_violent
	gen violentcrime_num_exp = armedrob_num  + aggassault_num + sexual_num + domestic_phys_num + simpleassault_num + other_any_violent
	gen nonviolentcrime_num =  burglary_num + other_any_nonviolent
	gen nonviolentcrime_num_exp =  burglary_num + domestic_verbal_num +  land_any + other_any_nonviolent
	
	gen violentcrime_bin = armedrob_bin + simpleassault_bin + other_any_violent
	gen nonviolentcrime_bin = burglary_bin + other_any_nonviolent
	
	//gen ccrime_num = carmedrob_num + caggassault_num + csimpleassault_num + csexual_num + cdomestic_phys_num + cmurder_num + cother_any
	gen cviolentcrime_num = carmedrob_num + caggassault_num + csimpleassault_num + csexual_num + cdomestic_phys_num + cmurder_num  + cother_any_violent
	gen cviolentcrime_bin = carmedrob_bin + caggassault_bin + csimpleassault_bin + csexual_bin + cdomestic_phys_bin + cmurder_bin  + cother_any_violent
	gen cviolentcrime_num_exp = carmedrob_num + caggassault_num + csimpleassault_num + csexual_num + cdomestic_phys_num + cmurder_num  + cother_any_violent + cmob_num
	
	gen cnonviolentcrime_num = cburglary_num + cother_any_nonviolent
	gen cnonviolentcrime_bin = cburglary_bin + cother_any_nonviolent
	gen cnonviolentcrime_num_exp = cburglary_num + cland_any + cdomestic_verbal_num + cother_any_nonviolent
	
 	
	/* note: mpap instructions for indices: standardizing each outcome variable to the mean and standard deviation of the variable at baseline and then taking the mean across the variables in the index for each respondent */
		
	foreach x of varlist violentcrime_num nonviolentcrime_num cviolentcrime_num cnonviolentcrime_num ///
	violentcrime_num_exp nonviolentcrime_num_exp cviolentcrime_num_exp cnonviolentcrime_num_exp ///
	violentcrime_bin nonviolentcrime_bin cviolentcrime_bin cnonviolentcrime_bin cmob_num {
		
			egen s_`x'=std(`x')
		
		}
	
	
	gen crime_victim_idx = (s_violentcrime_num + s_nonviolentcrime_num + s_cviolentcrime_num+ s_cnonviolentcrime_num)
	gen crime_victim_idx_exp = (s_violentcrime_num_exp + s_nonviolentcrime_num_exp + s_cviolentcrime_num_exp+ s_cnonviolentcrime_num_exp)
	gen crime_victim_idx_bin = (s_violentcrime_bin + s_nonviolentcrime_bin + s_cviolentcrime_bin+ s_cnonviolentcrime_bin)
	
	egen s_crime_victim_idx = std (crime_victim_idx)
	egen s_crime_victim_idx_exp = std (crime_victim_idx_exp)
	egen s_crime_victim_idx_bin = std (crime_victim_idx_bin)
	  
	
	/* Construct crime variables unique to Liberia */
	
		/* total number of crimes by category, combining self and others victimization */
		
		foreach x in armedrob burglary aggassault simpleassault sexual domestic_phys domestic_verbal land {
		
			gen `x'_num_sc=`x'_num + c`x'_num
			
		}
		
		gen other_num_sc=other_any + cother_any
		gen other_violent_num_sc=other_any_violent + cother_any_violent
	
		gen cmurder_num_sc = cmurder_num
		gen cchildabuse_num_sc = cchildabuse_num
	
		gen crime_num_violent_lbr=armedrob_num_sc + simpleassault_num_sc + aggassault_num_sc + sexual_num_sc + domestic_phys_num_sc + other_any_violent + cother_any_violent
		gen crime_num_nviolent_lbr=burglary_num_sc + domestic_verbal_num_sc + land_num_sc
		gen crime_num_lbr=crime_num_violent_lbr + crime_num_nviolent_lbr
		gen crime_num_felony=armedrob_num_sc + aggassault_num_sc + sexual_num_sc + domestic_phys_num_sc + other_any_violent + cother_any_violent
		gen crime_num_msdmnr=burglary_num_sc + simpleassault_num_sc + domestic_verbal_num_sc + land_num_sc
	
	/* organize security variables */
	
	placevar violentcrime_num - crime_num_felony, after(H1A_INCIDENCE_OF_CRIME)
	

//  H1B PERCEPTIONS OF SAFETY (PERSONAL, LAND, AND POSSESSIONS)
	
		
	gen H1B_SECURITY=.
	la var H1B_SECURITY "====================================="
	placevar H1B_SECURITY, f

	/* note: mpap instructions for indices: standardizing each outcome variable to the mean and standard deviation of the variable at baseline and then taking the mean across the variables in the index for each respondent */
		
		foreach x of varlist fear_violent fear_nonviolent feared_walk feared_home hssecure {
		
			egen s_`x'=std(`x')
		
		}
		
	gen future_insecurity_idx= (s_fear_violent + s_fear_nonviolent + s_feared_walk)/3
	
	/* more security vars collected in Liberia */
	gen future_insecurity_idx_lbr=(s_fear_violent + s_fear_nonviolent + s_feared_walk + s_feared_home + s_hssecure)/5
	
	/* recode so higher values equate to more security */
	
	gen future_security_idx=future_insecurity_idx*-1
	gen future_security_idx_lbr=future_insecurity_idx_lbr*-1
	
	/* create variables for descriptive tables */
		
	gen fear_violent_yes=cond(fear_violent==1 | fear_violent==2 | fear_violent==3,1,0)
	gen fear_nonviolent_yes=cond(fear_nonviolent==1 | fear_nonviolent==2 | fear_nonviolent==3,1,0)
	gen feared_walk_yes=cond(feared_walk==1 | feared_walk==2 | feared_walk==3 | feared_walk==4,1,0)
	gen feared_home_yes=cond(feared_home==1 | feared_home==2 | feared_home==3 | feared_home==4,1,0)

	
	/* organize variables*/
	
	placevar future_insecurity_idx future_insecurity_idx_lbr future_security_idx future_security_idx_lbr fear_violent fear_nonviolent feared_walk feared_home hssecure fear_violent_yes fear_nonviolent_yes feared_home_yes feared_walk_yes, after(H1B_SECURITY)
		

// H2 PERCEPTIONS OF POLICE

		gen H2_PERCEPTIONS_POLICE=.
		la var H2_PERCEPTIONS_POLICE "====================================="
		placevar H2_PERCEPTIONS_POLICE, f
		
		foreach x of varlist satis_trust satis_general {
		
			egen s_`x'=std(`x')
		
		}
		
		gen satis_idx =  (s_satis_trust + s_satis_general) / 2
		
	
	/* agree disagree coding  for descriptive tables */
	
	foreach x of varlist satis_trust satis_general {
	
		gen `x'_agree=cond(`x'==3 | `x'==4,1,0)
	}

	
	/* labels for tables */
	
	la var satis_idx "Satisfaction w/ police performance idx"
	la var satis_trust_agree "Trusts police"
	la var satis_general_agree "Satisfied w/ police performance"
		
	
	placevar satis_idx satis_trust_agree satis_general_agree, after(H2_PERCEPTIONS_POLICE)


// H3A PERCEPTIONS OF POLICE EMPATHY, ACCOUNTABILITY, AND ABUSE AND CORRUPTION CONCERNS

	/* uses data from police surveys.*/
	/* excluded from liberia study */


// H3B REPORTING OF POLICE ABUSE AND BRIBERY
	
	/* excluded from hypotheses & analysis for liberia bc we randomize within rather than across jurisdictions */
	/* hence the logic behind this hypothesis, that "community policing may also increase police intentions and efficacy directly, for example due to increased interaction and learning about citizen attitudes and intentions. By increasing reporting of police abuse, community policing may also increase accountability from police supervisors who can sanction corrupt or physically abusive officers​" (MPAP, p. 11), does not hold. Because both T and C communities interact with the same officers, we wouldn't expect to observe any less abuse in C communities as compared to T communities. */
	/* but vars still constructed here */

	
	gen H3B_POLICE_ABUSE=.
	la var H3B_POLICE_ABUSE "====================================="
	placevar H3B_POLICE_ABUSE, f
	
	gen policeabuse_any=cond(policeabuse_verbal_any ==1 | policeabuse_phys_any==1,1,0)
	
	/* per survey skip order, [x]_num is NA if [x]_any is 0 */
	
	replace policeabuse_verbal_num=0 if policeabuse_verbal_any==0
	replace policeabuse_phys_num=0 if policeabuse_phys_any==0
	
	gen policeabuse_num=policeabuse_verbal_num + policeabuse_phys_num
		
		
	/* abuse reported to police if reported to police station or commander (2) or LNP's professional standards division (6) */
			split policeabuse_phys_report, parse(;) gen(policeabuse_phys_report)
			split policeabuse_verbal_report, parse(;) gen(policeabuse_verbal_report)

	gen policeabuse_report=cond(policeabuse_phys_report1=="2-Police staion or police comm" | policeabuse_phys_report1=="6-Professional Standards Divis" | policeabuse_phys_report2=="2-Police staion or police comm" | policeabuse_phys_report2=="6-Professional Standards Divis" | policeabuse_verbal_report1=="2-Police staion or police comm" | policeabuse_verbal_report1=="6-Professional Standards Divis" | policeabuse_verbal_report2=="2-Police staion or police comm" | policeabuse_verbal_report2=="6-Professional Standards Divis",1,0)
		drop policeabuse_phys_report1 policeabuse_phys_report2 policeabuse_verbal_report1 policeabuse_verbal_report2
			
	replace bribe_amt=bribe_amt/100 if bribe_amt_unit==1
	/* per survey skip order, [x]_amt is NA if [x]_freq is "1-None" */
		replace bribe_amt=0 if bribe_freq==1 
		drop bribe_amt_unit
		la var bribe_amt "bribe amt (USD)"
		
	/* police abuse index */
	
	foreach x of varlist policeabuse_any policeabuse_num policeabuse_report bribe_freq bribe_amt {
		
			egen s_`x'=std(`x')
		
	}

	gen police_abuse_idx=(s_policeabuse_any + s_policeabuse_num + s_policeabuse_report + s_bribe_freq + s_bribe_amt) / 5
	
	/* organize variables */
	placevar policeabuse_any policeabuse_num policeabuse_report police_abuse_idx, after(H3B_POLICE_ABUSE)


	
// 4A. POSITIVE EFFECT ON REPORTING OF CRIME VICTIMIZATION

		gen H4A_CRIME_REPORTING=.
		la var H4A_CRIME_REPORTING "========================="
		placevar H4A_CRIME_REPORTING, f
	
		/* NA IN LIBERIA (NOT HOTLINE) */
		
		*acrime_hline ADMIN: Total number of reports of crimes to hotline
		*aviolent_hline ADMIN: Number of reports of violent crimes to hotline
		*anonviolent_hline ADMIN: Number of reports of non-violent crimes to hotline
		
		
		/* FOR ADMIN DATA ON CRIME REPORTING, SEE ADMIN DATA CLEANING FILE */
		

		/* CRIME REPORTING (SURVEY) */
		
			/* Following MPAP, [crime]_REPORT recoded as 0 if i) crime did not occur or 2) crime occurred and not reported; otherwise coded as 1 */

		
		/* Crime reporting - self victimization crime vars */
		
			*[crime]_report were select all that apply, separated by ;
			*below, we parse these responses before recoding following guidelines in MPAP
			*to preserve raw survey var, we create a duplicate with suffix "raw"
			
		
		foreach x of varlist armedrob_report burglary_report simpleassault_report other_report other_report_violent {
			
			* preserve raw survey var
			ren `x' `x'_raw
			* parse var
			split `x'_raw, parse(;) 

		}
		
			* construct [crime]_report vars
			
			gen armedrob_report=cond(armedrob_report_raw1=="1-Police",1,0)
			gen burglary_report=cond(burglary_report_raw1=="1-Police" | burglary_report_raw2=="1-Police",1,0)
			gen simpleassault_report=cond(simpleassault_report_raw1=="1-Police" | simpleassault_report_raw2=="1-Police",1,0)
			gen other_report=cond(other_report_raw1=="1-Police" | other_report_raw2=="1-Police",1,0)
			gen other_report_violent=cond(other_report_violent_raw1=="1-Police",1,0)
		
		egen crime_report_num = rowtotal (armedrob_report burglary_report simpleassault_report other_report)
		egen violentcrime_report_num = rowtotal (armedrob_report burglary_report simpleassault_report other_report_violent)

		
		/* Others' crime victimization vars */
			* same process as above
			
		foreach x of varlist carmedrob_report cburglary_report caggassault_report csimpleassault_report csexual_report cdomestic_phys_report cother_report cother_report_violent {
			
			* preserve raw survey var
			ren `x' `x'_raw
			* parse var
			split `x'_raw, parse(;) 

		}
			
		gen carmedrob_report=cond(carmedrob_report_raw1=="1-Police" | carmedrob_report_raw2=="1-Police",1,0)
		gen cburglary_report=cond(cburglary_report_raw1=="1-Police" | cburglary_report_raw2=="1-Police",1,0)
		gen caggassault_report=cond(caggassault_report_raw1=="1-Police" | caggassault_report_raw2=="1-Police",1,0)
		gen csimpleassault_report=cond(csimpleassault_report_raw1=="1-Police" | csimpleassault_report_raw2=="1-Police",1,0)
		gen csexual_report=cond(csexual_report_raw1=="1-Police" | csexual_report_raw2=="1-Police",1,0)
		gen cdomestic_phys_report=cond(cdomestic_phys_report_raw1=="1-Police" | cdomestic_phys_report_raw2=="1-Police" | cdomestic_phys_report_raw3=="1-Police",1,0)
		gen cother_report=cond(cother_report_raw1=="1-Police" | cother_report_raw2=="1-Police" | cother_report_raw3=="1-Police",1,0)
		gen cother_report_violent=cond(cother_report_violent_raw1=="1-Police" | cother_report_violent_raw2=="1-Police" | cother_report_violent_raw3=="1-Police",1,0)

		egen ccrime_report_num = rowtotal(carmedrob_report cburglary_report caggassault_report csimpleassault_report csexual_report cdomestic_phys_report cother_report_violent)
		egen cviolentcrime_report_num = rowtotal(carmedrob_report cburglary_report caggassault_report csimpleassault_report csexual_report cdomestic_phys_report cother_report cother_report_violent)

		

		/* HYPOTHETICAL REPORTING */	
		
			
		split burglaryres, parse(;) gen(burglaryres)
		split dviolres, parse(;) gen(dviolres)
		split armedrobres, parse(;) gen(armedrobres)


		foreach x of varlist burglaryres dviolres armedrobres {
			
			gen `x'_pol=cond(`x'1=="1-Police",1,0)
			gen `x'_formal=cond(`x'1=="1-Police" | `x'1=="2-Court",1,0)
		
		}
		

		/* H4A INDICES */
		
		/* crime resolution index*/
		
		/* standardize input vars for index */
		foreach x of varlist burglaryres_pol dviolres_pol armedrobres_pol {
			
				egen s_`x'=std(`x')
			
		}
			
	
		gen crimeres_idx = (s_burglaryres_pol + s_dviolres_pol + s_armedrobres_pol) /3
		gen crimeres_idx_lbr = (s_burglaryres_pol + s_dviolres_pol + s_armedrobres_pol) /3
		
		
		/* crime reporting index*/
		
		/* standardize input vars for indices */
		foreach x of varlist crime_report_num violentcrime_report_num ccrime_report_num cviolentcrime_report_num crimeres_idx {
			
				egen s_`x'=std(`x')
			
		}
		
		gen crime_reporting_idx = (s_crime_report_num + s_violentcrime_report_num + s_ccrime_report_num + s_cviolentcrime_report_num + s_crimeres_idx)/5
		
		placevar burglaryres_pol - armedrobres_formal crimeres_idx crimeres_idx_lbr crime_reporting_idx, after(H4A_CRIME_REPORTING)
	
	
// H4B COOPERATION IN CRIME PREVENTION / CRIME TIPS
	
	gen H4B_COOPERATION_CRIME_PREVENTION=.
		la var H4B_COOPERATION_CRIME_PREVENTION "========================="
		placevar H4B_COOPERATION_CRIME_PREVENTION, f
		
	/* NA in Liberia: atips_hline atips_box */
		

	/* standardize input vars for indices */
	foreach x of varlist contact_pol_susp_activity  contact_pol_find_suspect give_info_pol_investigation testify_police_investigation name_witness identify_hideout identify_ghetto guide_police give_testimony {
			
		egen s_`x'=std(`x')
			
	}
			
	gen crime_tips_idx=(s_contact_pol_susp_activity + s_give_info_pol_investigation)/2
	gen tips_idx = crime_tips_idx /* atips_hline atips_box excluded b/c NA in LIB */
	gen crime_tips_idx_lbr=(s_contact_pol_susp_activity + s_contact_pol_find_suspect + s_give_info_pol_investigation + s_testify_police_investigation)/4
	gen crime_tips_idx_lbr2=(s_name_witness + s_identify_hideout + s_identify_ghetto + s_guide_police + s_give_testimony)/5
		
	placevar crime_tips_idx crime_tips_idx_lbr crime_tips_idx_lbr2 contact_pol_susp_activity  contact_pol_find_suspect give_info_pol_investigation testify_police_investigation, after(H4B_COOPERATION_CRIME_PREVENTION)
	
	
// H4C. WILLINGNESS TO REPORT POLICE ABUSE	
	
	gen H4C_REPORT_POLICE_ABUSE=.
		la var H4C_REPORT_POLICE_ABUSE "========================="
		placevar H4C_REPORT_POLICE_ABUSE, f

		/* NA in Liberia: apolvtm_hline apolvtm_cmtbox apolvtm_station */
			
	/* standardize input vars for indices */
	foreach x of varlist checkpoint_report dutydrink_report policebeating_report {
			
		egen s_`x'=std(`x')
			
	}
	
	
	gen police_abuse_report_idx = (s_policeabuse_report + s_dutydrink_report + s_policebeating_report)/3
	gen police_abuse_report_idx_lbr = (s_policeabuse_report+s_checkpoint_report + s_dutydrink_report + s_policebeating_report)/4
	
	placevar police_abuse_report_idx police_abuse_report_idx_lbr checkpoint_report dutydrink_report policebeating_report, after(H4C_REPORT_POLICE_ABUSE)
	
	
// M1A BELIEFS ABOUT POLICE INTENTIONS	

	gen M1A_POLICE_INTENTIONS=.
		la var M1A_POLICE_INTENTIONS "========================="
		placevar M1A_POLICE_INTENTIONS, f

	/* standardize input vars for indices */
	foreach x of varlist polint_corrupt polint_quality polcaseserious polcasefair pol_care polint_digresp polint_decfact polcaserespect {
			
		egen s_`x'=std(`x')
			
	}
			
	/* recode polint_corrupt for indices so positive is 'good'*/
	
	gen s_polint_corrupt_rec=s_polint_corrupt*-1
	
	/* construct intentions indices */
	
	gen polint_idx = (s_polint_corrupt_rec + s_polint_quality )/2
	
	gen intentions_idx = (s_polint_corrupt_rec + s_polint_quality + s_polcaseserious + s_polcasefair)/4
	gen intentions_idx_lbr = (s_polint_corrupt_rec + s_polint_quality +s_polcaseserious + s_polcasefair + s_pol_care +  s_polint_digresp + s_polint_decfact + s_polcaserespect)/8
	
	
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
	
	/* KNOWLEDGE QUESTIONS - CORRECT ANSWER IS TRUE */
	foreach x of varlist know_law_statrape know_law_habeasc know_law_lawyer know_law_complain know_cwt_violent know_wacps know_psd know_csd_name know_psd_name know_wacps_name {
	
	gen `x'_correct=cond(`x'==1,1,0)
	
	}
	
	/* KNOWLEDGE QUESTIONS - CORRECT ANSWER IS  FALSE */
	
	foreach x of varlist know_law_childsup know_law_suspect know_cwt_cutlass know_cwt_beat know_law_fees know_law_bondfee  {
	
	gen `x'_correct=cond(`x'==0,1,0)
	
	}
	
	/* standardize vars for indices */
	
	foreach x of varlist know_law_statrape_correct know_law_habeasc_correct know_law_lawyer_correct know_law_complain_correct know_law_childsup_correct know_law_suspect_correct know_law_fees_correct know_law_bondfee_correct know_report_station {
			
		egen s_`x'=std(`x')
			
	}
	
	
	/* know_report_followup, a question about following up on police hotlines, is NA in Liberia, so will be excluded */
	/* know_law_vaw not measured in Liberia by oversight */
	
	gen know_law_idx = (s_know_law_suspect_correct + s_know_law_lawyer_correct + s_know_law_fees_correct)/3 	
	gen know_report_idx = (s_know_report_station) /* know_report_followup is NA in Liberia */
	gen know_idx = (s_know_law_suspect_correct + s_know_law_lawyer_correct + s_know_law_fees_correct + s_know_report_station)/4
	gen know_idx_lbr = (s_know_law_statrape_correct + s_know_law_habeasc_correct + s_know_law_lawyer_correct + s_know_law_complain_correct + s_know_law_childsup_correct + s_know_law_suspect_correct + s_know_law_fees_correct + s_know_law_bondfee_correct)/8
	
	 	
	/* Liberia specific hypothesis H1 - familiarity with police */
	
	foreach x of varlist know_wacps_correct know_psd_correct know_csd_name_correct know_psd_name_correct know_wacps_name_correct know_localcommander know_anyofficer know_policenumber {
			
		egen s_`x'=std(`x')
			
	}
		
	
	gen know_pol_idx = (s_know_wacps_correct + s_know_psd_correct + s_know_csd_name_correct + s_know_psd_name_correct + s_know_wacps_name_correct + s_know_localcommander + s_know_anyofficer + s_know_policenumber) /8
	
	
	/* Liberia specific hypothesis H8a - knowledge of rules governing community watch forums/teams */
	
	foreach x of varlist know_cwt_cutlass_correct know_cwt_beat_correct know_cwt_violent_correct {
		egen s_`x'=std(`x')		
	}
	
	gen know_cwt_idx = (s_know_cwt_cutlass_correct + s_know_cwt_beat_correct + s_know_cwt_violent_correct)/3
	 	

	placevar know_law_idx know_idx know_idx_lbr know_pol_idx know_cwt_idx know_law_statrape_correct know_law_habeasc_correct know_law_lawyer_correct know_law_complain_correct know_law_childsup_correct know_law_suspect_correct know_law_fees_correct know_law_bondfee_correct know_wacps_correct know_psd_correct know_csd_name_correct know_psd_name_correct know_wacps_name_correct know_localcommander know_anyofficer know_policenumber know_cwt_cutlass_correct know_cwt_beat_correct know_cwt_violent_correct, after(M1B_KNOWLEDGE)
	 

// M1C  NORMS OF CITIZEN COOPERATION WITH POLICE

	gen M1C_NORMS=.
		la var M1C_NORMS "========================="
		placevar M1C_NORMS, f
		
		
	/* standardize vars for indices */
	
	foreach x of varlist reportnorm_theft reportnorm_abuse reportnorm_land obeynorm {
			
		egen s_`x'=std(`x')
			
	}
			
			
	/* reverse code so higher equals greater support for reporting / cooperating */
	
	foreach x of varlist s_reportnorm_theft s_reportnorm_abuse s_reportnorm_land {
	
		gen `x'_rev=`x'*-1
	
	}

			
	gen norm_idx=(s_reportnorm_theft_rev + s_reportnorm_abuse_rev + s_obeynorm)/3
	gen norm_idx_lbr=(s_reportnorm_theft_rev + s_reportnorm_abuse_rev + s_reportnorm_land_rev + s_obeynorm)/4

	
	
	/* agree disagree coding for descriptive tables */
	foreach x of varlist reportnorm_theft reportnorm_abuse reportnorm_land obeynorm  {
		gen `x'_agree=cond(`x'==3 | `x'==4,1,0)
	}
	
	
	/*labels for tables */
	la var norm_idx_lbr "Norms against cooperation idx (std)"
	la var reportnorm_theft_agree "Ppl get mad if you report a burglary?"
	la var reportnorm_abuse_agree "Ppl get mad if you report domestic violence?"
	la var reportnorm_land_agree "Ppl get mad if you report land disputes?"
	la var obeynorm_agree "Ppl should always obey the police"
		
	placevar norm_idx norm_idx_lbr reportnorm_theft_agree - obeynorm_agree , after(M1C_NORMS)
	
		
// M2A  BELIEFS ABOUT POLICE CAPACITY / RETURNS TO COOPERATION

	gen M2A_POLICE_CAPACITY=.
		la var M2A_POLICE_CAPACITY "========================="
		placevar M2A_POLICE_CAPACITY, f
	
	/* standardize vars for indices */
	
	foreach x of varlist polcap_timely polcap_investigate {
			
		egen s_`x'=std(`x')
			
	}
	
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
	
	
	/* standardize vars for indices */
	
	foreach x of varlist responsive_act responsive_listen {
			
		egen s_`x'=std(`x')
			
	}
	
	gen pol_responsiveness_lbr = (s_responsive_act + s_responsive_listen ) /2
	
	
	/* agree disagree coding just for descriptives */
	foreach x of varlist responsive_act responsive_listen {
	
		gen `x'_agree=cond(`x'==3 | `x'==4,1,0)
	}
	
	
	/* labels for tables */
	
	la var pol_responsiveness_lbr "Police responsiveness idx (std)"
	la var responsive_act_agree "Police act on citizens' feedback"
	la var responsive_listen_agree "Police include citizens in decision making"
		
	placevar pol_responsiveness_lbr responsive_act responsive_act_agree responsive_listen_agree, after(M2B_RESPONSIVENESS)
	
	

// S1 TRUST IN THE STATE

	gen S1_TRUST_IN_STATE=.
		la var S1_TRUST_IN_STATE "========================="
		placevar S1_TRUST_IN_STATE, f

	/* standardize vars for indices */
		
		egen s_legit_trust=std(legit_trust)	
	
	placevar legit_trust, after(S1_TRUST_IN_STATE)
		

// S2 COMMUNAL TRUST
	
	gen S2_COMMUNAL_TRUST=.
		la var S2_COMMUNAL_TRUST "========================="
		placevar S2_COMMUNAL_TRUST, f

	
	/* standardize vars for indices */
	
	foreach x of varlist trust_community days_comm_work cgroups trust_keys comm_help {
		
		egen s_`x'=std(`x')
	
	}

	/* combine into a single index */
	
	gen comm_cohesion=(s_trust_community + s_days_comm_work + s_cgroups +s_trust_keys + s_comm_help)/5
	
	placevar trust_community comm_cohesion, after(S2_COMMUNAL_TRUST)

	

// COMPLIANCE WITH TREATMENT: CITIZEN INTERACTIONS WITH POLICE
	
	gen COMPLIANCE=.
		la var COMPLIANCE "========================="
		placevar COMPLIANCE, f
	
	/* ameeting_count: see admin data cleaning file */	
	
	/* standardize vars for indices */
	foreach x of varlist compliance_patrol compliance_freq compliance_meeting {
			
		egen s_`x'=std(`x')
			
	}
		
	gen compliance_idx = (s_compliance_patrol + s_compliance_freq + s_compliance_meeting)/3
				
	placevar compliance_idx, after(COMPLIANCE)
	

/*******************************
// LIBERIA SPECIFIC HYPOTHESES 
*******************************/

	gen LIBERIA_SPECIFIC_OUTCOMES=.
		la var LIBERIA_SPECIFIC_OUTCOMES "========================="
		placevar LIBERIA_SPECIFIC_OUTCOMES, f
		
	
	// COMMUNITY CONTRIBUTIONS TO SECURITY 
	
	/* cwteamnightpatrols NA if cwteam=0 */
	/* here we replace with 0, since no night patrols if no team */
	
	replace cwteamnightpatrol=0 if cwteam==0
	
	/* dummy for if patrols done nightly, weekly or monthly. 0 if no team or less than monthly */
	
	gen cwteamnightpatrol_dum=cond(cwteamnightpatrol==1 | cwteamnightpatrol==2 | cwteamnightpatrol==3,1,0)
	
	/* index of community contributions to security */
	
	egen ca_sec_idx = rowtotal (cwteam cwteamnightpatrol)
	
	/* ca_sec_hyp_idx is an endline outcome, but not measured at baseline */
	
	gen ca_sec_hyp_idx = .
	
	/* support for mob violence index*/
		
	gen sup_mobviol_idx = (mobviol1 +  mobviol2 + mobviol3)/3
			
	/* descriptives for support for mob violence */
	
	gen mobviol1_dum=cond(mobviol1==2 | mobviol1==3,1,0) // 1 if "somewhat justified" or "justified"
	gen mobviol2_dum=cond(mobviol2==2 | mobviol2==3,1,0)
	gen mobviol3_dum=cond(mobviol3==2 | mobviol3==3,1,0)
		
	gen sup_mobviol_idx2 = (mobviol1_dum + mobviol2_dum + mobviol3_dum)/3

	/* local security index */
	
	egen s_ca_sec_idx= std(ca_sec_idx)
	egen s_know_cwt_idx = std(know_cwt_idx)
	gen local_security_idx = (ca_sec_idx + know_cwt_idx) / 2	
	
	
// COMMUNITY COHESION

	/* town_organized_sec is an endline outcome, but not measured at baseline */
	
	gen town_organized_sec=.
	
	/* PERCEPTIONS OF TOWN LEADERSHIP */
	
	foreach x of varlist town_chair_pplsame town_chair_corr town_chair_open {
	
		egen s_`x'=std(`x')
	
	}
	
	gen s_town_chair_corr_rec=town_chair_corr*-1
	gen town_ldr_prcptns=(s_town_chair_pplsame + s_town_chair_corr_rec + s_town_chair_open)/3
	
	/* community cohesion index */
	
	gen town_cohesion=(s_trust_community + s_trust_keys + s_days_comm_work +s_cgroups)/4
			
	/* descriptives */
	
	gen pol_abuse_any=cond(policeabuse_verbal_any==1 | policeabuse_phys_any==1,1,0)
	
	
	placevar ca_sec_idx ca_sec_hyp_idx sup_mobviol_idx sup_mobviol_idx2 town_ldr_prcptns town_cohesion pol_abuse_any, after(LIBERIA_SPECIFIC_OUTCOMES)
	
	
	// CONSTRUCT COVARIATES & DESCRIPTIVES
	
		gen COVARIATES=.
			la var COVARIATES "========================="
		placevar COVARIATES, f
		
		/* baseline covariates */
		
		ren male gender
		gen male = cond(gender==1,1,0)
		gen rel_Christian=cond(religion==1,1,0)
		gen edu_none=cond(education==0,1,0)
		gen edu_abc=cond(education==1 | education==2,1,0)
		gen edu_jh=cond(education==3 | education==4,1,0)
		gen edu_hs=cond(education==5 | education==6,1,0)
		gen edu_post=cond(education==7 | education==8,1,0)
		
		gen literate=readnews
		
		gen compliance_patrol_mwd=cond(compliance_patrol<=3,1,0)
			la var compliance_patrol_mwd "Police foot patrol at least monthly"
		gen compliance_freq_mwd=cond(compliance_freq<=3,1,0)
			la var compliance_freq_mwd "Police vehicle patrol at least monthly"
		gen compliance_meeting_6m=compliance_meeting
			la var compliance_meeting_6m "Police community meeting past 6 months"

		
		placevar male age hhsize rel_Christian edu_none edu_abc edu_jh edu_hs edu_post literate compliance_patrol_mwd compliance_freq_mwd compliance_meeting_6m, after(COVARIATES)
		
		/* navigational aids */
		
		gen BASELINE_START=.
		placevar BASELINE_START, f
		gen BASELINE_END=.
		placevar BASELINE_END, l
				
	save "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline.dta",replace
		
		
// COLLAPSE TO COMMUNITY BASELINE LEVEL DATASET, ORDER VARIABLES
	*Study is a comm-level panel, not an individual level panel
	*So baseline lagged DVs are at the comm-level
	

	gl h1a_incidence_of_crime crime_victim_idx crime_victim_idx_exp crime_victim_idx_bin violentcrime_num nonviolentcrime_num cviolentcrime_num cnonviolentcrime_num	violentcrime_num_exp nonviolentcrime_num_exp cviolentcrime_num_exp cnonviolentcrime_num_exp violentcrime_bin nonviolentcrime_bin cviolentcrime_bin cnonviolentcrime_bin
	  gl h1a_incidence_self burglary_num domestic_verbal_num land_any other_any_nonviolent armedrob_num aggassault_num sexual_num domestic_phys_num simpleassault_num other_any_violent
	  gl h1a_incidence_others cburglary_num cland_any cdomestic_verbal_num cother_any_nonviolent carmedrob_num caggassault_num csimpleassault_num csexual_num cdomestic_phys_num cmurder_num  cother_any_violent
	
	gl h1b_security_perceptions future_insecurity_idx s_fear_violent s_fear_nonviolent s_feared_walk s_feared_home
	gl h2_perceptions_police satis_idx s_satis_trust s_satis_general
	gl h3b_police_abuse police_abuse_idx policeabuse_any policeabuse_num policeabuse_report bribe_freq bribe_amt
	gl h4a_crime_reporting crime_reporting_idx crime_report_num violentcrime_report_num ccrime_report_num cviolentcrime_report_num crimeres_idx
	gl h4b_cooperation tips_idx crime_tips_idx s_contact_pol_susp_activity s_give_info_pol_investigation
	gl h4c_police_abuse_report	police_abuse_report_idx dutydrink_report policebeating_report
	gl m1a_police_intentions intentions_idx polint_idx s_polint_corrupt s_polint_quality s_polcaseserious s_polcasefair
	gl m1b_knowledge know_idx know_law_idx know_report_idx s_know_law_suspect_correct s_know_law_lawyer_correct s_know_law_fees_correct s_know_report_station
	gl m1c_norms norm_idx norm_idx_lbr s_reportnorm_theft s_reportnorm_abuse s_obeynorm
	gl m2a_police_capacity police_capacity_idx s_polcap_timely s_polcap_investigate
	gl m2b_responsiveness s_responsive_act
	gl s1_legit s_legit_trust
	gl s2_trust s_trust_community
	gl compliance compliance_idx
	gl h_LIB_MK4_only local_security_idx ca_sec_idx sup_mobviol_idx sup_mobviol_idx2 cmob_any cmob_num know_cwt_idx s_cmob_num	know_pol_idx know_idx_lbr intentions_idx_lbr pol_responsiveness_lbr mobviol1_dum mobviol2_dum mobviol3_dum crime_num_lbr town_ldr_prcptns
		
	
	foreach x of varlist $h1a_incidence_of_crime $h1a_incidence_self $h1a_incidence_others $h1b_security_perceptions $h2_perceptions_police $h3b_police_abuse $h4a_crime_reporting $h4b_cooperation $h4c_police_abuse_report $m1a_police_intentions $m1b_knowledge $m1c_norms $m2a_police_capacity $m2b_responsiveness $s1_legit $s2_trust $compliance $covars $h_LIB_MK4_only {
		des `x'
		
		bys towncode: egen cb_`x'=mean(`x')
		placevar cb_`x',after(`x')
		drop `x'
		}
		
		
	/* collapse to townlevel dataset */
	bys towncode: gen towncount=_n
	keep if towncount==1
	 
	keep towncode cb_*

	save "$LIB_MK4/05_Processed Data/LIB_MK4_processed_data_baseline_commlevel.dta",replace


