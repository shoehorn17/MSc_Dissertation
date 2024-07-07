*******************************************************************************
*NAME: dissertation_Robustness_do.do
*DESCRIPTION: Robustness checks for main analysis
*LAST UPDATED: 3 July 2024
*******************************************************************************

*******************************************************************************
*NOTE: File 3/4. Run this do file THIRD, after dissertation_analysis.
*******************************************************************************

capture log close
clear
cd "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code"
capture log using ./dissertation_robustness.log, replace
use "Data\cleaned_dissertationdata.dta", clear

*Set Times New Roman font. 
graph set window fontface "Times New Roman"


******************************************************************************
/* Test 1: EVALUATE LIKELIHOOD OF SEVERE DISTRESS */
******************************************************************************

/* Prepare Analyses */
*******************************

// Visualise average K10 scores in data
*Add line to represent K10 >= 30, which indicates severe distress.
twoway (hist k10, discrete percent xline(29.5))
graph export "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code\Plots_for_report\Robustness_1_MeanK10severe.png", replace
***Shows the majority of Ghanian's don't report severe distress.

// Generate other variables

/* Logit Regressions for K10 severe */
*****************************************
****Do this for ALL cohorts.
****See word doc for justification and general how-to.
****See notes below and phone screenshots on how to do / interpret logit regressions.
/***LOGIT REGRESSION NOTES

H0: ... [to reject]
H0: The difference in means is 0?

*Conduct a difference-in-means hypothesis test....
*Logit regression models the probability of Y = 1, given X, as the cumulative standard logistic distribution function, evaluated at z = β0 + β1X: Pr(Y = 1|X ) = F(β0 + β1X)

logit k10severe cohort1_toddler [add controls], robust 

*Conduct regression with added controls [might need to do pwcorr first... hopefully helps.
*/
/***NOTES ON PRACTICALITIES AND INTERPRETATION:
For BINARY VARIABLES: [use logit regression - see notes in OneNote on how to / steps to take to interpret]: logit k10severe prefam_treat

STEPS:
*Do I slowly add controls here? Or use all controls? (See notes for each in 'updated controls' tab) [YES]
*How to add binary vs categorical vs continuous controls to a regression? does it matter? [Look at ChatGPT response in 14 June/in OneNote. Binary OK, Categorical requires i.var (presumably var is the variable i want)] --> i.var doesnt créate new dummies it just interprets the categorical variable as such
*Do for all cohorts in ONLY most-intenseley affected areas.
*Decide if LOGIT or LINEAR regression
	1) Logit (still linear) = k10 is binary 
	2) OLS linear = k10 is continuous
	3) I think: log -->linear regression  | Dummy for severe distress --> logit regression

*/
/***P-VALUES & CONFIDENCE INTERVALS: 

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


*/




/* Results Figures and Tables */
*******************************
*TBD

 
 
 
 
******************************************************************************
/* Test 2: APPLY BIRTH REGION FIXED EFFECTS */
******************************************************************************

/* Prepare Analyses */
*******************************
*TBD

/* Model */
*******************************
*TBD - like main analysis but add FE.

/* Regressions */
*******************************
****See word doc for justification and general how-to.
****See Ch. 16 of The Effect (re. Durban Wu Hausman test) and clustering standard errors. Also look at Adhuvaryu do file to see if helpful (they played around with several fixed effects).
*Might want to remove SES if I do this because it could be considered a `within' variation in the region of birth.
****Scratch attempts at this: 

//Toddler - treatment group (multiple) and control
reg lnk10 toddler_treat female SESfatheragric maritalstatus religious ROB_treat_all, robust /* probably not as simple as adding ROB_treat_all and instead using i.var but need to check */

xtreg lnk10 toddler_treat female SESfatheragric maritalstatus religious i.regionofbirth_num, fe vce(clusteano) robust  /* This is Stat's command for fixed effects but not really working; want to cluster by enumeration area like Adhvaryu */

areg lnk10 toddler_treat female SESfatheragric maritalstatus religious, absorb(regionofbirth_num) robust /* areg seems to be what Adhuvaryu did, but not sure why, and can't tell if this is the right way to go */
 
reg lnk10 toddler_control female SESfatheragric maritalstatus religious ROB_control_all, robust

//Infant - treatment and control
reg lnk10 infant_treat female SESfatheragric maritalstatus religious ROB_treat_all, robust

reg lnk10 infant_control female SESfatheragric maritalstatus religious ROB_control_all

//In utero - treatment and control
reg lnk10 inutero_treat female SESfatheragric maritalstatus religious ROB_treat_all, robust, robust

reg lnk10 inutero_control female SESfatheragric maritalstatus religious ROB_control_all, robust
 

/* Results Figures and Tables */
*******************************
*TBD
 


******************************************************************************
/* Test 3: RELATED PERSONALITY TRAITS */
******************************************************************************
****See word doc for justification and general how-to.
****ONLY for Toddler cohort / most affected

/* Prepare Analyses */
*******************************
****personality traits: personality_blue personality_relaxed personality_quarrels personality_disorganized personality_aloof personality_moody
/***Code for Likert scale variables would be something like this: 

generate edu0 = 0
recode edu0 0 = 1 if education==0
generate edu1 = 0
recode edu1 0 = 1 if education==1
generate edu2 = 0
recode edu2 0 = 1 if education==2
generate edu3 = 0
recode edu3 0 = 1 if education==3
generate edu4 = 0
recode edu4 0 = 1 if education==4

 */


/* Regressions */
*******************************


/* Results Figures and Tables */
*******************************
*Mimic Adhuvaryu's resutls table



