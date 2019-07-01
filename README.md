# CarboLogR: quality control and statistical analysis for 96-well phenotype plates

* Phenotype Microarray 96-well plates utilise colorimetric redox reactions to rapidly screen bacteria for the ability to utilise different carbon sources and other metabolites. Measurement of substrate utilisation as bacterial growth curves typically involves extended data normalization, outlier detection, and statistical analysis. 

* The CarboLogR package streamlines this process with a Shiny application, guiding users from raw data generated from Biolog assays to growth profile comparison. 

* We applied chemoinformatics approaches to define clusters of carbon sources, based on molecular similarities, increasing statistical power. 

* Altogether, CarboLogR is a novel integrated tool providing automatic and high-level resolution for bacterial growth patterns and carbon source usage.

# How to install the package

User can easily install the package directly from Github.
```
library(devtools)
devtools::install_github('kevinVervier/CarboLogR')
library(CarboLogR)

runAnalysis() # this command launches the Shiny app.
```

Alternatively, user can download the Github repository as an archive, unzip it, and open the `inst/shiny-app/CarboLogR/server.R` in Rstudio, then press the **Run App** button.
