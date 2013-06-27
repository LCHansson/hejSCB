shinyUI(basicPage(
	
	#### <HEAD> ####
	tagList(
		tags$head(
			tags$title("Hej SCB!")
		)
	),
	
	#### <BODY> ####
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