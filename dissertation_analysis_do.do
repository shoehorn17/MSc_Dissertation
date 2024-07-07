*******************************************************************************
*NAME: dissertation_Analysis_do.do
*DESCRIPTION: Analysis of causal effect of childhood famine exposure on later-life mental health
*LAST UPDATED: 3 July 2024
*******************************************************************************

*******************************************************************************
*NOTE: File 2/4. Run this do file SECOND, after dissertation_datacleaning.
*******************************************************************************

capture log close
clear
cd "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code"
capture log using ./dissertation_analysis.log, replace
use "Data\cleaned_dissertationdata.dta", clear

*Set Times New Roman font. 
graph set window fontface "Times New Roman"

*******************************************************************************
/* Data Observation */
*******************************************************************************

// Visualise relationship between K10 scores and year of birth within treatment regions and within control regions, using conditional means.

*Plot with standard bin width 
cmogram k10 yearofbirth if ROB_treat_all, graphopts(ytitle("Average K10 Score") xtitle("Year of Birth") xline(0) title("Adult K10 Scores in Most Severely Impacted Regions")  xline(1983) xline(1984)) 
*Aong those born within the neighboring 10 years of the famine dates (1978 - 1989, there appears to be a spike in K10 scores for those born aroundf 1980 and potentially 1985. 
******TO DO: add colors to bars of interest (in paint), make those before 1960 pale or remove, make x/y axes the same as other graphs. Get rid of crazy high spike.

graph export "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code\Plots_for_report\1a_MeanK10_YOB_Treatment_standard.png", replace 

cmogram k10 yearofbirth if ROB_control_all, graphopts(ytitle(Average K10 Score) xtitle(Year of Birth) yscale(range(15 22)) title(Adult K10 Scores Per Birth Year in Least Severely Impacted Regions) xline(1983) xline(1984)) 
*In control regions, there appears to be less of a spike here.
*So it is worth investigating.
******TO DO: add colors to bars of interest (in paint), make those before 1960 pale or remove, make x/y axes the same as other graphs. Get rid of crazy high spike. 

graph export "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code\Plots_for_report\1a_MeanK10_YOB_Control_standard.png", replace 

/* Decide if I want to include the 2-year bins and/or comment on them */

*Plot with 2-year bin width 
cmogram k10 yearofbirth if ROB_treat_all, histopts(width(2)) graphopts(ytitle("Average K10 Score") xtitle("Year of Birth") xline(0) title("Adult K10 Scores in Most Severely Impacted Regions")  xline(1983) xline(1984)) 
*1980-81 and *1984-85 may have spikes, so will investigate those age groups (consistent with literature)

cmogram k10 yearofbirth if ROB_control_all, histopts(width(2)) graphopts(ytitle(Average K10 Score) xtitle(Year of Birth) title(Adult K10 Scores in Least Severely Impacted Regions) xline(1983) xline(1984))

// Visualise K10 score distribution
*Plot raw k10 scores to test assumption of normality
hist k10, normal title("Distribution of Raw K10 Scores") xtitle("K10 Scores") ytitle("Density") 
graph export "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code\Plots_for_report\2a_k10_distribution.png", replace 

*Test assumption of a normal distribution of k10 scores using Shapiro-Wilk test, where H0: The data are normally distributed.
swilk k10 

*Plot log k10 scores to normalise distribution for ease of interpretation 
hist lnk10, normal  title("Distribution of Log of K10 Scores") xtitle("K10 Scores") ytitle("Density")
graph export "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code\Plots_for_report\2b_logk10_distribution.png", replace  

*Test assumption of a normal distribution of log-transformed k10 scores using Shapiro-Wilk test, where H0: The data are normally distributed.
swilk lnk10 

*******************************************************************************
/* Generate Updated Variables */
*******************************************************************************

/* Identifiers */
*******************************

/* GENERATE IV: EXPOSED AND UNEXPOSED BIRTH COHORTS */

*Cohort 1: Toddler (born 1980-81)
gen cohort1_toddler = yearofbirth >= 1980 & yearofbirth <= 1981
tab cohort1_toddler /*461 obsv*/
label variable cohort1_toddler "NATIONWIDE Cohort 1: Toddler. Age 3-4 at famine end date (born 1980-81)"

*Cohort 2: Infant (born 1982-83)
gen cohort2_infant = yearofbirth >= 1982 & yearofbirth <= 1983
tab cohort2_infant /* 541 obsv */
label variable cohort2_infant "NATIONWIDE Cohort 2: Infant. Age 1-2 at end of famine (born 1982-83)"

* Cohort 3: In utero (Born 1984-85)
gen cohort3_inutero = yearofbirth >= 1984 & yearofbirth <= 1985 
tab cohort3_inutero /* 457 obsv */
label variable cohort3_inutero "NATIONWIDE Cohort 3: In utero & unborn. at end of famine (born 1984-85)"

/* Treatment Groups */
*******************************
// Create treatment groups of proportion of cohorts born in most-intensely impacted regions

* 1a) TODDLER  /*342 obsv*/
gen toddler_treat = 0
replace toddler_treat = 1 if cohort1_toddler == 1 & (ROB_treat_all == 1)
tab toddler_treat 
label variable toddler_treat "Cohort 1: Toddler (born 1980-81) in most-severely impacted regions"

