shinyUI(basicPage(
	
	#### <HEAD> ####
	tagList(
		tags$head(
			tags$title("Hej SCB!"),
			tags$link(rel="stylesheet", type="text/css",
					  href="style.css")
		)
	),
	
	#### <BODY> ####
	
	includeHTML("www/js/tools.js"),
	
	#### Menu row ####
	div(class="row",
		div(class="span10",
			uiOutput("menu"),
			submitButton("Uppdatera"),
			textOutput("tabeller")
		)
	),
	
	HTML("<hr>")
	
))