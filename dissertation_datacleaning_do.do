*******************************************************************************
*NAME: dissertation_datacleaning_do.do
*DESCRIPTION: data cleaning code for dissertation
*LAST UPDATED: 25 June 2024
*******************************************************************************

*******************************************************************************
*NOTE: File 1/4.: Run this do file FIRST.
*******************************************************************************

capture log close
clear
cd "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code"
capture log using ./dissertation_datacleaning.log, replace
use "Data\copy_j_egc_withshocks.dta", clear

***********************************************************************
/* Select Variables */
***********************************************************************

keep id1 eano regionofbirth yearofbirth age ageheap monthofbirth K10 K10_1 K10_2 K10_3 lnK10 K10severe female children urban ageatmarriage religion reldreligio_2 reldreligio_3 reldreligio_4 reldreligio_5 reldreligio_6 reldreligio_7 reldreligio_8 reldreligio_9 reldreligio_10 reldreligio_11 reldreligio_12 reldreligio_99 broadethnicity ethdbroadet_2 ethdbroadet_3 ethdbroadet_4 ethdbroadet_5 ethdbroadet_6 ethdbroadet_7 ethdbroadet_8 ethdbroadet_9 ethdbroadet_10 ethdbroadet_11 ethdbroadet_12 ethdbroadet_13 ethdbroadet_14 fatherocc fatheragric anyschool readsenglish worksnonself isco_work heightcm_trimmed bmi_trimmed savings healthinsurance trust_trust head femaleXhead personality_4 personality_9 personality_12 personality_18 personality_29 personality_27 


***********************************************************************
/* Review and Revise Variables */
***********************************************************************

rename id1 currentregion
label variable currentregion "Current region of residence (2009/10) (categorical)"
notes currentregion: "Proxy against region of birth for MIGRATION control"

label variable eano "Enumneration Area number (categorical)"
notes eano: "Ref p8 of GSPS documentation. Within 10 regions of Ghana, '5010 households from 334 Enumeration Areas (EAs) were sampled. The number of EAs for each region was proportionately allocated based on estimated 2009 population share for each region. EAs for Upper East and Upper West regions, which have relatively smaller population sizes, were over sampled to allow for a reasonable number of households to be interviewed in these regions."

label variable female "0=male | 1=female"
notes female: "covariate"

label variable monthofbirth "Month of birth (categorical)"
notes monthofbirth: "ROBUSTNESS"

label variable yearofbirth "Year of Birth" 
notes yearofbirth: "Includes Adhuvaryu et al.'s adjustments to include those with YOB missing by using age provided."

label variable age "NOT FOR ANALYSIS: Age (continuous)"

label variable ageheap "NOT FOR ANALYSIS: (0=respondent did not round age | 1= respondent rounded age)"
tab ageheap
drop ageheap 

label variable ageatmarriage "Age at marriage (continuous)"
notes ageatmarriage: "Proxy for MARITAL STATUS covariate"

label variable religion "Religion (categorical)"
notes religion: "covariate"

label variable regionofbirth "Region of Birth (categorical)"

label variable broadethnicity "Ethnicity: Broad categories (categorical)"
notes broadethnicity: "use available dummies if comparing more rural/agricultural ethnicities"

label variable urban "0=rural | 1=urban"
notes urban: "covariate"

rename K10 k10
label variable k10 "K10 Score" 
notes k10: "Missing values alread removed"

rename K10_1 k10_1
tab k10_1
tab k10 if k10 >= 10 & k10 <= 24 /*double-checks k10 score range*/
label variable k10_1 "K10: Well/Mild Distress [10-24] (0=not in category | 1=well/mild distress)" 

rename K10_2 k10_2 
tab k10_2 
tab k10 if k10 >= 25 & k10 <= 29 /*double-checks k10 score range*/
label variable k10_2 "K10: Moderate Distress [25-29] (0=not in category | 1=moderate distress)" 

rename K10_3 k10_3
tab k10_3 
tab k10 if k10 >= 30 /*double-checks k10 score range*/
label variable k10_3 "K10: Severe Distress [>=30] (0=not in category | 1=severe distress)" 

rename K10severe k10severe
tab k10severe 
label variable k10severe "K10: Severe Distress [>=30] (0=not in category | 1=severe distress)"
notes k10severe: DEPENDENT VARIABLE-2  
notes k10severe: k10_3 variable dropped as this is the same

