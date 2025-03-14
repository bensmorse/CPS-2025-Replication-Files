/***************************************************************************
*			Description: Cleaning file for LIB_MK4 Endline
*			Inputs:  /05_Raw De-Identified Data/LIB_MK4_raw_data_endline.csv
*			Outputs:  None -- file runs within or immediately before LIB_MK4_05_cleaning_code_endline_survey
*			Notes: This file labels variables and makes corrections based on field notes. 
* 			It should be run immediately before LIB_MK4_05_cleaning_code_endline_survey
****************************************************************************/


	insheet using "$LIB_MK4/03_Raw De-Identified Data/LIB_MK4_raw_data_endline.csv", clear

	
	label drop _all
	
	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable enumerator "ENUMERATOR: Please select your name."
	note enumerator: "ENUMERATOR: Please select your name."
	label define enumerator 10 "10-Boye Pewu" 11 "11-Zayzay Kolubah" 12 "12-Aaron Garziah" 13 "13-Marcus Sougbay" 14 "14-Wilfred Gonlor" 15 "15-Morlu Kpalie" 16 "16-Rebecca Sacklo" 17 "17-Miatta Konah" 18 "18-Miatta Talar" 19 "19-Priscilla Fallah" 20 "20-Nyahn Flomoson" 21 "21-Nixon Gayflor" 22 "22-Alphonso Wonmeh" 23 "23-Assata Sanoe" 24 "24-Stephen Dahn" 25 "25-Evelyn Bass" 26 "26-Janet Tarnue" 27 "27-Grace Seidi" 28 "28-Littie Pajibo" 29 "29-Pauline Sonkarlay" 30 "30-Agnes Sarpee" 31 "31-Luther Lakpah" 88 "88-Other"
	label values enumerator enumerator

	label variable enumerator_other "ENUMERATOR: Enter your name."
	note enumerator_other: "ENUMERATOR: Enter your name."

	label variable enumnum "ENUMERATOR: Please enter your enumerator ID."
	note enumnum: "ENUMERATOR: Please enter your enumerator ID."

	label variable community "ENUMERATOR: Select the community"
	note community: "ENUMERATOR: Select the community"
	label define community 1001 "1001-POINT 4 COMMUNITY" 1002 "1002-BONG MINES BRIDGE" 1004 "1004-CONEL WEST" 1005 "1005-POPO BEACH" 1007 "1007-COAST GUARD BASE" 1008 "1008-LAGOON COMMUNITY" 1011 "1011-MIC COMMUNITY" 1014 "1014-GBALASWA COMMUNITY" 1022 "1022-CRAB HOLE COMMUNITY" 2001 "2001-ROCK TOWN / UN DRIVE" 2004 "2004-PHP COMMUNITY" 2005 "2005-MECHLIN STREET" 2010 "2010-CAREY STREET" 2014 "2014-ROCK HILL COMMUNITY" 2016 "2016-MARCOBENE" 2023 "2023-15TH STREET COMMUNITY" 2025 "2025-17TH STREET" 2027 "2027-11TH STREET, SINKOR" 2028 "2028-WORWEIN COMMUNITY" 2032 "2032-JARKPAH TOWN COMMUNITY" 2037 "2037-BASSA COMMUNITY" 2040 "2040-ROCK SPRING COMMUNITY" 3000 "3000-PEACE ISLAND COMMUNITY" 3001 "3001-CATHOLIC COMMUNITY" 3002 "3002-POLOTORIE COMMUNITY" 3005 "3005-TARR TOWN COMMUNITY" 3009 "3009-0902-CABRAL COMMUNITY" 3010 "3010-PAGO'S ISLAND COMMUNITY" 3012 "3012-GAYE TOWN COMMUNITY" 3014 "3014-SKD BOULEVARD" 3016 "3016-KAILANDO COMMUNITY" 3019 "3019-KPELLEH TOWN, BACK ROAD" 3021 "3021-VIA TOWN" 3022 "3022-ROCK VALLEY COMMUNTY" 3024 "3024-KEY HOLE COMMUNITY" 3027 "3027-SMALL TOWN" 3028 "3028-TOKPA CAMP COMMUNITY" 4002 "4002-PLUMKER NEW GEORGIA" 4003 "4003-1407-B-BARDNERSVILLE" 4005 "4005-NYANFORD TOWN" 4013 "4013-L.P.R.C. COMMUNITY" 4014 "4014-CHICKEN SOUP FACTORY" 4019 "4019-SUPER MARKET SNOW HILL COMMUNITY" 4020 "4020-NEW GEORGIA" 4024 "4024-BATTERY FACTORY/PLANK FIELD" 4026 "4026-NEW GEORGIA JUNCTON" 4027 "4027-M.K.K. COMMUNITY" 5000 "5000-JOE BAR COMMUNITY" 5002 "5002-G.S.A ROAD COMMUNITY" 5004 "5004-OUTLAND COMMUNITY, DU-PORT ROAD COMMUNITY" 5005 "5005-MID DU-PORT ROAD COMMUNITY" 5008 "5008-ZUBAH TOWN COMMUNITY" 5010 "5010-POLICE ACADEMY COMMUNITY" 5013 "5013-PARKER PAINT COMMUNITY" 5014 "5014-SOUL CLINIC COMMUNITY" 5015 "5015-VOKER MISSION COMMUNITY" 6000 "6000-VOA #1 COMMUNITY" 6003 "6003-BABY-MA JUNCTION" 6004 "6004-NUKA COMMUNITY-HOLD ROAD" 6008 "6008-FEEDING CENTER COMMUNITY" 6011 "6011-PERRY TOWN" 7002 "7002-CALDWELL NEW GEORGIA WATER SIDE" 7003 "7003-NEW GEORGIA NORTH ROAD COMMUNITY" 7004 "7004-LAJOY COMMUNITY" 7005 "7005-OLD FAITH ISLAND COMMUNITY" 7006 "7006-FAITH ATALANTA COMMUNITY" 7007 "7007-THUMB'S UP COMMUNITY" 7011 "7011-CALDWELL PEACE COMMUNITY" 8004 "8004-V.O.A COMMUNITY" 8005 "8005-ELWA OLD FIELD COMMUNITY" 8006 "8006-REHAB COMMUNITY" 8007 "8007-PALM BUSH COMMUNITY" 8008 "8008-CARVER MISSION" 8010 "8010-KANEMA COMMUNITY" 8013 "8013-THINKER VILLAGE COMMUNITY" 8015 "8015-BAPTIST SEMINARY COMMUNITY" 8017 "8017-R-2 COMMUNITY" 9002 "9002-N.V.T.C. COMMUNITY" 9003 "9003-NEW HOPE COMMUNITY" 9004 "9004-BLACK JINA COMMUNITY" 9006 "9006-CHICKEN FARM COMMUNITY" 9007 "9007-ZOTA COMMUNITY" 9010 "9010-OLD FIELD COMMUNITY" 9012 "9012-72ND COMMUNITY" 9017 "9017-POLICE ACADEMY" 9018 "9018-NEEZOE COMMUNITY" 9020 "9020-COCAO-COLA COMMUNITY" 9021 "9021-MORRIS FARM" 9027 "9027-BALLAH CREEK COMMUNITY" 9028 "9028-NECKLY TOWN" 9029 "9029-PEACE CITY COMMUNITY" 10002 "10002-CLARA TOWN" 10004 "10004-DOE COMMUNITY" 10012 "10012-ABUJA COMMUNITY" 10014 "10014-SUCCESS COMMUNITY" 10016 "10016-COW FACTORY COMMUNITY" 10020 "10020-BASSA TOWN COMMUNITY" 10026 "10026-JAMAICA ROAD COMMUNITY" 10034 "10034-LITTLE WHITE CHAPEL COMMUNITY" 10036 "10036-ZONBO TOWN COMMUNITY"
	label values community community

	label variable towncode "ENUMERATOR: Enter the community code"
	note towncode: "ENUMERATOR: Enter the community code"

	label variable respid "[ENTER RESPONDENT ID] RESPONDENT ID IS: COMMUNITY CODE then ENUMERATOR ID then t"
	note respid: "[ENTER RESPONDENT ID] RESPONDENT ID IS: COMMUNITY CODE then ENUMERATOR ID then the NUMBER OF SURVEYS THAT YOU'VE DONE TODAY. For example: Enumerator 14's 3rd survey in community 2002 is: 2002 14 3 = 2002143"

	label variable consent "I am a survey assistant working with Parley Liberia in collaboration with MIT. P"
	note consent: "I am a survey assistant working with Parley Liberia in collaboration with MIT. Parley is an NGO here in Liberia, and MIT is a university in America. You have been selected by lucky ticket to participate in a survey. The purpose of this study is to understand the security business in your community and understand how best the police and communities can work together to improve security. Please listen to the information I am about to tell you, and ask questions about anything you do not understand, before deciding whether or not to participate. No force in this survey. If you are not satisfied with a question, you can jump over it at anytime. All of your responses will be secret. We will not share your individual information with anybody. You can also stop this interview at anytime if you do not want to continue. I expect it will take about 45 minutes to complete. As part of this interview, I will ask about some potentially sensitive issues like whether you or anyone you know has ever been a victim of crime. These questions could make you upset. If this happens, please keep in mind that we can end the interview at any time. You will not be compensated for this interview, the information you tell us will be confidential and anonymous, and I will not record this interview. Do you have any questions for me? [ANSWER RESPONDENT'S QUESTIONS]. Ok, so you understand everything I tell you and you agree to participate?"
	label define consent 1 "Yes" 0 "No"
	label values consent consent

	label variable male "[SELECT GENDER]"
	note male: "[SELECT GENDER]"
	label define male 0 "Female" 1 "Male"
	label values male male

	label variable age "What is your age today, in years?"
	note age: "What is your age today, in years?"

	label variable hhsize "The place where you sleep at night, how many people eat from your pot and sleep "
	note hhsize: "The place where you sleep at night, how many people eat from your pot and sleep under your roof?"

	label variable education "What is the highest level of education you have completed?"
	note education: "What is the highest level of education you have completed?"
	label define education 0 "None" 1 "Some ABC" 2 "Completed ABC" 3 "Some JH" 4 "Completed JH" 5 "Some HS" 6 "Completed HS" 7 "Some University" 8 "Completed University"
	label values education education

	label variable news "You can read newspaper?"
	note news: "You can read newspaper?"
	label define news 1 "Yes" 0 "No"
	label values news news

	label variable occupation "What is your occupation?"
	note occupation: "What is your occupation?"
	label define occupation 0 "None" 1 "Agriculture (Farming or Fishing)" 2 "Education or teaching" 3 "Petty Cab Driver or peim peim" 4 "Food Vendor, Craftmaker, or Small Shop Owner" 5 "Government (Bureaucratic)" 6 "Services (Beautician, carpenter, cook, welder, etc.)" 7 "Construction" 8 "Health Services" 9 "Domestic services (Housekeeper, Housewife)" 10 "Office job / white collar" 11 "Student" 12 "Hustling" 13 "Petty Business" 14 "Skilled trade" 88 "Other"
	label values occupation occupation

	label variable income_personal "In general, about how much money do YOU personally earn each week?"
	note income_personal: "In general, about how much money do YOU personally earn each week?"

	label variable income_personal_unit "[SELECT CURRENCY]"
	note income_personal_unit: "[SELECT CURRENCY]"
	label define income_personal_unit 1 "LD" 2 "USD"
	label values income_personal_unit income_personal_unit

	label variable income_hh "In general, about how much money do all the other members of your HOUSEHOLD earn"
	note income_hh: "In general, about how much money do all the other members of your HOUSEHOLD earn each week?"

	label variable income_hh_unit "[SELECT CURRENCY]"
	note income_hh_unit: "[SELECT CURRENCY]"
	label define income_hh_unit 1 "LD" 2 "USD"
	label values income_hh_unit income_hh_unit

	label variable employed "What is your employment status?"
	note employed: "What is your employment status?"
	label define employed 1 "Employed (Full Time)" 2 "Employed (Part time)" 3 "Retired" 4 "Choose not to work" 5 "Unemployed"
	label values employed employed

	label variable religion "What is your religion?"
	note religion: "What is your religion?"
	label define religion 1 "Christian" 2 "Muslim" 3 "Traditional" 88 "Other"
	label values religion religion

	label variable tribe "What is your tribe?"
	note tribe: "What is your tribe?"
	label define tribe 1 "Bassa" 2 "Gbandi" 3 "Belle" 4 "Gbei" 5 "Gio" 6 "Gola" 7 "Grebo" 8 "Kissi" 9 "Kpelle" 10 "Krahn" 11 "Kru" 12 "Lorma" 13 "Mandingo" 14 "Mano" 15 "Mende" 16 "Vai" 17 "Congo" 18 "Fula" 88 "Other"
	label values tribe tribe

	label variable dialect "Which dialects you can speak good good? [Select all the apply]"
	note dialect: "Which dialects you can speak good good? [Select all the apply]"

	label variable society "Are you a member of PORO or SANDE?"
	note society: "Are you a member of PORO or SANDE?"
	label define society 1 "Yes" 0 "No"
	label values society society

	label variable numrooms "How many rooms in your house?"
	note numrooms: "How many rooms in your house?"

	label variable assets_roof "[ENUMERATOR: SELECT ROOF MATERIAL]"
	note assets_roof: "[ENUMERATOR: SELECT ROOF MATERIAL]"
	label define assets_roof 1 "Thatch or plant materials" 2 "Wood" 3 "Tarp or other plastic" 4 "Zinc or other metal" 5 "Concrete or cement" 88 "Other"
	label values assets_roof assets_roof

	label variable assets_walls "[ENUMERATOR: SELECT WALL MATERIAL]"
	note assets_walls: "[ENUMERATOR: SELECT WALL MATERIAL]"
	label define assets_walls 1 "Mud and sticks" 2 "Thatch or plant materials" 3 "Wood" 4 "Cardboard or plastic" 5 "Concrete or cement" 88 "Other"
	label values assets_walls assets_walls

	label variable assets_fuel "What is the main fuel you use for cooking?"
	note assets_fuel: "What is the main fuel you use for cooking?"
	label define assets_fuel 1 "Wood" 2 "Coal" 3 "Gas" 88 "Other"
	label values assets_fuel assets_fuel

	label variable assets_water "What is the household's main water source?"
	note assets_water: "What is the household's main water source?"
	label define assets_water 1 "Personal pipe born water" 2 "Community pipe born water" 3 "Well or handpump" 4 "River or stream" 88 "Other"
	label values assets_water assets_water

	label variable reside_unit "For how many years have you lived in this community? [If less than one year, put"
	note reside_unit: "For how many years have you lived in this community? [If less than one year, put '0']"

	label variable own_house "Do you own your house spot?"
	note own_house: "Do you own your house spot?"
	label define own_house 1 "Yes" 0 "No"
	label values own_house own_house

	label variable rel_town_bigman "Are you related to the town chairman, block leader or other bigman in this commu"
	note rel_town_bigman: "Are you related to the town chairman, block leader or other bigman in this community?"
	label define rel_town_bigman 1 "Yes" 0 "No"
	label values rel_town_bigman rel_town_bigman

	label variable rel_govt_bigman "Are you related to any big big person in government?"
	note rel_govt_bigman: "Are you related to any big big person in government?"
	label define rel_govt_bigman 1 "Yes" 0 "No"
	label values rel_govt_bigman rel_govt_bigman

	label variable rel_govt_bigman_other "What is the position of this big big person in government?"
	note rel_govt_bigman_other: "What is the position of this big big person in government?"

	label variable rel_pol_officer "Are you related to any police officer or a close friend of any police officer?"
	note rel_pol_officer: "Are you related to any police officer or a close friend of any police officer?"
	label define rel_pol_officer 1 "Yes" 0 "No"
	label values rel_pol_officer rel_pol_officer

	label variable rel_pol_officer_who "If yes, what kind of police officer? [SELECT ALL THAT APPLY]"
	note rel_pol_officer_who: "If yes, what kind of police officer? [SELECT ALL THAT APPLY]"

	label variable days_comm_work "In the past 30 days, how many days did you spend doing community work, like clea"
	note days_comm_work: "In the past 30 days, how many days did you spend doing community work, like cleaning dirt or brushing the road?"

	label variable cgroups "How many community groups that meet regularly do you participate in?"
	note cgroups: "How many community groups that meet regularly do you participate in?"

	label variable trust_keys "Would you be willing to leave one of your neighbors the keys to your home while "
	note trust_keys: "Would you be willing to leave one of your neighbors the keys to your home while you went away for the afternoon?"
	label define trust_keys 1 "Yes" 0 "No"
	label values trust_keys trust_keys

	label variable trust_community "Most people in my community can be trusted. Agree or disagree?"
	note trust_community: "Most people in my community can be trusted. Agree or disagree?"
	label define trust_community 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values trust_community trust_community

	label variable comm_help "Most members of [COMMUNITY NAME] are willing to help me when I'm in need. Agree "
	note comm_help: "Most members of [COMMUNITY NAME] are willing to help me when I'm in need. Agree or disagree?"
	label define comm_help 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values comm_help comm_help

	label variable town_chair_pplsame "The town chairman in this community treats all people the same. Agree or disagre"
	note town_chair_pplsame: "The town chairman in this community treats all people the same. Agree or disagree?"
	label define town_chair_pplsame 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values town_chair_pplsame town_chair_pplsame

	label variable town_chair_corr "The town chairman in this community is corrupt or eating money. Agree or disagre"
	note town_chair_corr: "The town chairman in this community is corrupt or eating money. Agree or disagree?"
	label define town_chair_corr 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values town_chair_corr town_chair_corr

	label variable town_chair_open "The town chairman in this community makes decisions in a fair and transparent ma"
	note town_chair_open: "The town chairman in this community makes decisions in a fair and transparent manner. Agree or disagree?"
	label define town_chair_open 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values town_chair_open town_chair_open

	label variable polcap_timely "The police have the ability to respond to incidents of crime in a timely manner."
	note polcap_timely: "The police have the ability to respond to incidents of crime in a timely manner. Agree or disagree?"
	label define polcap_timely 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polcap_timely polcap_timely

	label variable polcap_investigate "The police have the ability to investigate crimes and gather evidence effectivel"
	note polcap_investigate: "The police have the ability to investigate crimes and gather evidence effectively and professionally. Agree or disagree?"
	label define polcap_investigate 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polcap_investigate polcap_investigate

	label variable pol_care "The police care about the safety and well-being of people in my community. Agree"
	note pol_care: "The police care about the safety and well-being of people in my community. Agree or disagree?"
	label define pol_care 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values pol_care pol_care

	label variable pol_empathy "The police feel sorry for people in my community when they are victimized by cri"
	note pol_empathy: "The police feel sorry for people in my community when they are victimized by crime. Agree or disagree?"
	label define pol_empathy 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values pol_empathy pol_empathy

	label variable polint_corrupt "The police are corrupt or eating money. Agree or disagree?"
	note polint_corrupt: "The police are corrupt or eating money. Agree or disagree?"
	label define polint_corrupt 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polint_corrupt polint_corrupt

	label variable polint_digresp "Police treat citizens with dignity and respect. Agree or disagree?"
	note polint_digresp: "Police treat citizens with dignity and respect. Agree or disagree?"
	label define polint_digresp 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polint_digresp polint_digresp

	label variable polint_decfact "Police make their decisions based upon facts, not their personal biases or opini"
	note polint_decfact: "Police make their decisions based upon facts, not their personal biases or opinions. Agree or disagree?"
	label define polint_decfact 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polint_decfact polint_decfact

	label variable polint_quality "The police treat all citizens equally. Agree or disagree?"
	note polint_quality: "The police treat all citizens equally. Agree or disagree?"
	label define polint_quality 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polint_quality polint_quality

	label variable responsive_act "The police act upon citizen comments and complaints about security in my communi"
	note responsive_act: "The police act upon citizen comments and complaints about security in my community. Agree or disagree?"
	label define responsive_act 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values responsive_act responsive_act

	label variable responsive_listen "The police give people in my community a chance to express their views before ma"
	note responsive_listen: "The police give people in my community a chance to express their views before making decisions. Agree or disagree?"
	label define responsive_listen 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values responsive_listen responsive_listen

	label variable satis_trust "In general, I trust the police. Agree or disagree?"
	note satis_trust: "In general, I trust the police. Agree or disagree?"
	label define satis_trust 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values satis_trust satis_trust

	label variable satis_general "I am satisfied with the service that police provide. Agree or disagree?"
	note satis_general: "I am satisfied with the service that police provide. Agree or disagree?"
	label define satis_general 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values satis_general satis_general

	label variable polcaseserious "The police will take the case seriously and investigate. Agree or disagree?"
	note polcaseserious: "The police will take the case seriously and investigate. Agree or disagree?"
	label define polcaseserious 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polcaseserious polcaseserious

	label variable polcaserespect "The police will treat the victim with dignity and respect. Agree or disagree?"
	note polcaserespect: "The police will treat the victim with dignity and respect. Agree or disagree?"
	label define polcaserespect 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polcaserespect polcaserespect

	label variable polcasefair "The police will be fair to all sides in the investigation. Agree or disagree?"
	note polcasefair: "The police will be fair to all sides in the investigation. Agree or disagree?"
	label define polcasefair 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values polcasefair polcasefair

	label variable suspect_fairtreat "SUSPECTS are treated fairly and under the law when they deal with the police. Ag"
	note suspect_fairtreat: "SUSPECTS are treated fairly and under the law when they deal with the police. Agree or disagree?"
	label define suspect_fairtreat 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values suspect_fairtreat suspect_fairtreat

	label variable suspect_avoidprosec "SUSPECTS can avoid prosecution by paying the police or making them a favour. Agr"
	note suspect_avoidprosec: "SUSPECTS can avoid prosecution by paying the police or making them a favour. Agree or disagree?"
	label define suspect_avoidprosec 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values suspect_avoidprosec suspect_avoidprosec

	label variable mobviol1 "Let's say somebody bust into a lady's house and tries to rape her in the night. "
	note mobviol1: "Let's say somebody bust into a lady's house and tries to rape her in the night. As he is running away, the community people catch the man and say they want to flog him rather than carry him to the police because they know the police do not have enough manpower to investigate and prepare the case for court. Would you say the actions of the community people are justified, somewhat justified, or not at all justified?"
	label define mobviol1 0 "Justified" 1 "Somewhat justified" 2 "Not at all justified" 97 "Do not know" 98 "Refuse to answer"
	label values mobviol1 mobviol1

	label variable mobviol2 "Let's say somebody bust into a man's house with a gun, terrorizes his family, an"
	note mobviol2: "Let's say somebody bust into a man's house with a gun, terrorizes his family, and runs away with a his TV and generator. As he is running away, the community people catch the man and want to flog him rather than carry him to the police because they know the police will just release him. Would you say the actions of the community people are justified, somewhat justified, or not at all justified?"
	label define mobviol2 0 "Justified" 1 "Somewhat justified" 2 "Not at all justified" 97 "Do not know" 98 "Refuse to answer"
	label values mobviol2 mobviol2

	label variable mobviol3 "Let's say somebody busts into another man's home and steals a bag of rice. As he"
	note mobviol3: "Let's say somebody busts into another man's home and steals a bag of rice. As he runs away, the community people catch the man and want to flog him rather than carry him to the police because they know the police will not take the case seriously. Would you say the actions of the community people are justified, somewhat justified, or not at all justified?"
	label define mobviol3 0 "Justified" 1 "Somewhat justified" 2 "Not at all justified" 97 "Do not know" 98 "Refuse to answer"
	label values mobviol3 mobviol3

	label variable cmob_any "In the past year, were there any incidents of MOB JUSTICE in your community (i.e"
	note cmob_any: "In the past year, were there any incidents of MOB JUSTICE in your community (i.e. beating of flogging of someone suspected of committing a crime)?"
	label define cmob_any 1 "Yes" 0 "No"
	label values cmob_any cmob_any

	label variable cmob_num "[IF YES:] How many times did this happen in the past year (12 months)?"
	note cmob_num: "[IF YES:] How many times did this happen in the past year (12 months)?"

	label variable criot_any "Besides any incidents of mob justice, in the past year, were there any RIOTS in "
	note criot_any: "Besides any incidents of mob justice, in the past year, were there any RIOTS in your community? [INCLUDING VIOLENT STRIKES OR PROTESTS]"
	label define criot_any 1 "Yes" 0 "No"
	label values criot_any criot_any

	label variable criot_num "[IF YES:] How many times did this happen in the past year (12 months)?"
	note criot_num: "[IF YES:] How many times did this happen in the past year (12 months)?"

	label variable name_witness "Suppose there was a robbery in your community. You didn't see the crime occur, b"
	note name_witness: "Suppose there was a robbery in your community. You didn't see the crime occur, but you know someone in your community who did. How likely would you be to give that person's name to the police?"
	label define name_witness 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values name_witness name_witness

	label variable identify_hideout "Suppose there is a suspect accused of car jacking hiding in your community and t"
	note identify_hideout: "Suppose there is a suspect accused of car jacking hiding in your community and the police are looking for him. Let's say you happen to know where that person is hiding. How likely would you be to give that information to the police?"
	label define identify_hideout 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values identify_hideout identify_hideout

	label variable identify_ghetto "Suppose there is an area of your community where people take drugs and plan pett"
	note identify_ghetto: "Suppose there is an area of your community where people take drugs and plan petty crimes. How likely would you be to report that information to the police?"
	label define identify_ghetto 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values identify_ghetto identify_ghetto

	label variable guide_police "Suppose a police officer wants to familiarize himself with your community. How w"
	note guide_police: "Suppose a police officer wants to familiarize himself with your community. How willing would you be to spend a day showing him around your community?"
	label define guide_police 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values guide_police guide_police

	label variable give_testimony "Suppose you witness a crime in your community and the police ask you to give wri"
	note give_testimony: "Suppose you witness a crime in your community and the police ask you to give written testimony at the police station. How likely would you be to go to the station to give written testimony?"
	label define give_testimony 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values give_testimony give_testimony

	label variable landres "If there's a dispute over LAND OR PROPERTY in your community, where do you think"
	note landres: "If there's a dispute over LAND OR PROPERTY in your community, where do you think the case should be reported, if anywhere?"
	label define landres 0 "Nowhere" 1 "Police" 2 "Court" 3 "Town chairman/Community leader" 4 "Elders" 5 "Community watch group" 6 "Settled directly with the perpetrator" 88 "Other" 97 "Do not know" 98 "Refuse to Answer"
	label values landres landres

	label variable landresviol "If there's a PROPERTY DISPUTE in your community and somebody threatens to set fi"
	note landresviol: "If there's a PROPERTY DISPUTE in your community and somebody threatens to set fire to another man's house. Where do you think the case should be reported, if anywhere?"
	label define landresviol 0 "Nowhere" 1 "Police" 2 "Court" 3 "Town chairman/Community leader" 4 "Elders" 5 "Community watch group" 6 "Settled directly with the perpetrator" 88 "Other" 97 "Do not know" 98 "Refuse to Answer"
	label values landresviol landresviol

	label variable burglaryres "If there's a BURGLARY in your community, where do you think the case should be r"
	note burglaryres: "If there's a BURGLARY in your community, where do you think the case should be reported, if anywhere?"
	label define burglaryres 0 "Nowhere" 1 "Police" 2 "Court" 3 "Town chairman/Community leader" 4 "Elders" 5 "Community watch group" 6 "Settled directly with the perpetrator" 88 "Other" 97 "Do not know" 98 "Refuse to Answer"
	label values burglaryres burglaryres

	label variable dviolres "If a MAN BEAT HIS WOMAN in your community, where do you think the case should be"
	note dviolres: "If a MAN BEAT HIS WOMAN in your community, where do you think the case should be reported, if anywhere?"
	label define dviolres 0 "Nowhere" 1 "Police" 2 "Court" 3 "Town chairman/Community leader" 4 "Elders" 5 "Community watch group" 6 "Settled directly with the perpetrator" 88 "Other" 97 "Do not know" 98 "Refuse to Answer"
	label values dviolres dviolres

	label variable armedrobres "If there's an ARMED ROBBERY in your community, where do you think the case shoul"
	note armedrobres: "If there's an ARMED ROBBERY in your community, where do you think the case should be reported, if anywhere?"
	label define armedrobres 0 "Nowhere" 1 "Police" 2 "Court" 3 "Town chairman/Community leader" 4 "Elders" 5 "Community watch group" 6 "Settled directly with the perpetrator" 88 "Other" 97 "Do not know" 98 "Refuse to Answer"
	label values armedrobres armedrobres

	label variable know_law_suspect "If you see a dead body lying in the street and you report it to the police, Libe"
	note know_law_suspect: "If you see a dead body lying in the street and you report it to the police, Liberian law says the police must hold you as a suspect. True or false?"
	label define know_law_suspect 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_law_suspect know_law_suspect

	label variable know_law_statrape "If a man does man-woman business with a woman under age 18, Liberian law says th"
	note know_law_statrape: "If a man does man-woman business with a woman under age 18, Liberian law says that is rape, even if the woman consents. True or false?"
	label define know_law_statrape 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_law_statrape know_law_statrape

	label variable know_law_childsup "According to Liberian law, a man does not have to provide for his children if he"
	note know_law_childsup: "According to Liberian law, a man does not have to provide for his children if he never married the mother and they are seperated. True or false?"
	label define know_law_childsup 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_law_childsup know_law_childsup

	label variable know_law_habeasc "If the police put someone in jail and no one comes to carry a case against that "
	note know_law_habeasc: "If the police put someone in jail and no one comes to carry a case against that person, Liberian law says the police have to let him go free. True or false?"
	label define know_law_habeasc 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_law_habeasc know_law_habeasc

	label variable know_law_lawyer "If you take your case to court and you don't have money to pay a lawyer, Liberia"
	note know_law_lawyer: "If you take your case to court and you don't have money to pay a lawyer, Liberian law says the government must provide a lawyer for you. True or false?"
	label define know_law_lawyer 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_law_lawyer know_law_lawyer

	label variable know_law_fees "If you take a case to the police, Liberian law says the police can charge a fee "
	note know_law_fees: "If you take a case to the police, Liberian law says the police can charge a fee to register the case. True or false?"
	label define know_law_fees 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_law_fees know_law_fees

	label variable know_law_bondfee "If you take a case to court, Liberian law says the Judge can charge you a fee be"
	note know_law_bondfee: "If you take a case to court, Liberian law says the Judge can charge you a fee before he can hear the case. True or False?"
	label define know_law_bondfee 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_law_bondfee know_law_bondfee

	label variable know_law_complain "If you report a serious crime to the police like murder or rape and the police f"
	note know_law_complain: "If you report a serious crime to the police like murder or rape and the police fail to take it seriously or investigate, Liberian law says you have the right to file a complaint against the police. True or False?"
	label define know_law_complain 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_law_complain know_law_complain

	label variable know_report_misconduct "Let's say a police officer beats on someone without justification. Where you can"
	note know_report_misconduct: "Let's say a police officer beats on someone without justification. Where you can report that one? [SELECT ALL THAT APPLY]"
	label define know_report_misconduct 0 "No" 1 "Community leaders" 2 "Police station or police commander" 3 "Any other government agency" 4 "NGO" 5 "Journalist" 6 "LNP Professional Standards Division" 97 "Do not know" 98 "Refuse to answer"
	label values know_report_misconduct know_report_misconduct

	label variable know_cwt_arrest "Members of the Community Watch Team may arrest someone provided they carry them "
	note know_cwt_arrest: "Members of the Community Watch Team may arrest someone provided they carry them to the police and do not physically harm them. True or false?"
	label define know_cwt_arrest 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_cwt_arrest know_cwt_arrest

	label variable know_cwt_risk "If members of the watch team encounter a gang of violent criminals, they are req"
	note know_cwt_risk: "If members of the watch team encounter a gang of violent criminals, they are required to engage the criminals even if it puts them at risk. True or false?"
	label define know_cwt_risk 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_cwt_risk know_cwt_risk

	label variable know_cwt_checkpoint "Members of the Community Watch Team may put up checkpoints if they think it is n"
	note know_cwt_checkpoint: "Members of the Community Watch Team may put up checkpoints if they think it is necessary for security. True or False?"
	label define know_cwt_checkpoint 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_cwt_checkpoint know_cwt_checkpoint

	label variable know_cwt_jurisdiction "Members of the Community Watch Team may patrol in communities other than their o"
	note know_cwt_jurisdiction: "Members of the Community Watch Team may patrol in communities other than their own if they think it is necessary. True or false?"
	label define know_cwt_jurisdiction 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_cwt_jurisdiction know_cwt_jurisdiction

	label variable know_cwt_violent "If a VIOLENT crime is reported to the community watch team, they are required by"
	note know_cwt_violent: "If a VIOLENT crime is reported to the community watch team, they are required by law to report it to the police. True or False?"
	label define know_cwt_violent 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_cwt_violent know_cwt_violent

	label variable know_cwt_beat "If a criminal is resisting arrest, the Community Watch Team has the right to bea"
	note know_cwt_beat: "If a criminal is resisting arrest, the Community Watch Team has the right to beat him until he can no longer resist. True or False?"
	label define know_cwt_beat 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_cwt_beat know_cwt_beat

	label variable know_cwt_cutlass "Members of the community watch team have the right to carry cutlasses for protec"
	note know_cwt_cutlass: "Members of the community watch team have the right to carry cutlasses for protection at night. True or false?"
	label define know_cwt_cutlass 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_cwt_cutlass know_cwt_cutlass

	label variable know_wacps "The police have special officers responsible for dealing with issues of sexual a"
	note know_wacps: "The police have special officers responsible for dealing with issues of sexual assault and child abuse. True or False?"
	label define know_wacps 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_wacps know_wacps

	label variable know_wacps_name "[IF YES:] What is the name of the unit to which these officers are assigned? [AN"
	note know_wacps_name: "[IF YES:] What is the name of the unit to which these officers are assigned? [ANSWER: Women and Child Protection Services (WACPS). ENUMERATOR: IS THE RESPONDENT CORRECT?]"
	label define know_wacps_name 1 "Yes" 0 "No"
	label values know_wacps_name know_wacps_name

	label variable know_psd "The police have a special unit responsible for handling citizen complaints about"
	note know_psd: "The police have a special unit responsible for handling citizen complaints about police misconduct or abuse. True or false?"
	label define know_psd 0 "FALSE" 1 "TRUE" 97 "Do not know" 98 "Refuse to answer"
	label values know_psd know_psd

	label variable know_psd_name "What is the name of this unit? [ANSWER: Professional Standards Division. ENUMERA"
	note know_psd_name: "What is the name of this unit? [ANSWER: Professional Standards Division. ENUMERATOR: IS THE RESPONDENT CORRECT?]"
	label define know_psd_name 1 "Yes" 0 "No"
	label values know_psd_name know_psd_name

	label variable know_csd_name "The police have a special unit responsible for investigating crimes and gatherin"
	note know_csd_name: "The police have a special unit responsible for investigating crimes and gathering evidence. What is the name of this unit? [ANSWER: Crime services division. ENUMERATOR: IS THE RESPONDENT CORRECT?]"
	label define know_csd_name 1 "Yes" 0 "No"
	label values know_csd_name know_csd_name

	label variable know_polstation "Do you know where the nearest police station is? [ENUMERATOR: IS RESPONDENT CORR"
	note know_polstation: "Do you know where the nearest police station is? [ENUMERATOR: IS RESPONDENT CORRECT?]"
	label define know_polstation 1 "Yes" 0 "No"
	label values know_polstation know_polstation

	label variable know_localcommander "Do you know the name of any Zone or Depot Commander at a nearby police station? "
	note know_localcommander: "Do you know the name of any Zone or Depot Commander at a nearby police station? [ENUMERATOR: IS RESPONDENT CORRECT?]"
	label define know_localcommander 1 "Yes" 0 "No"
	label values know_localcommander know_localcommander

	label variable know_anyofficer "Do you know the name of any police officer at the police station that is nearest"
	note know_anyofficer: "Do you know the name of any police officer at the police station that is nearest to you?"
	label define know_anyofficer 1 "Yes" 0 "No"
	label values know_anyofficer know_anyofficer

	label variable know_policenumber "Do you know the PHONE NUMBER of any police officer at the police station that is"
	note know_policenumber: "Do you know the PHONE NUMBER of any police officer at the police station that is nearest to you?"
	label define know_policenumber 1 "Yes" 0 "No"
	label values know_policenumber know_policenumber

	label variable contact_pol_susp_activity "In the past 6 months, have you ever contacted the police to alert them to suspic"
	note contact_pol_susp_activity: "In the past 6 months, have you ever contacted the police to alert them to suspicious or criminal activity in your community?"
	label define contact_pol_susp_activity 1 "Yes" 0 "No"
	label values contact_pol_susp_activity contact_pol_susp_activity

	label variable contact_pol_find_suspect "In the past 6 months, have you ever contacted the police to help them find a sus"
	note contact_pol_find_suspect: "In the past 6 months, have you ever contacted the police to help them find a suspected criminal in your community?"
	label define contact_pol_find_suspect 1 "Yes" 0 "No"
	label values contact_pol_find_suspect contact_pol_find_suspect

	label variable give_info_pol_investigation "In the past 6 months, have you ever given information to the police to assist wi"
	note give_info_pol_investigation: "In the past 6 months, have you ever given information to the police to assist with an investigation?"
	label define give_info_pol_investigation 1 "Yes" 0 "No"
	label values give_info_pol_investigation give_info_pol_investigation

	label variable testify_police_investigation "In the past 6 months, have you ever served as a witness or provided testimony as"
	note testify_police_investigation: "In the past 6 months, have you ever served as a witness or provided testimony as part of a police investigation?"
	label define testify_police_investigation 1 "Yes" 0 "No"
	label values testify_police_investigation testify_police_investigation

	label variable fear_violent "How worried are you that you or a member of your household will be the victim of"
	note fear_violent: "How worried are you that you or a member of your household will be the victim of a VIOLENT CRIME in the coming year? [INCLUDING ARMED ROBBERY, ASSAULT WITH A WEAPON, ASSAULT WITHOUT A WEAPON, ETC.]"
	label define fear_violent 0 "Not at all worried" 1 "Somewhat worried" 2 "Worried" 3 "Very worried"
	label values fear_violent fear_violent

	label variable fear_nonviolent "How worried are you that you or a member of your household will be the victim of"
	note fear_nonviolent: "How worried are you that you or a member of your household will be the victim of a NON-VIOLENT CRIME in the coming year? [INCLUDING BURGLARY, THEFT, ETC.]"
	label define fear_nonviolent 0 "Not at all worried" 1 "Somewhat worried" 2 "Worried" 3 "Very worried"
	label values fear_nonviolent fear_nonviolent

	label variable feared_walk "In the past 6 months, how often, if ever, have you or anyone in your family felt"
	note feared_walk: "In the past 6 months, how often, if ever, have you or anyone in your family felt unsafe walking in your neighbourhood?"
	label define feared_walk 0 "Never" 1 "Just once or twice" 2 "Several times" 3 "Many times" 4 "Always"
	label values feared_walk feared_walk

	label variable feared_home "In the past 6 months, how often, if ever, have you or anyone in your family fear"
	note feared_home: "In the past 6 months, how often, if ever, have you or anyone in your family feared crime in your own home?"
	label define feared_home 0 "Never" 1 "Just once or twice" 2 "Several times" 3 "Many times" 4 "Always"
	label values feared_home feared_home

	label variable hssecure "How sure are you that the boundaries of your house spots are secure? That is, no"
	note hssecure: "How sure are you that the boundaries of your house spots are secure? That is, no one can leave from his side to come and sit down on your side?"
	label define hssecure 0 "Not sure at all" 1 "Not sure" 2 "Sure" 3 "Very sure"
	label values hssecure hssecure

	label variable hsitemssecure "How sure are you that the valuable items in and around your house are secure? (e"
	note hsitemssecure: "How sure are you that the valuable items in and around your house are secure? (e.g. generators, phones, computers, TVs, furniture)"
	label define hsitemssecure 0 "Not sure at all" 1 "Not sure" 2 "Sure" 3 "Very sure"
	label values hsitemssecure hsitemssecure

	label variable hsimprove2017 "In the past year, did you make any improvements to your house spots, like dop th"
	note hsimprove2017: "In the past year, did you make any improvements to your house spots, like dop the walls, zinc the roof, or put in new buildings?"
	label define hsimprove2017 1 "Yes" 0 "No"
	label values hsimprove2017 hsimprove2017

	label variable motosecure "Lets say you had a motorcycle and kept it outside your house at night. How sure "
	note motosecure: "Lets say you had a motorcycle and kept it outside your house at night. How sure are you that it would be secure?"
	label define motosecure 0 "Not sure at all" 1 "Not sure" 2 "Sure" 3 "Very sure"
	label values motosecure motosecure

	label variable generatorsecure "Let's say you had a generator and left it outside your house at night. How sure "
	note generatorsecure: "Let's say you had a generator and left it outside your house at night. How sure are you that it would be secure?"
	label define generatorsecure 0 "Not sure at all" 1 "Not sure" 2 "Sure" 3 "Very sure"
	label values generatorsecure generatorsecure

	label variable reportnorm_theft "If there is a BURGLARY in your community, people can get angry if you take it to"
	note reportnorm_theft: "If there is a BURGLARY in your community, people can get angry if you take it to the police. Agree or disagree?"
	label define reportnorm_theft 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values reportnorm_theft reportnorm_theft

	label variable reportnorm_abuse "If a MAN BEATS HIS WIFE in your community, people can get angry if you take it t"
	note reportnorm_abuse: "If a MAN BEATS HIS WIFE in your community, people can get angry if you take it to the police. Agree or disagree?"
	label define reportnorm_abuse 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values reportnorm_abuse reportnorm_abuse

	label variable reportnorm_land "If there is a LAND DISPUTE in your community, people can get angry if you take i"
	note reportnorm_land: "If there is a LAND DISPUTE in your community, people can get angry if you take it to the police. Agree or disagree?"
	label define reportnorm_land 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values reportnorm_land reportnorm_land

	label variable obeynorm "You should do what the police tell you to do even when you do not understand the"
	note obeynorm: "You should do what the police tell you to do even when you do not understand the reason for what they are telling you. Agree or disagree?"
	label define obeynorm 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values obeynorm obeynorm

	label variable helppolnorm_armedrob "If a member of the community provides the police with information that helped ca"
	note helppolnorm_armedrob: "If a member of the community provides the police with information that helped catch the perpetrator of the [ARMED ROBBERY], other people in this community can get angry with him. Agree or disagree?"
	label define helppolnorm_armedrob 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values helppolnorm_armedrob helppolnorm_armedrob

	label variable helppolnorm_domviol "If a member of the community provides the police with information that helped ca"
	note helppolnorm_domviol: "If a member of the community provides the police with information that helped catch the perpetrator of the [DOMESTIC VIOLENCE], other people in this community can get angry with him. Agree or disagree?"
	label define helppolnorm_domviol 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values helppolnorm_domviol helppolnorm_domviol

	label variable helppolnorm_moto "If a member of the community provides the police with information that helped ca"
	note helppolnorm_moto: "If a member of the community provides the police with information that helped catch the perpetrator of the [MOTORBIKE THEFT], other people in this community can get angry with him. Agree or disagree?"
	label define helppolnorm_moto 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values helppolnorm_moto helppolnorm_moto

	label variable helppolnorm_childabuse "If a member of the community provides the police with information that helped ca"
	note helppolnorm_childabuse: "If a member of the community provides the police with information that helped catch the perpetrator of [CHILDABUSE], other people in this community can get angry with him. Agree or disagree?"
	label define helppolnorm_childabuse 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values helppolnorm_childabuse helppolnorm_childabuse

	label variable sec_mtg_1m "In the past month, have you seen or heard of members of your commnunity organizi"
	note sec_mtg_1m: "In the past month, have you seen or heard of members of your commnunity organizing a security meeting?"
	label define sec_mtg_1m 1 "Yes" 0 "No"
	label values sec_mtg_1m sec_mtg_1m

	label variable sec_mtg_attend_1m "In the past month, have you attended any security meetings organized by members "
	note sec_mtg_attend_1m: "In the past month, have you attended any security meetings organized by members of your community?"
	label define sec_mtg_attend_1m 1 "Yes" 0 "No"
	label values sec_mtg_attend_1m sec_mtg_attend_1m

	label variable sec_patrol_1m "In the past month, have you seen or heard of members of your community conductin"
	note sec_patrol_1m: "In the past month, have you seen or heard of members of your community conducting security patrols at night?"
	label define sec_patrol_1m 1 "Yes" 0 "No"
	label values sec_patrol_1m sec_patrol_1m

	label variable sec_patrol_attend_1m "In the past month, have you or a member of your family participated in a securit"
	note sec_patrol_attend_1m: "In the past month, have you or a member of your family participated in a security patrol organized by members of your community?"
	label define sec_patrol_attend_1m 1 "Yes" 0 "No"
	label values sec_patrol_attend_1m sec_patrol_attend_1m

	label variable sec_patrol_contr_1m "In the past month, have you or a member of your family donated money, tea, bread"
	note sec_patrol_contr_1m: "In the past month, have you or a member of your family donated money, tea, bread, or any other thing to help members of your community conduct security patrols?"
	label define sec_patrol_contr_1m 1 "Yes" 0 "No"
	label values sec_patrol_contr_1m sec_patrol_contr_1m

	label variable cwteam "Does your community currently have an community watch team or community watch fo"
	note cwteam: "Does your community currently have an community watch team or community watch forum?"
	label define cwteam 1 "Yes" 0 "No"
	label values cwteam cwteam

	label variable cwteamnightpatrol "[IF YES]: Does the watch team/forum conduct nighttime patrols on a regular basis"
	note cwteamnightpatrol: "[IF YES]: Does the watch team/forum conduct nighttime patrols on a regular basis?"
	label define cwteamnightpatrol 0 "No" 1 "Yes, nightly" 2 "Yes, weekly" 3 "Yes, monthly" 4 "Yes, less than monthly"
	label values cwteamnightpatrol cwteamnightpatrol

	label variable cwteammtgs "[IF YES]: Does the watch team/forum organize community meetings on a regular bas"
	note cwteammtgs: "[IF YES]: Does the watch team/forum organize community meetings on a regular basis?"
	label define cwteammtgs 0 "No" 1 "Yes, nightly" 2 "Yes, weekly" 3 "Yes, monthly" 4 "Yes, less than monthly"
	label values cwteammtgs cwteammtgs

	label variable cwteamregistered "[IF YES]: As far as you know, is this watch team/forum registered with the polic"
	note cwteamregistered: "[IF YES]: As far as you know, is this watch team/forum registered with the police?"
	label define cwteamregistered 1 "Yes" 0 "No"
	label values cwteamregistered cwteamregistered

	label variable cwteammembers "[IF YES]: As far as you know, about how many active members does the community w"
	note cwteammembers: "[IF YES]: As far as you know, about how many active members does the community watch team/forum have?"

	label variable sec_mtg_attend_hyp "Suppose a leader in your community asked you to attend a 2 hour long meeting to "
	note sec_mtg_attend_hyp: "Suppose a leader in your community asked you to attend a 2 hour long meeting to discuss security issues in your community on a Saturday when you were already very busy. How likely would you be to attend?"
	label define sec_mtg_attend_hyp 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values sec_mtg_attend_hyp sec_mtg_attend_hyp

	label variable sec_group_money_hyp "Suppose a leader in your community asked you to donate 200 LD to the community w"
	note sec_group_money_hyp: "Suppose a leader in your community asked you to donate 200 LD to the community watch team/forum. How likely would you be to agree to donate the money?"
	label define sec_group_money_hyp 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values sec_group_money_hyp sec_group_money_hyp

	label variable sec_group_food_hyp "Suppose a leader in your community asked you to donate tea, bread, and rice to t"
	note sec_group_food_hyp: "Suppose a leader in your community asked you to donate tea, bread, and rice to the community watch team/forum. How likely would you be to agree to donate the bread and tea?"
	label define sec_group_food_hyp 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values sec_group_food_hyp sec_group_food_hyp

	label variable sec_group_torch_hyp "Suppose a leader in your community asked you to give your torchlight to the comm"
	note sec_group_torch_hyp: "Suppose a leader in your community asked you to give your torchlight to the community watch team/forum. How likely would you be to do agree to donate the torchlight?"
	label define sec_group_torch_hyp 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values sec_group_torch_hyp sec_group_torch_hyp

	label variable sec_group_attend_hyp "Suppose a leader in your community asked you to serve on the watch team/forum an"
	note sec_group_attend_hyp: "Suppose a leader in your community asked you to serve on the watch team/forum and spend several nights a week on patrol. How likely would you be to agree to do it?"
	label define sec_group_attend_hyp 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values sec_group_attend_hyp sec_group_attend_hyp

	label variable ca_town_organized "My community is united and well-organized in the fight against crime. Agree or d"
	note ca_town_organized: "My community is united and well-organized in the fight against crime. Agree or disagree?"
	label define ca_town_organized 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values ca_town_organized ca_town_organized

	label variable ca_town_worktogether "Members of my community do a good job of working together to help the police do "
	note ca_town_worktogether: "Members of my community do a good job of working together to help the police do their work in my community. Agree or disagree?"
	label define ca_town_worktogether 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values ca_town_worktogether ca_town_worktogether

	label variable ca_town_ldrsorganize "Leaders in my community do a good job of organizing my community to combat crime"
	note ca_town_ldrsorganize: "Leaders in my community do a good job of organizing my community to combat crime. Agree or disagree?"
	label define ca_town_ldrsorganize 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values ca_town_ldrsorganize ca_town_ldrsorganize

	label variable ca_town_ldrshelppol "Leaders in my community work have a close working relationship with the police. "
	note ca_town_ldrshelppol: "Leaders in my community work have a close working relationship with the police. Agree or disagree?"
	label define ca_town_ldrshelppol 0 "Strongly disagree" 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree" 4 "Strongly agree" 97 "Do not know" 98 "Refuse to answer"
	label values ca_town_ldrshelppol ca_town_ldrshelppol

	label variable vig_pol_professional "In your opinion, how likely do you think it is that the police will be professio"
	note vig_pol_professional: "In your opinion, how likely do you think it is that the police will be professional in handling this case?"
	label define vig_pol_professional 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_professional vig_pol_professional

	label variable vig_pol_respect "In your opinion, how likely do you think it is that the police will treat \${vig"
	note vig_pol_respect: "In your opinion, how likely do you think it is that the police will treat \${vig_name} with respect?"
	label define vig_pol_respect 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_respect vig_pol_respect

	label variable vig_pol_satisfied "In your opinion, how likely do you think it is that \${vig_name} will be satisfi"
	note vig_pol_satisfied: "In your opinion, how likely do you think it is that \${vig_name} will be satisfied with how the police handle \${vig_pronoun} case?"
	label define vig_pol_satisfied 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_satisfied vig_pol_satisfied

	label variable vig_pol_thorough "In your opinion, how likely do you think it is that the police will aggresively "
	note vig_pol_thorough: "In your opinion, how likely do you think it is that the police will aggresively investigate this case?"
	label define vig_pol_thorough 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_thorough vig_pol_thorough

	label variable vig_pol_invest "In your opinion, how likely do you think it is that the police will visit the sc"
	note vig_pol_invest: "In your opinion, how likely do you think it is that the police will visit the scene of the crime?"
	label define vig_pol_invest 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_invest vig_pol_invest

	label variable vig_pol_interview "In your opinion, how likely do you think it is that the police will try to gathe"
	note vig_pol_interview: "In your opinion, how likely do you think it is that the police will try to gather evidence from neighbors or witnesses?"
	label define vig_pol_interview 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_interview vig_pol_interview

	label variable vig_pol_paysmall "In your opinion, how likely do you think it is that the police will make the vic"
	note vig_pol_paysmall: "In your opinion, how likely do you think it is that the police will make the victim pay a case registration fee or ask for a bribe?"
	label define vig_pol_paysmall 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_paysmall vig_pol_paysmall

	label variable vig_pol_professional2 "In your opinion, how likely do you think it is that the police will be professio"
	note vig_pol_professional2: "In your opinion, how likely do you think it is that the police will be professional in handling this case?"
	label define vig_pol_professional2 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_professional2 vig_pol_professional2

	label variable vig_pol_respect2 "In your opinion, how likely do you think it is that the police will treat \${vig"
	note vig_pol_respect2: "In your opinion, how likely do you think it is that the police will treat \${vig_name2} with respect?"
	label define vig_pol_respect2 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_respect2 vig_pol_respect2

	label variable vig_pol_satisfied2 "In your opinion, how likely do you think it is that \${vig_name2} will be satisf"
	note vig_pol_satisfied2: "In your opinion, how likely do you think it is that \${vig_name2} will be satisfied with how the police handle \${vig_pronoun2} case?"
	label define vig_pol_satisfied2 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_satisfied2 vig_pol_satisfied2

	label variable vig_pol_thorough2 "In your opinion, how likely do you think it is that the police will aggresively "
	note vig_pol_thorough2: "In your opinion, how likely do you think it is that the police will aggresively investigate this case?"
	label define vig_pol_thorough2 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_thorough2 vig_pol_thorough2

	label variable vig_pol_invest2 "In your opinion, how likely do you think it is that the police will visit the sc"
	note vig_pol_invest2: "In your opinion, how likely do you think it is that the police will visit the scene of the crime?"
	label define vig_pol_invest2 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_invest2 vig_pol_invest2

	label variable vig_pol_interview2 "In your opinion, how likely do you think it is that the police will try to gathe"
	note vig_pol_interview2: "In your opinion, how likely do you think it is that the police will try to gather evidence from neighbors or witnesses?"
	label define vig_pol_interview2 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_interview2 vig_pol_interview2

	label variable vig_pol_paysmall2 "In your opinion, how likely do you think it is that the police will make the vic"
	note vig_pol_paysmall2: "In your opinion, how likely do you think it is that the police will make the victim pay a case registration fee or ask for a bribe?"
	label define vig_pol_paysmall2 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values vig_pol_paysmall2 vig_pol_paysmall2

	label variable compliance_patrol "About how often do you see police officers patrolling your area on FOOT?"
	note compliance_patrol: "About how often do you see police officers patrolling your area on FOOT?"
	label define compliance_patrol 1 "Daily" 2 "Weekly" 3 "Monthly" 4 "Seasonally" 5 "Less than seasonally or never" 97 "Do not know" 98 "Refuse to answer"
	label values compliance_patrol compliance_patrol

	label variable compliance_freq "About how often do you see police officers patrolling your area while in a vehic"
	note compliance_freq: "About how often do you see police officers patrolling your area while in a vehicle or on a motorbike?"
	label define compliance_freq 1 "Daily" 2 "Weekly" 3 "Monthly" 4 "Seasonally" 5 "Less than seasonally or never" 97 "Do not know" 98 "Refuse to answer"
	label values compliance_freq compliance_freq

	label variable compliance_meeting "In the past 6 months, have you HEARD ABOUT, SEEN, OR ATTENDED community meetings"
	note compliance_meeting: "In the past 6 months, have you HEARD ABOUT, SEEN, OR ATTENDED community meetings with police officers in your area?"
	label define compliance_meeting 1 "Yes" 0 "No"
	label values compliance_meeting compliance_meeting

	label variable polcommmeetattend6m "[IF YES]: have you personally ATTENDED any of these community meetings?"
	note polcommmeetattend6m: "[IF YES]: have you personally ATTENDED any of these community meetings?"
	label define polcommmeetattend6m 1 "Yes" 0 "No"
	label values polcommmeetattend6m polcommmeetattend6m

	label variable bribe_freq "How many times in the past 6 MONTHS have you made an unofficial payment to the p"
	note bribe_freq: "How many times in the past 6 MONTHS have you made an unofficial payment to the police?"
	label define bribe_freq 1 "None" 2 "Once" 3 "Between 2 and 5 times" 4 "More than 5 times" 97 "Do not know"
	label values bribe_freq bribe_freq

	label variable bribe_whatfor "The last time you made an unofficial payment to the police, what was it for? [SE"
	note bribe_whatfor: "The last time you made an unofficial payment to the police, what was it for? [SELECT ALL THAT APPLY]"
	label define bribe_whatfor 1 "To pay a fine" 2 "To register a case" 3 "To withdraw a case" 4 "To release a detainee" 5 "To pay for transport for a police officer" 6 "To evade a traffic violation" 7 "To pay a bribe while driving" 8 "To pay any other bribe" 88 "Other"
	label values bribe_whatfor bribe_whatfor

	label variable bribe_amt "The last time you made an unofficial payment to the police, how much was it?"
	note bribe_amt: "The last time you made an unofficial payment to the police, how much was it?"

	label variable bribe_amt_unit "[SELECT CURRENCY]"
	note bribe_amt_unit: "[SELECT CURRENCY]"
	label define bribe_amt_unit 1 "LD" 2 "USD"
	label values bribe_amt_unit bribe_amt_unit

	label variable policeabuse_phys_any "In the past 6 months, have you ever witnessed or heard about police officers PHY"
	note policeabuse_phys_any: "In the past 6 months, have you ever witnessed or heard about police officers PHYSICALLY ABUSING people from your community? [INCLUDING PUSHING, SLAPPING, PUNCHING, KICKING, CHOKING, ETC.]"
	label define policeabuse_phys_any 1 "Yes" 0 "No"
	label values policeabuse_phys_any policeabuse_phys_any

	label variable policeabuse_phys_num "[IF YES:] About how many times have you heard about this happening to people fro"
	note policeabuse_phys_num: "[IF YES:] About how many times have you heard about this happening to people from your community in the past year?"

	label variable policeabuse_phys_report "[IF YES:] To the best of your knowledge, was this incident reported to anyone? ["
	note policeabuse_phys_report: "[IF YES:] To the best of your knowledge, was this incident reported to anyone? [SELECT ALL THAT APPLY]"

	label variable policeabuse_verbal_any "In the past 6 months, have you ever witnessed or heard about police officers VER"
	note policeabuse_verbal_any: "In the past 6 months, have you ever witnessed or heard about police officers VERBALLY ABUSING people from your community? [INCLUDING SHOUTING, CUSSING, ETC.]"
	label define policeabuse_verbal_any 1 "Yes" 0 "No"
	label values policeabuse_verbal_any policeabuse_verbal_any

	label variable policeabuse_verbal_num "[IF YES:] About how many times have you heard about this happening to people fro"
	note policeabuse_verbal_num: "[IF YES:] About how many times have you heard about this happening to people from your community in the past year?"

	label variable policeabuse_verbal_report "[IF YES:] To the best of your knowledge, was this incident reported to anyone? ["
	note policeabuse_verbal_report: "[IF YES:] To the best of your knowledge, was this incident reported to anyone? [SELECT ALL THAT APPLY]"

	label variable policeabuse_hh_phys_any "In the past 12 months, have you or a member of your household ever been PHYSICAL"
	note policeabuse_hh_phys_any: "In the past 12 months, have you or a member of your household ever been PHYSICALLY ABUSED by a police officer? [INCLUDING PUSHING, SLAPPING, PUNCHING, KICKING, CHOKING, ETC.]"
	label define policeabuse_hh_phys_any 1 "Yes" 0 "No"
	label values policeabuse_hh_phys_any policeabuse_hh_phys_any

	label variable policeabuse_hh_phys_what "[If yes:] What happened?"
	note policeabuse_hh_phys_what: "[If yes:] What happened?"

	label variable policeabuse_hh_verbal_any "In the past 12 months, have you or a member of your household ever been VERBALLY"
	note policeabuse_hh_verbal_any: "In the past 12 months, have you or a member of your household ever been VERBALLY abused by a police officer?"
	label define policeabuse_hh_verbal_any 1 "Yes" 0 "No"
	label values policeabuse_hh_verbal_any policeabuse_hh_verbal_any

	label variable policeabuse_hh_verbal_what "[If yes:] What happened?"
	note policeabuse_hh_verbal_what: "[If yes:] What happened?"

	label variable checkpoint_report "Suppose you see a group of police officers running an illegal checkpoint just to"
	note checkpoint_report: "Suppose you see a group of police officers running an illegal checkpoint just to take money from motorists. How likely would you be to report that situation?"
	label define checkpoint_report 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values checkpoint_report checkpoint_report

	label variable checkpoint_report_where "[If 'Likely' or 'Very likely']: Where would you report that one? [SELECT ALL THA"
	note checkpoint_report_where: "[If 'Likely' or 'Very likely']: Where would you report that one? [SELECT ALL THAT APPLY]"

	label variable dutydrink_report "Suppose you see a uniformed police officer drinking alcohol in your community. H"
	note dutydrink_report: "Suppose you see a uniformed police officer drinking alcohol in your community. How likely would you be to report that situation?"
	label define dutydrink_report 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values dutydrink_report dutydrink_report

	label variable dutydrink_report_where "[If 'Likely' or 'Very likely']: Where would you report that one? [SELECT ALL THA"
	note dutydrink_report_where: "[If 'Likely' or 'Very likely']: Where would you report that one? [SELECT ALL THAT APPLY]"

	label variable policebeating_report "Suppose you see a group of officers beating someone in your community. How likel"
	note policebeating_report: "Suppose you see a group of officers beating someone in your community. How likely would you be to report that situation?"
	label define policebeating_report 1 "Very unlikely" 2 "Unlikely" 3 "Likely" 4 "Very likely" 97 "Do not know" 98 "Refuse to answer"
	label values policebeating_report policebeating_report

	label variable policebeating_report_where "[If 'Likely' or 'Very likely']: Where would you report that one? [SELECT ALL THA"
	note policebeating_report_where: "[If 'Likely' or 'Very likely']: Where would you report that one? [SELECT ALL THAT APPLY]"

	label variable legit_trust "Currently, how much do you trust the government?"
	note legit_trust: "Currently, how much do you trust the government?"
	label define legit_trust 1 "Not at all" 2 "Just a little" 3 "Somewhat" 4 "A lot" 97 "Do not know" 98 "Refuse to answer"
	label values legit_trust legit_trust

	label variable vote2017r1 "Did you vote in the FIRST round of the 2017 Presidential election?"
	note vote2017r1: "Did you vote in the FIRST round of the 2017 Presidential election?"
	label define vote2017r1 1 "Yes" 0 "No"
	label values vote2017r1 vote2017r1

	label variable party2017r1 "[IF YES:] Which party do you like for President in the FIRST round?"
	note party2017r1: "[IF YES:] Which party do you like for President in the FIRST round?"
	label define party2017r1 1 "ALCOP" 2 "ALP" 3 "ANC" 4 "CDC" 5 "LP" 6 "PUP" 7 "UP" 88 "Other" 97 "Do not know" 98 "Refuse to answer"
	label values party2017r1 party2017r1

	label variable vote2017r2 "Did you vote in the SECOND round of the 2017 Presidential election?"
	note vote2017r2: "Did you vote in the SECOND round of the 2017 Presidential election?"
	label define vote2017r2 1 "Yes" 0 "No"
	label values vote2017r2 vote2017r2

	label variable party2017r2 "[IF YES:] Which party do you like for President in the SECOND round?"
	note party2017r2: "[IF YES:] Which party do you like for President in the SECOND round?"
	label define party2017r2 1 "CDC" 2 "UP"
	label values party2017r2 party2017r2

	label variable willnum "Would you be willing to provide your phone number in case we want to contact you"
	note willnum: "Would you be willing to provide your phone number in case we want to contact you again in the future? Your number will be kept secret and confidential."
	label define willnum 1 "Yes" 0 "No"
	label values willnum willnum
	
	label variable willshare "Did you feel that the respondent was willing to share information and experience"
	note willshare: "Did you feel that the respondent was willing to share information and experiences with you?"
	label define willshare 1 "Yes" 0 "No"
	label values willshare willshare

	label variable distractions "Were there any distractions or interruptions during the interview?"
	note distractions: "Were there any distractions or interruptions during the interview?"
	label define distractions 1 "Yes" 0 "No"
	label values distractions distractions

	label variable angry "Did the respondent get irritated or angry at any time during the survey?"
	note angry: "Did the respondent get irritated or angry at any time during the survey?"
	label define angry 1 "Yes" 0 "No"
	label values angry angry

	
	
	
