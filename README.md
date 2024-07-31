# MSc Dissertation

This repository includes four Stata Do files and the original dataset that accompany the MSc Behavioural Science dissertation titled, "The Indelible Mark of Starvation: Long-Term Mental Health Consequences of Childhood Exposure to Famine in Ghana".

## Data

This study uses the ‘Main EGC’ replication dataset made publicly available by Adhvaryu et al. (2019), which originally evaluated impacts of early life cocoa price shocks on mental distress in Ghana.

A copy of the original dataset is included in the 'Data' folder. The original is found under the ‘Supplemental Material’ tab of the Adhvaryu et al. (2019) online article: https://www.journals.uchicago.edu/doi/suppl/10.1086/701606.

## Usage instructions

In each of the following, change the filepath on Line 13 according to where these files are stored on the user's system. The scripts should be run in the order they are listed below.
1. `dissertation_datacleaning_do.do`: Clean original data and make suitable for current study analysis.
2. `dissertation_analysis_do.do`: Create sample statistics, conduct balance checks, generate plots, and conduct main causal analysis.
3. `dissertation_robustness_do.do`: Conduct robustness analyses.
4. `dissertation_mediation_do.do`: Conduct mediation analyses.