* 2a) INFANT  /*392 obsv*/
gen infant_treat = 0
replace infant_treat = 1 if cohort2_infant == 1 & (ROB_treat_all == 1)
tab infant_treat
label variable infant_treat "Cohort 2: Infant (born 1982-83) in most-severely impacted regions"

* 3a) IN UTERO  /*331 obsv*/
gen inutero_treat = 0 
replace inutero_treat = 1 if cohort3_inutero == 1 & (ROB_treat_all == 1)
tab inutero_treat
label variable inutero_treat "Cohort 3: In utero & unborn (born 1984-85) in most-severely impacted regions"

/* Control Groups */
*******************************
// Create control groups of proportion of cohorts born in least-intensely impacted regions

* 1b) TODDLER  /*112 obsv*/
gen toddler_control = 0
replace toddler_control = 1 if cohort1_toddler == 1 & (ROB_control_all == 1)
tab toddler_control 
label variable toddler_control "Cohort 1: Toddler (born 1980-81) in least-severely impacted regions"

* 2b) INFANT /*146 obsv*/
gen infant_control = 0
replace infant_control = 1 if cohort2_infant == 1 & (ROB_control_all == 1)
tab infant_control
label variable infant_control "Cohort 2: Infant (born 1982-83) in least-severely impacted regions"

* 3b) IN UTERO /*122 obsv*/
gen inutero_control = 0
replace inutero_control = 1 if cohort3_inutero == 1 & (ROB_control_all == 1)
tab inutero_control
label variable inutero_control "Cohort 3: In utero & unborn (born 1984-85) in least-severely impacted regions"


/* Full Sample */
*******************************
// Generate analytic sample consisting of all control and treatment groups

* FULL SAMPLE /*1445 obsv*/
gen studysample = 0
replace studysample = 1 if toddler_treat == 1 | infant_treat == 1 | inutero_treat == 1 | toddler_control == 1 | infant_control == 1 | inutero_control == 1

tab studysample 
label variable studysample "0=out of sample | 1=sample"

* SPECIFIC COHORTS

* Accurate sample of Cohort 1: Toddler
gen cohort1_toddler_tc = 0 
replace cohort1_toddler_tc = 1 if toddler_treat == 1 | toddler_control == 1 
tab cohort1_toddler_tc
label variable cohort1_toddler_tc "Cohort 1: Toddler. Age 3-4 at famine end date (born 1980-81) in T & C regions."

*Accurate sample of Cohort 2: Infant
gen cohort2_infant_tc = 0 
replace cohort2_infant_tc = 1 if infant_treat == 1 | infant_control == 1 
tab cohort2_infant_tc
label variable cohort2_infant_tc "Cohort 2: Infant. Age 1-2 at end of famine (born 1982-83) in T & C regions."

*Accurate sample of Cohort 3: In utero/unborn
gen cohort3_inutero_tc = 0
replace cohort3_inutero_tc = 1 if inutero_treat == 1 | inutero_control == 1 
tab cohort3_inutero_tc
label variable cohort3_inutero_tc "Cohort 3: In utero/unborn. In utero and unborn at famine end (born 1984-85) in T & C regions."

