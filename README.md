# MSc Dissertation
This repository includes four Stata Do files and the original dataset that accompany the MSc Behavioural Science dissertation titled, "The Indelible Mark of Starvation: Long-Term Mental Health Consequences of Childhood Exposure to Famine in Ghana".

## Data
This study uses the ‘Main EGC’ replication dataset made publicly available by Adhvaryu et al. (2019), which originally evaluated impacts of early life cocoa price shocks on mental distress in Ghana.

A copy of the original dataset is included in the 'Data' folder. The original is found under the ‘Supplemental Material’ tab of the Adhvaryu et al. (2019) online article: https://www.journals.uchicago.edu/doi/suppl/10.1086/701606.

## Usage instructions

- dissertation_datacleaning_do: Run this first to clean original data and make suitable for current study analysis. Change Line 13 to match where these files are stored on the user’s local directory.
- dissertation_analysis_do: Run this second to create sample statistics, plots, and conduct main causal analysis. Change Line 13 to match where these files are stored on the user’s local directory.
- dissertation_robustness_do: Run this third to conducts robustness analyses. Change Line 13 to match where these files are stored on the user’s local directory.
- dissertation_mediation_do: Run this last to conduct mediation analyses. Change Line 13 to match where these files are stored on the user’s local directory.
