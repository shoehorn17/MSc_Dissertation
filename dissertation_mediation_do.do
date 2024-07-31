*******************************************************************************
*NAME: dissertation_mediation_do.do
*DESCRIPTION: Mediation analysis
*LAST UPDATED: 11 July 2024
*******************************************************************************

*******************************************************************************
*NOTE: File 4/4. Run this do file LAST, after dissertation_robustness.
*******************************************************************************

capture log close
clear
cd "~\OneDrive\Documents\MSc\Stata\Code"
capture log using ./dissertation_mediation.log, replace
use "Data\cleaned_analysed_dissertationdata.dta", clear

***********************************************************************
/* Mediation Analysis */
***********************************************************************
*X: Toddler treated vs. Toddler untreated
*Y: Log K10 score
*Z: [Three candidate mediators]: Physical health, cognitive function, wealth

/* (1) Physcial Health */
*******************************
*Standardise height variable for ease of comparison. 
summarize heightcm_trimmed  
egen heightcm_trimmed_std = std(heightcm_trimmed)
summarize heightcm_trimmed heightcm_trimmed_std

*Run regression to calculate the influence of treatment (X) on log K10 score (Y) (i.e. total effect).
*regress (Y X)
regress lnk10 toddler_treat female SESfatheragric maritalstatus religious, robust

*Compute the mediated effect ACME. 
*Include sims(1000) to specify the number of simulations to run for the quasi-Bayesian approximation of parameter uncertainty. 
*medeff (regress Z X) (regress Y Z X), treat(X) mediate(Z) sims(1000)
* NOTE: medeff requires "ssc install mediation"
medeff(regress heightcm_trimmed_std toddler_treat) (regress lnk10 heightcm_trimmed_std toddler_treat female SESfatheragric maritalstatus religious), treat(toddler_treat) mediate(heightcm_trimmed_std) sims(1000)

/* (2) Cognitive Function */
*******************************
*Run regression to calculate the influence of treatment (X) on log K10 score (Y) (i.e. total effect).
*regress (Y X)
regress lnk10 toddler_treat female SESfatheragric maritalstatus religious, robust

*Compute the mediated effect ACME. 
*Include sims(1000) to specify the number of simulations to run for the quasi-Bayesian approximation of parameter uncertainty. 
*medeff (regress Z X) (regress Y Z X), treat(X) mediate(Z) sims(1000)
medeff(regress englishliteracy toddler_treat) (regress lnk10 englishliteracy toddler_treat female SESfatheragric maritalstatus religious), treat(toddler_treat) mediate(englishliteracy) sims(1000)

/* (3) Wealth */
*******************************
*Standardise savings variable for ease of comparison. 
summarize savings
egen savings_std = std(savings)
summarize savings savings_std

*Run regression to calculate the influence of treatment (X) on log K10 score (Y) (i.e. total effect).
*regress (Y X)
regress lnk10 toddler_treat female SESfatheragric maritalstatus religious, robust

*Compute the mediated effect ACME. 
*Include sims(1000) to specify the number of simulations to run for the quasi-Bayesian approximation of parameter uncertainty. 
*medeff (regress Z X) (regress Y Z X), treat(X) mediate(Z) sims(1000)
medeff(regress savings_std toddler_treat) (regress lnk10 savings_std toddler_treat female SESfatheragric maritalstatus religious), treat(toddler_treat) mediate(savings_std) sims(1000) 

log close