/* Re-order Dataset */
*******************************
order studysample toddler_treat toddler_control infant_treat infant_control inutero_treat inutero_control cohort1_toddler_tc cohort2_infant_tc cohort3_inutero_tc lnk10 k10severe female SESfatheragric maritalstatus religious heightcm_trimmed bmi_trimmed englishliteracy employment savings ROB_treat_all ROB_control_all rgtreat_western rgtreat_central rgcontrol_accra rgcontrol_brong rgcontrol_eastern cohort1_toddler_tc cohort2_infant_tc cohort3_inutero_tc cohort1_toddler cohort2_infant cohort3_inutero


*******************************************************************************
/* Prepare Sample Statistics */
*******************************************************************************

/* Sample Stats Table */
*******************************

// Total Observations
tab studysample

tab toddler_treat
tab infant_treat 
tab inutero_treat 

tab toddler_control
tab infant_control 
tab inutero_control

// Age
summarize age if studysample == 1

summarize age if toddler_treat == 1
summarize age if infant_treat == 1
summarize age if inutero_treat  == 1

summarize age if toddler_control == 1
summarize age if infant_control == 1
summarize age if inutero_control == 1

// K10 scores
summarize k10 if studysample == 1
summarize lnk10 if studysample == 1

summarize k10 if toddler_treat == 1
summarize lnk10 if toddler_treat == 1

summarize k10 if infant_treat == 1
summarize lnk10 if infant_treat == 1

summarize k10 if inutero_treat == 1
summarize lnk10 if inutero_treat == 1

summarize k10 if toddler_control == 1
summarize lnk10 if toddler_control == 1

summarize k10 if infant_control == 1
summarize lnk10 if infant_control == 1

summarize k10 if inutero_control == 1
summarize lnk10 if inutero_control == 1

// Control: Female
tab female if studysample == 1
tab female if toddler_treat == 1
tab female if infant_treat == 1
tab female if inutero_treat == 1
tab female if toddler_control == 1
tab female if infant_control == 1
tab female if inutero_control == 1

// Control: Low SES
tab SESfatheragric if studysample == 1
tab SESfatheragric if toddler_treat == 1
tab SESfatheragric if infant_treat == 1
tab SESfatheragric if inutero_treat == 1
tab SESfatheragric if toddler_control == 1
tab SESfatheragric if infant_control == 1
tab SESfatheragric if inutero_control == 1

// Control: Married
tab maritalstatus if studysample == 1
tab maritalstatus if toddler_treat == 1
tab maritalstatus if infant_treat == 1
tab maritalstatus if inutero_treat == 1
tab maritalstatus if toddler_control == 1
tab maritalstatus if infant_control == 1
tab maritalstatus if inutero_control == 1

// Control: Religious
tab religious if studysample == 1
tab religious if toddler_treat == 1
tab religious if infant_treat == 1
tab religious if inutero_treat == 1
tab religious if toddler_control == 1
tab religious if infant_control == 1
tab religious if inutero_control == 1


*******************************************************************************
/* Tests for Biases */
*******************************************************************************

/* Covariate Balance Checks */
******************************************
*Conduct t-tests to compare balance across cohorts, then across treatment and control groups. 

// Between Birth Cohorts
*Generate variable for t-tests
gen cohort_1v2 = .
replace cohort_1v2 = 1 if cohort1_toddler_tc == 1
replace cohort_1v2 = 2 if cohort2_infant_tc == 1
label variable cohort_1v2 "T-test variable to compare (1) toddler and (2) infant cohorts"

gen cohort_1v3 = .
replace cohort_1v3 = 1 if cohort1_toddler_tc == 1
replace cohort_1v3 = 3 if cohort3_inutero_tc == 1
label variable cohort_1v3 "T-test variable to compare (1) toddler and (3) inutero cohorts"

gen cohort_2v3 = .
replace cohort_2v3 = 2 if cohort2_infant_tc == 1
replace cohort_2v3 = 3 if cohort3_inutero_tc == 1
label variable cohort_2v3 "T-test variable to compare (2) infant and (3) in utero cohorts"

*Pairwise t-tests for 'female' covariate
ttest female, by(cohort_1v2) /* toddler v infant */
ttest female, by(cohort_1v3) /* toddler v in utero */
ttest female, by(cohort_2v3) /* infant v in utero */

