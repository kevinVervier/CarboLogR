################################################################################
# Check that the currently-installed version of R
# is at least the minimum required version.
################################################################################
R_min_version = "3.5.0"
R_version = paste0(R.Version()$major, ".", R.Version()$minor)
if(compareVersion(R_version, R_min_version) < 0){
  stop("You do not have the latest required version of R installed.\n",
       "Launch should fail.\n",
       "Go to http://cran.r-project.org/ and update your version of R.")
}

################################################################################
# Install basic required packages if not available/installed.
################################################################################
install_missing_packages = function(pkg, version = NULL, verbose = TRUE){
  availpacks = .packages(all.available = TRUE)
  source("http://bioconductor.org/biocLite.R")
 # biocLite("BiocUpgrade")
  missingPackage = FALSE
  if(!any(pkg %in% availpacks)){
    if(verbose){
      message("The following package is missing.\n",
              pkg, "\n",
              "Installation will be attempted...")
    }
    missingPackage <- TRUE
  }
  if(!is.null(version) & !missingPackage){
    # version provided and package not missing, so compare.
    if( compareVersion(a = as.character(packageVersion(pkg)),
                       b = version) < 0 ){
      if(verbose){
        message("Current version of package\n",
                pkg, "\t",
                packageVersion(pkg), "\n",
                "is less than required.
                Update will be attempted.")
      }
      missingPackage <- TRUE
      }
  }
  if(missingPackage){
    biocLite(pkg, suppressUpdates = TRUE)
  }
  }
################################################################################
# Define list of package names and required versions.
################################################################################
deppkgs = c(MASS='7.3-51.4',
            cluster='2.1.0',
            DT="0.5",
            effsize = "0.7.1",
            gridExtra='2.3',
            growthcurver='0.3.0',
            heatmaply='0.15.2',
            plotly = "4.8.0",
            shinyFiles = "0.7.2",
            shiny = "1.2.0",
            shinythemes = "1.1.2")
# Loop on package check, install, update
pkg1 = mapply(install_missing_packages,
              pkg = names(deppkgs),
              version = deppkgs,
              MoreArgs = list(verbose = TRUE),
              SIMPLIFY = FALSE,
              USE.NAMES = TRUE)

################################################################################
# Load packages that must be fully-loaded
################################################################################
for(i in names(deppkgs)){
  library(i, character.only = TRUE)
  message(i, " package version:\n", packageVersion(i))
}
################################################################################
