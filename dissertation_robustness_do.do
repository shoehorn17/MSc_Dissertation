*******************************************************************************
*NAME: dissertation_Robustness_do.do
*DESCRIPTION: Robustness checks for main analysis
*LAST UPDATED: 11 July 2024
*******************************************************************************

*******************************************************************************
*NOTE: File 3/4. Run this do file THIRD, after dissertation_analysis.
*******************************************************************************

capture log close
clear
cd "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code"
capture log using ./dissertation_robustness.log, replace
use "Data\cleaned_analysed_dissertationdata.dta", clear

*******************************************************************************
/* Test 2: APPLY WEIGHTING TO PREFERRED SPECIFICATION */
*******************************************************************************

/* IPW Regression Analysis */
*******************************
* teffects ipwra command calculates weights as the estimated inverse probabilities of treatment, adjusts regressions to correct for covariate imbalances, and provides average treatment effect. 
* Specify linear model. 
* vce(robust) adjusts standard errors in case of the presence of heteroskedasticity.

// COHORT 1: TODDLER
********************
// T GROUP
teffects ipwra (lnk10, linear) (toddler_treat female SESfatheragric maritalstatus religious), vce(robust)

// C GROUP
teffects ipwra (lnk10, linear) (toddler_control female SESfatheragric maritalstatus religious), vce(robust)

// COHORT 2: INFANT
********************
// T GROUP
teffects ipwra (lnk10, linear) (infant_treat female SESfatheragric maritalstatus religious), vce(robust)

// C GROUP
teffects ipwra (lnk10, linear) (infant_control female SESfatheragric maritalstatus religious), vce(robust)

// COHORT 3: IN UTERO
***********************
// T GROUP
teffects ipwra (lnk10, linear) (inutero_treat female SESfatheragric maritalstatus religious), vce(robust)

// C GROUP
teffects ipwra (lnk10, linear) (inutero_control female SESfatheragric maritalstatus religious), vce(robust)

 
*******************************************************************************
/* Test 2: EVALUATE LIKELIHOOD OF SEVERE DISTRESS */
*******************************************************************************

/* Prepare Analysis */
*******************************
* Visualise average K10 scores in data with histogram.
* Add line to represent K10 >= 30, which indicates severe distress.
twoway (hist k10, discrete percent xline(29.5))

* Tabulate new outcome variable. 
tab k10severe 

/* Logit Regressions for K10 severe */
*****************************************
* Use logit command to run a regression with a binary dependent variable.  
* robust adjusts standard errors in case of the presence of heteroskedasticity.

// COHORT 1: TODDLER
********************
// T GROUP
logit k10severe toddler_treat female SESfatheragric maritalstatus religious, robust

// C GROUP
logit k10severe toddler_control female SESfatheragric maritalstatus religious, robust

// COHORT 2: INFANT
********************
// T GROUP
logit k10severe infant_treat female SESfatheragric maritalstatus religious, robust
logistic k10severe infant_treat female SESfatheragric maritalstatus religious, robust

// C GROUP
logit k10severe infant_control female SESfatheragric maritalstatus religious, robust

// COHORT 3: IN UTERO
***********************
// T GROUP
logit k10severe inutero_treat female SESfatheragric maritalstatus religious, robust
logistic k10severe inutero_treat female SESfatheragric maritalstatus religious, robust

// C GROUP
logit k10severe inutero_control female SESfatheragric maritalstatus religious, robust

log close