rename lnK10 lnk10
label variable lnk10 "Log K10 score"
notes lnk10: DEPENDENT VARIABLE-1 
notes lnk10: "Raw K10 scores might be skewed, complicating regression analyses and other statistical models that assume normally distributed residuals. Log transformation reduces skewness, making the data more suitable for such models."

label variable head "0=Not HH head | 1= HH head"

label variable femaleXhead "0=Not a female HH head | 1= Female HH head"

label variable anyschool "0=Never attended school | 1=Ever attended school"
notes anyschool: "TBD proxy for EDUCATION covariate"

label variable healthinsurance "0=Never had health insurance | 1=Has ever had health insurance"
notes healthinsurance: "ROBUSTNESS"

label variable heightcm_trimmed "Height in cm : Outliers removed (coninuous)"
notes heightcm_trimmed: "Proxy A for 'PHYSICAL HEALTH STOCK' mediator" 

label variable bmi_trimmed "BMI : Outliers removed (continuous)"
notes bmi_trimmed: "TBD Proxy B for 'PHYSICAL HEALTH STOCK' mediator"

label variable fatheragric "0=Father not in agriculture | 1=Father in agric"
notes fatheragric: "Proxy for CHILDHOOD SES mediator"
tab fatheragric
tab fatherocc /*confirms fatheragric is a dummy of this variable*/
drop fatherocc

rename readsenglish englishliteracy
label variable englishliteracy "0=Does not read English | 1=Reads English"
notes englishliteracy: "Proxy for COGNITIVE FUNCTION mediator"

rename worksnonself farm_selfemployed
label variable farm_selfemployed "0=Does not work on farm/not self employed | 1=Works on farm/self employed"
notes farm_selfemployed: "Proxy for EMPLOYMENT STATUS"

/* Drop Unused emmployment variable
label variable isco_work "ISCO code for work other than self employment (continuous)"
notes isco_work: "Proxy for EMPLOYMENT STATUS mediator"
notes isco_work: "International Standard Classification of Occupations (ISCO) is an International Labour Organization (ILO) classification structure for organizing information on labour and jobs. ILO: 'A tool for organizing jobs into a clearly defined set of groups according to the tasks and duties undertaken in the job. It is intended for use in statistical applications...' The ISCO-08 revision is expected to be the standard for labour information worldwide in the coming decade, for instance as applied to incoming data from the 2010 Global Round of National Population Census" */
drop isco_work

label variable savings "Savings (continuous)"
note savings: "Variable for SAVINGS mediator"

label variable trust_trust "Most people in village can be trusted (categorical)"
notes trust_trust: "ROBUSTNESS. Proxy for PERCEIVED SOCIAL SUPPORT"

rename personality_4 personality_blue 
label variable personality_blue "I am someone who is depressed blue (categorical)"
notes personality_blue: "ROBUSTNESS"

rename personality_9 personality_relaxed
label variable personality_relaxed "I am someone who is relaxed handles stress well (categorical)"
notes personality_relaxed: "ROBUSTNESS"

rename personality_12 personality_quarrels
label variable personality_quarrels "I am someone who starts quarrels with others (categorical)"
notes personality_quarrels: "ROBUSTNESS"

rename personality_18 personality_disorganized
label variable personality_disorganized "I am someone who tends to be disorganized (categorical)"
notes personality_disorganized: "ROBUSTNESS"

rename personality_27 personality_aloof
label variable personality_aloof "I am someone who can be cold and aloof (categorical)"
notes personality_aloof: "ROBUSTNESS"

rename personality_29 personality_moody
label variable personality_moody "I am someone who can be moody (categorical)"
notes personality_moody: "ROBUSTNESS"

label variable children "Number of children in household (continuous)"
notes children: "TBD if needed since this is in adulthood. Could be proxy for HH SIZE."
drop children 


***********************************************************************
/* Generate Variables */
***********************************************************************

/* Identifiers */
*****************

/* T&C: REGIONAL IDENTIFIERS */

*Most-intensely affected regions (T group)
tab regionofbirth, gen(temp)

rename temp4 rgtreat_central
label variable rgtreat_central "TREATMENT | regionofbirth==Central"

rename temp14 rgtreat_western
label variable rgtreat_western "TREATMENT | regionofbirth==Western"

rename temp13 rgtreat_volta
label variable rgtreat_volta "TREATMENT | regionofbirth==Volta"

