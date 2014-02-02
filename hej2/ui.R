
shinyUI(fluidPage(
	fluidRow(
		column(3, uiOutput("UI")),
		column(3, uiOutput("UI2")),
		column(3, uiOutput("UI3")),
		column(3, uiOutput("UI4"))
	)
))