// CORRECTIONS BASED ON FIELD REPORTS	

	
	/* Note: because of SurveyCTO programming error, on 2/7/2019, teams used: towncode 6666 for Jamaica Road, towncode 7777 for Bassa Town and towncode 8888 for Zondo Town */
	/* Here, I replace with correct towncode, using the fact that 'community' variable overlaps with towncode */
	
	
	replace towncode = community if towncode==5555 | towncode==6666 | towncode==7777 | towncode==8888 | towncode==9999
	replace towncode = community if towncode==2002 | towncode==2017
	
	/* here I correct some incorrect IDs and towncodes based on tracking sheets and dates of surveys */
	
	replace respid = 7006202 if respid==7002202 & community==7006
	replace towncode = 7006 if respid==7006202 & community==7006
	replace respid = 9029202 if respid==9020202 & community==9029
	replace towncode = 9029 if respid==9029202 & community==9029
	
	replace respid = 5005313 if respid==8005313 & community==5005
	replace towncode = 5005 if respid==5005313 & community==5005
	replace respid = 5005314 if respid==8005314 & community==5005
	replace towncode = 5005 if respid==5005314 & community==5005
	
	replace respid = 5015135 if respid==8015135 & community==5015
	replace towncode = 5015 if respid==5015135 & community==5015
	*replace community = 8017  if respid==8010304	
	replace community=9006 if respid==9006173
	
	replace towncode=2032 if respid==2032313 & community==2032
	replace towncode=3022 if towncode==30022
	replace towncode=3028 if respid==3020214 & community==3028
		
	/* drop 3 observations -- surveys started before respondent declined consent */
	drop if consent==0

	
	replace respid=2004299 if respid==2004201 & starttime=="Feb 12, 2019 5:03:57 AM"
	replace respid=3005399 if respid==3005315 & starttime=="Feb 16, 2019 11:22:52 AM"
	replace respid=3010299 if respid==3010253 & starttime=="Feb 18, 2019 6:36:58 AM"
	replace respid=3028299 if respid==3028254 & starttime=="Feb 14, 2019 8:07:08 AM"
	replace respid=3028298 if respid==3028255 & starttime=="Feb 15, 2019 9:29:36 AM"
	replace respid=6000299 if respid==6000204 & starttime=="Feb 4, 2019 8:31:00 AM"
	replace respid=6666299 if respid==6666291 & starttime=="Feb 8, 2019 4:36:07 AM"
	replace respid=8005199 if respid==8005134 & starttime=="Jan 19, 2019 8:16:35 AM"
	replace respid=8010399 if respid==8010302 & starttime=="Jan 18, 2019 5:30:05 AM"
	replace respid=8010398 if respid==8010303 & starttime=="Jan 18, 2019 6:00:26 AM"
	replace respid=8017199 if respid==8017181 & starttime=="Jan 17, 2019 3:32:56 AM"
	replace respid=8017399 if respid==8017301 & starttime=="Jan 17, 2019 3:50:10 AM"
	replace respid=9021299 if respid==9021291 & starttime=="Jan 23, 2019 6:35:25 AM"
	replace respid=2025155 if respid==2027155 & community==2025
	drop if respid==2027155 & starttime=="Feb 14, 2019 8:40:48 AM"
	

	replace community=9028 if respid==9028292
	replace community=9028 if respid==9028182
	replace community=9028 if respid==9028132
	replace community=9028 if respid==9028138
	replace community=8010 if respid==8010304
	replace community=5005 if respid==5005135
	replace community=3010 if respid==3010175
	replace towncode=3021 if respid==3021311

	replace towncode=3024 if respid==3028299
	replace towncode=3024 if respid==3028255
	replace towncode=2025 if respid==2025155
	
	replace towncode=10014 if respid==8888191
	replace community=10014 if respid==8888191
	
	replace towncode=10014 if respid==8888192
	replace community=10014 if respid==8888192
	
	replace towncode=10014 if respid==8888193
	replace community=10014 if respid==8888193
	
	replace towncode=10014 if respid==8888194
	replace community=10014 if respid==8888194
	
	replace towncode=10014 if respid==8888195
	replace community=10014 if respid==8888195
	
	replace towncode=10020 if respid==777192
	replace community=10020 if respid==777192
	
	replace towncode=10020 if respid==7777193
	replace community=10020 if respid==7777193
	
	replace towncode=10020 if respid==7777194
	replace community=10020 if respid==7777194
	
	replace towncode=10020 if respid==7777195
	replace community=10020 if respid==7777195
	
	replace community=3009 if respid==3009181
	
	/* enumerator 28 confused about where he was on 01/19, using his team members locations for correct towncode */
	
	replace towncode=8005 if respid==9010281
	replace towncode=8005 if respid==9010282
	replace towncode=8005 if respid==9010283
	replace towncode=8005 if respid==9010284
	replace towncode=8005 if respid==9010285
	
	replace community=8005 if respid==9010281
	replace community=8005 if respid==9010282
	replace community=8005 if respid==9010283
	replace community=8005 if respid==9010284
	replace community=8005 if respid==9010285
	
	replace respid=8005281 if respid==9010281
	replace respid=8005282 if respid==9010282
	replace respid=8005283 if respid==9010283
	replace respid=8005284 if respid==9010284
	replace respid=8005285 if respid==9010285
	
	/* investigate outliers, mainly for crime reports */
	
	tab1 *crime_num_*
	foreach x of varlist *crime_num* {
		
		list enumerator community submissiondate if `x'>50 & `x'!=.
	
	}
	
	/* replace implausibly high values (>50) with . , following consultation with field manager */
	
	replace crime_num_2 = . if respid == 8888281
	replace crime_num_7 = . if respid == 4027231
	replace crime_num_7 = . if respid == 4027232
	replace crime_num_7 = . if respid == 1004215
	replace crime_num_7 = . if respid == 3005284
	replace ccrime_num_1 = . if respid == 1001271
	replace ccrime_num_2 = . if respid == 8015212
	replace ccrime_num_2 = . if respid == 1001273
	replace ccrime_num_2 = . if respid == 8888281	
	replace ccrime_num_3 = . if respid == 5000234
	replace ccrime_num_3 = . if respid == 1004231	
	replace ccrime_num_4 = . if respid == 9006271
	replace ccrime_num_4 = . if respid == 4020312
	replace ccrime_num_4 = . if respid == 1011272
	replace ccrime_num_4 = . if respid == 1001271
	replace ccrime_num_4 = . if respid == 1001273
	replace ccrime_num_4 = . if respid == 8888281	
	replace ccrime_num_6 = . if respid == 1001273	
	replace ccrime_num_7 = . if respid == 1004232
	replace ccrime_num_7 = . if respid == 1001271
	replace ccrime_num_7 = . if respid == 1001273
	replace ccrime_num_7 = . if respid == 8888281
	replace ccrime_num_7 = . if respid == 2028231
	replace ccrime_num_7 = . if respid == 3028231	
	replace ccrime_num_8 = . if respid == 8004271
	replace ccrime_num_11 = . if respid == 8006204
	replace ccrime_num_11 = . if respid == 1011275
	replace ccrime_num_11 = . if respid == 3027273
	replace ccrime_num_12 = . if respid == 8888281
	replace ccrime_num_12 = . if respid == 2005312
	
	replace cmob_num = . if respid==2040154
	replace cmob_num = . if respid==3000292
	replace cmob_num = . if respid==4014294
	replace cmob_num = . if respid==5004211
	replace cmob_num = . if respid==5005294
	replace cmob_num = . if respid==9018154
	replace cmob_num = . if respid==9028292
	replace cmob_num = . if respid==5555251
	replace cmob_num = . if respid==6666299
	replace cmob_num = . if respid==8888295

	replace cgroups = . if respid==5002151
	