*Pairwise t-tests for 'Low SES' covariate
ttest SESfatheragric, by(cohort_1v2) /* toddler v infant */
ttest SESfatheragric, by(cohort_1v3) /* toddler v in utero */
ttest SESfatheragric, by(cohort_2v3) /* infant v in utero */

*Pairwise t-tests for 'Married' covariate
ttest maritalstatus, by(cohort_1v2) /* toddler v infant */
ttest maritalstatus, by(cohort_1v3) /* toddler v in utero */
ttest maritalstatus, by(cohort_2v3) /* infant v in utero */

*Pairwise t-tests for 'Religious' covariate
ttest religious, by(cohort_1v2) /* toddler v infant */
ttest religious, by(cohort_1v3) /* toddler v in utero */
ttest religious, by(cohort_2v3) /* infant v in utero */

/* NOTES (UPDATED 26 June)

*A non-significant p-value (p => 0.05) suggests that the difference in proportions of females between the two cohorts is not statistically significant. (So there's no significant differences between the group, which is good and means they're balanced).

*T-tests confirm proportion of FEMALES is BALANCED across cohorts!
---> toddler v infant --> Pr(|T| > |t|) = 0.1254 (no sig difference)
---> toddler v in utero -->  0.8709 (no sig difference)
---> infant v in utero --> p: 0.0889  (no sig difference)

*Suggests proportion of those with LOW SES is BALANCED across cohorts!
---> toddler v infant--> p: 0.4996 (no sig difference) 
---> toddler v in utero --> p: 0.1533 (no sig difference) 
---> infant v in utero --> p:  0.4077 (no sig difference)

*Suggests proportion of those how are MARRIED is NOT BALANCED [NOT COMPARABLE BETWEEN COHORTS (but maybe comparable within cohorts so ok?!]
---> toddler v infant --> p: 0.0133 (SIG DIFFERENCE!) 
---> toddler v in utero --> p: 0.0000 (SIG DIFFERENCE!) 
---> infant v in utero --> p: 0.0000 (SIG DIFFERENCE!) 

*Suggests proportion of those who are RELIGIOUS  is BALANCED across cohorts!
---> toddler v infant --> p: 0.6075 (no sig difference) 
---> toddler v in utero --> p: 0.9940 (no sig difference) 
---> infant v in utero --> p: 0.6132  (no sig difference) 

*/

// Across Treatment and Control Groups
*Generate variable for t-tests
gen cohort_toddler_1v2 = .
replace cohort_toddler_1v2 = 1 if toddler_treat == 1
replace cohort_toddler_1v2 = 2 if toddler_control == 1
label variable cohort_toddler_1v2 "T-test variable to compare (1) toddler_treat and (2) toddler_control"

gen cohort_infant_1v2 = .
replace cohort_infant_1v2 = 1 if infant_treat == 1
replace cohort_infant_1v2 = 2 if infant_control == 1
label variable cohort_infant_1v2  "T-test variable to compare (1) infant_treat and (2) infant_control"

gen cohort_inutero_1v2 = .
replace cohort_inutero_1v2 = 1 if inutero_treat == 1
replace cohort_inutero_1v2 = 2 if inutero_control == 1
label variable cohort_inutero_1v2 "T-test variable to compare (1) inutero_treat and (2) inutero_control"

*Pairwise t-tests for 'female' covariate between cohorts' treatment and control groups
ttest female, by(cohort_toddler_1v2) /* toddler T v C */
ttest female, by(cohort_infant_1v2) /* infant T v C */
ttest female, by(cohort_inutero_1v2) /* post-fam T v C */

*Pairwise t-tests for 'Low SES' covariate between cohorts' treatment and control groups
ttest SESfatheragric, by(cohort_toddler_1v2) /* toddler T v C */
ttest SESfatheragric, by(cohort_infant_1v2) /* infant T v C */
ttest SESfatheragric, by(cohort_inutero_1v2) /* inutero T v C */

*Pairwise t-tests for 'Married' covariate between cohorts' treatment and control groups
ttest maritalstatus, by(cohort_toddler_1v2) /* toddler T v C */
ttest maritalstatus, by(cohort_infant_1v2) /* infant T v C */
ttest maritalstatus, by(cohort_inutero_1v2) /* inutero T v C */

*Pairwise t-tests for 'Religious' covariate between cohorts' treatment and control groups
ttest religious, by(cohort_toddler_1v2) /* toddler T v C */
ttest religious, by(cohort_infant_1v2) /* infant T v C */
ttest religious, by(cohort_inutero_1v2) /* inutero T v C */

