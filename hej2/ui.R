
shinyUI(fluidPage(
	title = "hej SCB!",
	fluidRow(
		column(2, uiOutput("UI")),
		column(2, uiOutput("UI2")),
		column(2, uiOutput("UI3")),
		column(2, uiOutput("UI4")),
		column(4, uiOutput("goButton"))
	),
	
	hr(),
	
	fluidRow(
		column(2, uiOutput("metaDataSelectors"), uiOutput("dataButton")),
		column(8, showOutput("myChart", "polycharts")),
		column(2)
	)
))