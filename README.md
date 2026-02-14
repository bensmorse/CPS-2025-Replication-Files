# Replication files for:

> [Ben Morse. "Strengthening the Rule of Law through Community Policing: Evidence from Liberia." (2024)](https://doi.org/10.1177/00104140241252090).

To replicate results, open `06_Code\LIB_MK4_Master.do`, update your directory, and run the file in its entirety.

## Read Me

The contents of each folder in this replication package are as follows:

### **01_Randomization**

- `LIB_MK4_assignment_data.csv`: List of communities in each of Monrovia's ten police zones. List compiled in July 2018 based on field interviews with LNP rank and file during site visits to each police zone headquarters in July 2018. During this time, officers were also asked to nominate any "high priority" communities for the intervention based on their perceptions of crime and police/community relations. 35 communities were nominated in total.

- `LIB_MK4_assignment_code.r`:
  - 1. Randomly selects 65 communities across all ten zones, with the number of communities selected proportional to the total number of communities per zone.
  - 2. Appends 35 purposively selected communities to the sample (none of which overlapped with the 65 communities above).
  - 3. Drops two communities from the sample on the following grounds: in each case, two different community names were found to refer to the same community.
  - 4. Outputs `LIB_MK4_sample.csv` and `LIB_MK4_sample_treatment_only.csv`.

- `LIB_MK4_sample.csv`: List of sample communities and their treatment assignment.

- `LIB_MK4_sample_treatment_only.csv`: Same as `LIB_MK4_sample.csv`, but for treatment communities only.

### **02_Survey Instruments**

- Contains the baseline and endline surveys, as well as the mob violence survey of police officers that was administered a few months after the endline survey.

### **03_Raw De-Identified Data**

- Contains the raw, de-identified datasets for the baseline survey, endline survey, and mob violence survey of police officers.

### **04_Raw Administrative Data**

- Contains census data, LNP crime data, and dates that each community hosted a town hall meeting with police (does not include dates of foot patrols, however).

### **05_Processed Data**

- `LIB_MK4_processed_data_baseline.dta`: Output from `06_Code\LIB_MK4_01_cleaning_code_baseline_survey.do`. Contains the baseline raw data + construction of baseline covariates and outcomes.

- `LIB_MK4_processed_data_baseline_commlevel.dta`: Also output from `06_Code\LIB_MK4_01_cleaning_code_baseline_survey.do`. This is a community-level (N=93) dataset containing the community-level mean for each baseline outcome. This dataset is used as lagged DV controls at endline (since the baseline-endline survey is a repeated cross-section, rather than an individual-level panel, the endline analysis controls for lagged DV at the community level rather than individual level).

- `LIB_MK4_processed_data_endline.dta`: Output from `06_Code\LIB_MK4_03_cleaning_code_endline_survey.do`. Contains the endline raw data + construction of endline outcomes.

- `LIB_MK4_processed_data_lnp_admin.dta`: Clean LNP admin data on crime reports.

- `LIB_MK4_processed_data_mob_violence.dta`: Output from `06_Code\LIB_MK4_05_cleaning_code_mob_violence_survey.do`. Contains the main outcome from the mob violence survey: number of mob violence events reported in the community in the past 8 months.

- `LIB_MK4_analysis`: Output from `LIB_MK4_06_cleaning_code_merge_all_data.do`. This is the analysis-ready data file with all endline outcomes + community-level lagged DVs.

### **06_Code**

- `LIB_MK4_00_Master.do`: Runs cleaning and analysis files in proper sequence to replicate all findings from the main paper and appendix.

- `LIB_MK4_01_cleaning_code_baseline_survey.do`: Runs on raw de-identified baseline data, outputs clean baseline data with baseline outcomes + a community-level baseline dataset with community-level mean outcomes (for use as lagged DVs in analysis).

- `LIB_MK4_02_cleaning_code_endline_survey.do`: Insheets raw endline data, labels variables according to their survey question.

- `LIB_MK4_03_cleaning_code_endline_survey.do`: Picks up where `02` leaves off, constructs outcomes from the endline survey.

- `LIB_MK4_04_cleaning_code_LNP_admin.do`: Insheets raw crime data from LNP, constructs outcomes, and saves as `LIB_MK4_processed_data_lnp_admin.dta`.

- `LIB_MK4_05_cleaning_code_mob_violence_survey.do`: Insheets raw de-identified mob violence data, constructs the main outcome variable — number of mob violence events in the community in the past 8 months — and saves as `05_Processed Data\LIB_MK4_processed_data_mob_violence.dta`.

- `LIB_MK4_06_cleaning_code_merge_all_data.do`: Loads processed endline survey data, then merges all data sources together into one analysis-ready file, including: community-level baseline DVs, mob violence data, treatment assignment data, LNP admin data, census data (not used). Subsequently, the data file constructs survey weights according to the procedure prescribed by PAP; then it labels variables for descriptives and tables produced by the analysis do file.

- `LIB_MK4_07_data_analysis_code.do`: Generates results for the tables and figures in the manuscript and appendix, in the order in which they appear.

- `bh_pvalue_adjust.r`: Applies the Benjamini and Hochberg (1995) procedure to p-values for primary hypotheses, to control the within hypothesis-cluster FDR to 5%.

- `LIB_MK4_08_construct_figures.r`: The results for Figures 1-3 are generated in Stata, then saved to `.csv` to be plotted in R. `LIB_MK4_08_construct_figures.r` insheets these `.csv` files and generates the figures.

### **07_Results**

- Folder where `.tex` table results are outputted. In addition, `.csv` files for results underlying Figures 1-3 are outputted here.
