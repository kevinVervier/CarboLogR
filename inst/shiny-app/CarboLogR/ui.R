#----------------------#
# UI part of CarboLogR #
#----------------------#

shinyUI(fluidPage(#theme = "bootstrap.css",

  titlePanel("CarboLogR: Quality control and Functional enrichment for Phenotype Array"),

  navbarPage(
    "CarboLogR",
    tabPanel("Before starting...",mainPanel(
      h1('Few words before starting:'),
      p("Welcome to the CarboLogR Shiny application."),
      p("This application aims at providing an interactive way for importing and comparing data from 96-wells plates."),
      p("Users can try it by loading records stored in inst/extdata/exampleDataPM1")
    )),
    # data import panel
    tabPanel("Import plate data",mainPanel(
      p('First, provide the path to a folder containing all the Biolog records in a .csv format:'),
      tags$p(shinyDirButton('plate_directory', 'Push to select a directory', 'Please select a folder'), align= "center"),
      p('NB: '),
      tags$ul(
        tags$li('File names should be formatted like organismName_replicateNumber (e.g., HB_1).')
      ),
      radioButtons(inputId="plateTypeSelect", label="Which Biolog plate was used?",
                   choices=c("AN","PM1","PM2A","other")),

        textOutput("text_organism"),
      p('NB: please make sure that the number of organisms is correct. If not, there might be an issue with data import.')

    )),
    # Quality control
    tabPanel("Quality control",mainPanel(
      p('In this panel, we propose an exploratory analysis of the imported data'),
      p('For each organism, we compare its replicates and identify outliers, flag them and filter them out.'),
      p('Then, for the remaining data, we estimate wells where we are confident growth was detected across replicates.'),

      actionButton("evReactiveButton", "Run quality control"),
      div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("text_qc", placeholder = TRUE))),

      p('Users can save the growth presence/absence for each sample and well that passed quality control.'),
      downloadButton("downloadDataQC", "Download processed data")

    )),
    # Visualization panel
    tabPanel("Visualization of growth data",mainPanel(
      p('In this panel, we provide visualization of the fitted growth model for each plate and all wells'),
      p('By default, we only represent replicates and wells that were kept after QC'),
      p('Users can select checkboxes if they want to keep either the filtered replicates or the filtered wells'),

      uiOutput("selectedOrganism"),
      checkboxInput("showOutRep", "show outlier replicates", FALSE),
   # no easy visual way to display all the wells, no longer in the UI:
   # checkboxInput("showOutWell", "show low-quality wells", FALSE),
      div(style="width:1000px;padding-left:200px;",fluidRow(plotOutput("plot_growth")))
      #plotOutput("plot_growth",  width = "150%")

    )),
   # Group comparison panel
   tabPanel("Analysis - presence of growth",mainPanel(
     p('In this panel, we provide statistical tools to compare groups of organisms'),
     h1('load Metadata (for more than 1 organism)'),
     p('Users need to provide a metadata file with:'),
     p('- first column is organism name'),
     p('- second column is group name'),
     p('example provided in inst/extdata/metadata_PM1.txt'),

     #fileInput("metadataFile", "Choose Metadata File",
     #          accept = c("text/plain","text/tab-separated-values")
     #),

     shinyFilesButton('metadataFile', label='Browse...', title='Choose Metadata File', multiple=FALSE),
     p('First 5 lines of the metadata file:'),
     tableOutput("metadataTable"),
     checkboxInput("showSourceName", "show carbon source name instead of well ID", FALSE),
     h1('Single well comparison'),
     p('One statistical test is done for each well with detected growth in at least one group.'),
     div(style="width:1000px;padding-left:200px;",fluidRow(plotlyOutput("singleWellPlot"))),

     downloadButton("downloadDataSingleWell", "Download single well results"),


     h1('Clusters of chemically similar sources'),
     p('One statistical test is done for each carbon source cluster based on chemoinformatics analysis.'),
     p('It tests if sources in a cluster tend to exhibit more growth in one group.'),
     div(style="width:1000px;padding-left:200px;",fluidRow(plotlyOutput("chemoinfoPlot"))),
     downloadButton("downloadDatachemoinfo", "Download chemocluster results"),

     div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("selectedClusterInfoWell", placeholder = TRUE))),
     div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("selectedClusterInfoName", placeholder = TRUE))),
     div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("selectedClusterInfoKEGG", placeholder = TRUE))),

     h1('Carbon source categories'),
     p('One statistical test is done for each carbon source category based on manual curation.'),
     p('It tests if sources in a category tend to exhibit more growth in one group.'),
     div(style="width:1000px;padding-left:200px;",fluidRow(plotlyOutput("manualAnnoPlot"))),
     downloadButton("downloadDatamanualAnno", "Download carbon source categories results"),

     div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("selectedCatInfoWell", placeholder = TRUE))),
     div(style="width:1000px;padding-left:200px;margin-bottom:50px;",fluidRow(verbatimTextOutput("selectedCatInfoName", placeholder = TRUE)))

   )),
   # Group comparison panel - kinetics
   tabPanel("Analyis - kinetic analysis",mainPanel(
     p('In this panel, we provide statistical tools to compare groups of organisms'),

     h1('load Metadata (for more than 1 organism)'),
     p('Users should provide a metadata file with:'),
     p('- first column is organism name'),
     p('- second column is group name'),
     p('example provided in inst/extdata/metadata_PM1.txt'),

     #fileInput("metadataFileKine", "Choose Metadata File",
     #          accept = c("text/plain","text/tab-separated-values")
     #),
     shinyFilesButton('metadataFileKine', label='Browse...', title='Choose Metadata File', multiple=FALSE),
     p('First 5 lines of the metadata file:'),
     tableOutput("metadataTableKine"),
     checkboxInput("showSourceNameKine", "show carbon source name instead of well ID", FALSE),


     # choose which kinetic feature will be analyzed
     p('Please provide the kinetics feature wanted for the analysis. For more details on these features, refer to:'),
     uiOutput("tab"),
     radioButtons("kinefeature", "Kinetics feature:",
                  c( "Growth rate" = "r",
                    "Doubling time" = "t_gen",
                    "Carrying capacity" = "k",
                    "Time to exponential growth" = "t_mid")),

     #
     h1('Single well comparison'),
     p('One statistical test is done for each well with detected growth in at least one group.'),
     p('It tests if a well tends to exhibit more growth in one group.'),
     div(style="width:1000px;padding-left:200px;",fluidRow(plotlyOutput("singleWellPlotKine"))),

     downloadButton("downloadDataSingleWellKine", "Download single well results"),


     # h1('Clusters of chemically similar sources'),
      p('One statistical test is done for each carbon source cluster based on chemoinformatics analysis.'),
      p('It tests if sources in a cluster tend to exhibit more growth in one group.'),
      div(style="width:1000px;padding-left:200px;",fluidRow(plotlyOutput("chemoinfoPlotKine"))),
      downloadButton("downloadDatachemoinfoKine", "Download chemocluster results"),

      div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("selectedClusterInfoWellKine", placeholder = TRUE))),
      div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("selectedClusterInfoNameKine", placeholder = TRUE))),
      div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("selectedClusterInfoKEGGKine", placeholder = TRUE))),



      h1('Carbon source categories'),
      p('One statistical test is done for each carbon source category based on manual curation.'),
      p('It tests if sources in a category tend to exhibit more growth in one group.'),
      div(style="width:1000px;padding-left:200px;",fluidRow(plotlyOutput("manualAnnoPlotKine"))),
      downloadButton("downloadDatamanualAnnoKine", "Download carbon source categories results"),

     div(style="width:1000px;padding-left:200px;",fluidRow(verbatimTextOutput("selectedCatInfoWellKine", placeholder = TRUE))),
      div(style="width:1000px;padding-left:200px;margin-bottom:50px;",fluidRow(verbatimTextOutput("selectedCatInfoNameKine", placeholder = TRUE)))

   )),
   # Carbon source clustering
   tabPanel("Carbon source clustering",mainPanel(
     p('In this panel, we provide a visualization of the carbon sources clustering'),

     p('Each carbon source molecular features were downloaded from PubChem website'),
     p('We estimated similarity between carbon sources using Tanimoto distance on molecular fingerprints'),
     p('This interactive heatmap represents the groups we identified (different colors in the dendrogram)'),
     p('The brighter the heatmap is, the more similar two carbon sources are'),
     checkboxInput("showSourceName2", "show carbon source name instead of well ID", FALSE),
     fluidRow(plotlyOutput("heatmapPlot",width='1500px',height='1000px')) #div(style="width:1500px;min-height:1500px;",padding-left:200px;

   ))
  )
))