/* NOTES (UPDATED 26 June)

*Suggests proportion of FEMALES is BALANCED within cohorts!
---> toddler T v C  --> p: 0.3934 (no sig difference)
---> infant T v C --> p: 0.3334 (no sig difference)
---> post-fam T v C --> p: 0.8470 (no sig difference)

*Suggests proportion of LOW SES is NOT BALANCED within cohorts!!!
---> toddler T v C  --> p: 0.0004 (SIG DIFFERENCE!)
---> infant T v C --> p: 0.0026 (SIG DIFFERENCE!)
---> inutero T v C --> p: 0.0004 (SIG DIFFERENCE!)

*Suggests proportion of MARRIED is NOT BALANCED within INFANT & INUTERO COHORTS!!!! [may not be an issue since these groups don't show an effect.]
---> toddler T v C  --> p: 0.3715 (no sig difference) 
---> infant T v C --> p: 0.0048 (SIG DIFFERENCE!) 
---> inutero T v C --> p: 0.0045 (SIG DIFFERENCE!)

*Suggests proportion of RELIGIOUS is BALANCED within cohorts!
---> toddler T v C --> p: 0.8289 (no sig difference) 
---> infant T v C --> p: 0.0804 (no sig difference) 
---> inutero T v C --> p: 0.5973 (no sig difference) 

*/


/* Covariate Multicollinearity Checks */
*************************************************
*Use Variance Inflation Factor (VIF) to review correlation between prospective control variables.

// Toddler Cohort - Treatment and control groups
regress toddler_treat lnk10 female SESfatheragric maritalstatus religious
vif
regress toddler_control lnk10 female SESfatheragric maritalstatus religious
vif

// Infant Cohort - Treatment and control groups
regress infant_treat lnk10 female SESfatheragric maritalstatus religious
vif
regress infant_control lnk10 female SESfatheragric maritalstatus religious
vif

// In utero Cohort - Treatment and control groups
regress inutero_control lnk10 female SESfatheragric maritalstatus religious
vif
regress inutero_control lnk10 female SESfatheragric maritalstatus religious
vif

******************************************************************************
/* Cohort Analyses */
******************************************************************************

/* Guidance */
******************************************
*RQ1: Does early-life exposure to famine affect later-life mental health?  

*Model: MHic =  a + β1Exposureic + x′ic + εic  


/* Analysis */
******************************************

/**** INTERPRETATION NOTES [DELETE WHEN DONE]: 

// Firstly, It appears to be a
// continuous variable, so it makes sense to talk about a 'one-unit change'.
// Secondly, we need to remember we're looking at a multiple regression, so we
// interpret coefficients ceteris paribus - what is the effect of changing 
// 'nprevist' holding all other independent variables constant? The
// interpretation is that a one-unit change in 'nprevist' results in a 34.07
// unit (gram) increase in birthweight, holding all other variables constant.
// This is therefore a partial effect.


*****p-value: 0.05 (5%) 
*****REJECT THE NULL HYPOTHESIS IF p < 0.05.
*****A result with a p-value p < 0.05 is considered `unlikely', a p-value p > 0.05 is considered `likely':
*Often, it is better to communicate the p-value rather than simply whether a test rejects a hypothesis or not, as the p-value contains more information than the yes/no statement about hypotheses.

[Can say 'We're 95% confident...' or 'at the 95% confidence level...']
[Significance probability; means we would expect to not reject the null hypothesis in 5% of samples. We would expect to reject the null hypothesis 95% of the time. Probability of incorrectly rejecting the null hypothesis when it is actually true - Type 1 error.]

******Confidence interval is used to describe the amount of uncertainty associated with a sample estimate of a population parameter.
**Rather than saying whether something is more than or less than something else, we can talk in terms of `how much' bigger or smaller it is.
**A 95% confidence level means that 95% of the intervals would include the true population parameter
*The confidence interval captures the population parameter given the lower and upper bound – but it might not. Use Cis to bound the mean or standard deviation, but also for regression coefficients and for the differences between populations.

The confidence level is a certain percentage of the confidence interval that will contain the population parameter if you draw a random sample many times. It expresses how confident we can be that our CI contains the population parameter.

INTERPRETATION
*Look at ChatGPT response copied into 'Stata steps' tab!!!
*Look at George's 'Linear Regression withOne Regressor / other PPTs'


*/


