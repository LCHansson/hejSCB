
shinyUI(fixedPage(
	# 	title = "hej SCB!",
	
	tags$script(
		type = "text/javascript",
		"$(function() { // Run when DOM ready
			$(window).bind('beforeunload', function(e) {
				Shiny.onInputChange('quit', true); // sets input$quit to true
			});
		});"
	),
	
	titlePanel("Hej SCB!"),
	
	fixedRow(
		column(1),
		column(2, uiOutput("UI")),
		column(2, uiOutput("UI2")),
		column(2, uiOutput("UI3")),
		column(2, uiOutput("UI4")),
		column(2, uiOutput("goButton")),
		column(1)
	),
	
	hr(),
	
	fixedRow(
		column(1),
		# 		column(10, uiOutput("metadataBar")),
		uiOutput("metadataBar"),
		column(1)
	),
	
	hr(),
	
	fixedRow(
		column(1),
		column(10, uiOutput("scbChart")),
# 		column(8, plotOutput("myChart")),
		column(1)
	)
))