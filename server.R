# baseUrl <- "http://api.scb.se/OV0104/v1/doris/sv/ssd"
# newUrl <- baseUrl
# menuItems <<- getLevels(newUrl)
grundtal <- reactiveValues(A=1,B=5)

shinyServer(function(input,output) {
	output$menu <- renderUI({
		selectInput("multiplier",
					"Multiplier",
					choices = (c(1:5)*grundtal$B),
					selected="10"
		)		
# 		selectInput("mainmenu",
# 					"Vaelj variabel",
# 					choices = menuItems,
# 					selected = menuItems[2]
# 		)
	})
	
	output$tabeller <- renderText({
		grundtal$A <- reactive({
			if(!is.null(input$multiplier)) {
				as.numeric(input$multiplier) + grundtal$A
			} else {
				grundtal$A
			}
		})
		as.character(grundtal$A)
	})
	
	newData <- reactive({
		if(!is.null(input$multiplier)) {
			as.numeric(input$multiplier) + grundtal$A
		} else {
			grundtal$A
		}
# 		as.numeric(input$multiplier)
# 		grundtal <<- grundtal * input$multiplier
		browser()
# 		newUrl <<- paste0(newUrl,input$mainmenu,"/")
# 		menuItems <<- getLevels(newUrl)
# 		newUrl <<- paste0(newUrl,"AM","/")
	})
})