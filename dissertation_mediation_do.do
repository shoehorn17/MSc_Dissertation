*******************************************************************************
*NAME: dissertation_mediation_do.do
*DESCRIPTION: Mediation analysis
*LAST UPDATED: 3 July 2024
*******************************************************************************

*******************************************************************************
*NOTE: File 4/4. Run this do file LAST, after dissertation_robustness.
*******************************************************************************

capture log close
clear
cd "~\OneDrive\Desktop\LSE MSc Behavioural Sciences\DISSERTATION\6 Methods\1 Main Analysis\Code"
capture log using ./dissertation_mediation.log, replace
use "Data\cleaned_analysed_dissertationdata.dta", clear

/* Install the mediation package used to compute the mediation analysis in Stata
ssc install mediation 
*/

*Set Times New Roman font. 
graph set window fontface "Times New Roman"



***********************************************************************
/* Mediation Analysis */
***********************************************************************

/////////////UPDATE THIS WITH THE PREFERRED CONTROLS / SPECIFICATION OF MAIN RESULTS! Only do this if I get a significant main result!////////

/* Use this example to help interpret: 

X: Priming vs. control manipulation
Y: Implicit attitudes toward statistics
Z: State self-efficacy (mediator)


*Third model --  46% is explained by self efficacy, but the other 54% isn't explained...
*Interpretation of this chart: Self-efficacy should be a mediator. 
**[IMPORTANT] ACME - priming increases attitudes toward statistics by 10.5% compared to control. This is the effect that travels trhough self-efficacy (mediator). This is what is explained by self-reported self efficacy. The remainder of this is what we COULD NOT explain through self0efficacy. 
*Importantly, the first parameter is ACME - Average Causal Mediated Effect. In this particular analysis, ACME shows that X=1 decreases Y compared to X=0 by 0.95 points of the scale by decreasing Z (i.e. it is the effect of X on Y that can be explained by Z). 

****Direct effect - 
**Priming increases attitudes toward stats by 0.996(?) - 'the mediator didn't explain it
*Direct effect refers to the influence of X on Y when Z is included in the regression model
*The fact that the direct effect did not become insignificant (i.e. not different from 0) means that there may still be other important mediators we did not identify. However, the mediator that we did identify seems to be an important WHY variable given that it is statistically significant. 

**Total effect - how much priming increases attitudes toward statistics. 
**% of Tot Eff mediated - 46% is explained by self ifficacy, but the other 54% isn't explained...
*Total effect is the sum of ACME (-0.9513608) and direct effect (-1.153153). Total effect is the parameter that is also computed from the first regression formula Y = b10 + c11X + e1 (see regression output on slide 5). It is the total influence of X on Y that combines the influence via the mediator and the direct influence that is not accounted for by the mediator. 

**Since we're not finding causal impact - the greatest weakness (as in lecture notes) is that it's correlation. So have a strong theory about the mediators

**[IMPORTANT] % of Tot Effect mediated indicates the percentage of total effect that can be explained by the mediator, which is roughly 45% in this case. 


*/

/* Analysis */
*******************************
*X: Toddler treated vs. Toddler untreated
*Y: Log K10 score
*Z: [Three candidate mediators]: Physical health, cognitive function, wealth

// PHYSICAL HEALTH

*Standardise height variable for ease of comparison. 
summarize heightcm_trimmed  
egen heightcm_trimmed_std = std(heightcm_trimmed)
summarize heightcm_trimmed heightcm_trimmed_std

*Run regression to calculate the influence of treatment (X) on log K10 score (Y) (i.e. total effect).
*regress (Y X)
regress lnk10 toddler_treat female female SESfatheragric maritalstatus religious, robust /* add control? */

*Compute the mediated effect ACME. 
*Include sims(1000) to specify the number of simulations to run for the quasi-Bayesian approximation of parameter uncertainty. 
*medeff (regress Z X) (regress Y Z X), treat(X) mediate(Z) sims(1000)
medeff(regress heightcm_trimmed_std toddler_treat) (regress lnk10 heightcm_trimmed_std toddler_treat female SESfatheragric maritalstatus religious), treat(toddler_treat) mediate(heightcm_trimmed_std) sims(1000) /* add controls? */
***ACME (indirect effect) is not signficant and therefore we take caution when interpreting results. 

// COGNITIVE FUNCTION

*Compute the mediated effect ACME. 
*Include sims(1000) to specify the number of simulations to run for the quasi-Bayesian approximation of parameter uncertainty. 
*medeff (regress Z X) (regress Y Z X), treat(X) mediate(Z) sims(1000)
medeff(regress englishliteracy toddler_treat) (regress lnk10 englishliteracy toddler_treat female SESfatheragric maritalstatus religious), treat(toddler_treat) mediate(englishliteracy) sims(1000) /* add controls? */
***Significant when controls are added. Cognitive function makes up approx 38.7% of total effect

//WEALTH

*Standardise savings variable for ease of comparison. 
summarize savings
egen savings_std = std(savings)
summarize savings savings_std

*Compute the mediated effect ACME. 
*Include sims(1000) to specify the number of simulations to run for the quasi-Bayesian approximation of parameter uncertainty. 
*medeff (regress Z X) (regress Y Z X), treat(X) mediate(Z) sims(1000)
medeff(regress savings_std toddler_treat) (regress lnk10 savings_std toddler_treat female SESfatheragric maritalstatus religious), treat(toddler_treat) mediate(savings_std) sims(1000) /* add controls? */
****All insignificant when controls are added


/*Notes: LOOK AT EXPERIMENTAL METHODS NOTES AN D


---> Could check my notes on what Adhvaryu and Van den Broek do too.
---> Look at the NOTES p 1537 chart (also in 'Stata steps' OneNote to help to know what to standardize, etc).

*Create table like Adhuvaryu (see p1534-1536) and/or bar charts like p 1539 of Adhuvaryu  

*/

log close