rename temp2 rgtreat_ashanti
label variable rgtreat_ashanti "TREATMENT | regionofbirth==Ashanti" 

rename temp8 rgtreat_northern
label variable rgtreat_northern "TREATMENT | regionofbirth==Northern"

rename temp11 rgtreat_uppereast
label variable rgtreat_uppereast "TREATMENT regionofbirth==Upper East"

rename temp12 rgtreat_upperwest 
label variable rgtreat_upperwest "TREATMENT | regionofbirth==Upper West"

gen ROB_treat_all = 0
replace ROB_treat_all = 1 if rgtreat_central == 1 | rgtreat_western == 1 | rgtreat_volta == 1 | rgtreat_ashanti == 1 | rgtreat_northern == 1 | rgtreat_uppereast == 1 | rgtreat_upperwest == 1
label variable ROB_treat_all "TREATMENT birth regions: Central, Western, Volta, Ashanti, Northern, Upper East, Upper West"

*Least-intensely affected regions (C group)
rename temp5 rgcontrol_eastern
rename temp3 rgcontrol_brong
rename temp6 rgcontrol_accra

label variable rgcontrol_eastern "CONTROL | regionofbirth==Eastern"
label variable rgcontrol_brong "CONTROL | regionofbirth==Brong Ahafo"
label variable rgcontrol_accra "CONTROL | regionofbirth==Greater Accra"

gen ROB_control_all = 0 
replace ROB_control_all = 1 if rgcontrol_eastern == 1 | rgcontrol_brong == 1 | rgcontrol_accra == 1
label variable ROB_control_all "CONTROL birth regions: Eastern, Brong Ahafo, Greater Accra"

*Drop regional identifiers unused in analysis
drop temp1 temp7 temp9 temp10


/* DV: K10 OUTCOMES */

*Potential outcome variables: 
sum lnk10
tab k10severe
tab k10

/*TBD additional k10 var
gen k10severe_cont = .
replace k10severe_cont = k10 if k10 >= 30 & k10 <= 50
tab k10severe_cont
label variable k10severe_cont "K10: Severe Distress scores >= 30 (continuous)"
*/

/* Potential Covariates and Mediators */
***********************************************************

/* MARITAL STATUS */
tab ageatmarriage
gen maritalstatus = !missing(ageatmarriage)
tab maritalstatus
label variable maritalstatus "0=unmarried | 1=married"

/* RELIGIOUS */ 
*Recode missings and make 'No religion' response a missing value.
tab religion 

tab reldreligio_10 
label variable reldreligio_10 "0=Practices religion | 1=Does not practice religion"

tab reldreligio_99
label variable reldreligio_99 "0=non-missing values | 1=missing values"

gen religious = 0
replace religious = 1 if reldreligio_10 == 1 | reldreligio_99 == 1
tab religious
label variable religious "0= religious | 1= NOT religious"

*Drop religions unused in analysis
drop reldreligio_2 reldreligio_3 reldreligio_4 reldreligio_5 reldreligio_6 reldreligio_7 reldreligio_8 reldreligio_9 reldreligio_11 reldreligio_12

/* MIGRATION */
tab currentregion
tab regionofbirth

encode regionofbirth, gen(regionofbirth_num)
gen migrated = (regionofbirth_num != currentregion)
tab migrated 
label variable migrated "0=no | 1=yes" 

/* SOCIOECONOMIC STATUS */
tab fatheragric
rename fatheragric SESfatheragric

/* EMPLOYMENT STATUS */
tab farm_selfemployed 
rename farm_selfemployed employment 

/* ETHNITICTY */
drop ethdbroadet_2 ethdbroadet_3 ethdbroadet_4 ethdbroadet_5 ethdbroadet_6 ethdbroadet_7 ethdbroadet_8 ethdbroadet_9 ethdbroadet_10 ethdbroadet_11 ethdbroadet_12 ethdbroadet_13 ethdbroadet_14

/* Delete if not using

tab yearofbirth, gen(temp)

rename temp37 YOB_1979
rename temp38 YOB_1980
rename temp39 YOB_1981
rename temp40 YOB_1982
rename temp41 YOB_1983
rename temp42 YOB_1984
rename temp43 YOB_1985
rename temp44 YOB_1986
rename temp45 YOB_1987

*/

***********************************************
/* Save Data */
***********************************************

save "Data\cleaned_dissertationdata.dta", replace

cap log close