// COHORT 1: TODDLER
********************
*H1: Survivors in the Toddler Cohort (IV) experience increased K10 scores (DV) when more intensely exposed to famine (T).
*H0: Survivors in the Infant Cohort (IV) DO NOT experience increased K10 scores (DV) when more intensely exposed to famine (T).

// T GROUP: Run OLS reregressions to establish if a linear relationship exists between exposure to famine among toddlers in the most-severely affected regions (IV) and log K10 scores (DV). 
*Teffects command efficiently applies inverse probability weights to correct for covariate imbalances.
*vce(robust) adjusts standard errors in case of the presence of heteroskedasticity.



//////////////RUNNING THIS ALL BY LARRY - Will either use reg, teffects, or something else for IPW. Update everthuing below accordingly after meeting! /////////////////// 

*Run baseline regression. 
teffects ipw (lnk10) (toddler_treat), vce(robust)
/* CAN reject the null! (0.001) --> significant! */

*Add controls sequentually, until reaching preferred specification.
teffects ipw (lnk10) (toddler_treat female), vce(robust) 

teffects ipw (lnk10) (toddler_treat female SESfatheragric), vce(robust)

teffects ipw (lnk10) (toddler_treat female SESfatheragric maritalstatus), vce(robust)

teffects ipw (lnk10) (toddler_treat female SESfatheragric maritalstatus religious), vce(robust)
*ATE: toddler_treat (1 vs 0) --> 0.0331339
*CAN reject the null! (0.040) --> significant!

// C GROUP: Apply same intution to control group, as well as treatment and control groups in other cohorts.
teffects ipw (lnk10) (toddler_control), vce(robust)
*Cannot reject null (0.893) --> insignificant 

*Add controls sequentially

teffects ipw (lnk10) (toddler_control female SESfatheragric maritalstatus religious), vce(robust)
*Cannot reject null (0.890) --> insignificant



// COHORT 2: INFANT
********************
*H1: Survivors in the Infant Cohort (IV) experience increased K10 scores (DV) when more intensely exposed to famine (T).
*H0: Survivors in the Infant Cohort (IV) DO NOT experience increased K10 scores (DV) when more intensely exposed to famine (T).

// T GROUP
teffects ipw (lnk10) (infant_treat), vce(robust)
****Cannot reject null (0.429) --> insignificant. 

*Add controls sequentially
teffects ipw (lnk10) (infant_treat female SESfatheragric maritalstatus religious), vce(robust)
***ATE: infant_treat (1 vs 0): -.0341232 [so there actually is a positive effect of exposure to famine??]
***CAN REJECT THE NULL! (0.033) --> SIGNIFICANT in preferred specification! 

// C GROUP
teffects ipw (lnk10) (infant_control), vce(robust)
****Cannot reject null (0.956) --> insignificant

*Add controls sequentially
teffects ipw (lnk10) (infant_control female SESfatheragric maritalstatus religious), vce(robust)
****Cannot reject null (0.574) --> insignificant 


// COHORT 3: IN UTERO
*********************
*H1: Survivors in the In utero Cohort (IV) experience increased K10 scores (DV) when more intensely exposed to famine (T).
*H0: Survivors in the In utero Cohort (IV) DO NOT experience increased K10 scores (DV) when more intensely exposed to famine (T).

//ANALYSE TREATMENT GROUP
teffects ipw (lnk10) (inutero_treat), vce(robust)
****Cannot reject null (0.672) --> insignificant

*Add controls sequentially
teffects ipw (lnk10) (inutero_treat female SESfatheragric maritalstatus religious), vce(robust)
****Cannot reject null (0.357) --> insignificant 


*ANALYSE CONTROL GROUP
teffects ipw (lnk10) (inutero_control), vce(robust)
****Cannot reject null (0.665) --> insignificant

*Add controls sequentially
teffects ipw (lnk10) (inutero_control female SESfatheragric maritalstatus religious), vce(robust)
****Cannot reject null (0.856) --> insignificant 





/* Results Figures */
*******************************

// Graph to show results for the 3-4 year old cohort 


save "Data\cleaned_analysed_dissertationdata.dta", replace

log close
