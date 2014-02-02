
shinyServer(function(input, output) {
	
	output$UI <- renderUI({
		menudata <- unique(hierarchy[,list(id_lv1, desc_lv1)])
		list(
			bootstrapSelectInput(
				inputId = "myInput",
				label = "",
				choices = menudata$id_lv1,
				subtext = menudata$desc_lv1
			)
		)
	})
	output$UI2 <- renderUI({
		menudata <- unique(hierarchy[id_lv1 %in% input$myInput, list(id_lv2, desc_lv2)])
		list(
			bootstrapSelectInput(
				inputId = "myInput2",
				label = "",
				choices = menudata$id_lv2,
				subtext = menudata$desc_lv2
			)
		)
	})
	output$UI3 <- renderUI({
		menudata <- unique(hierarchy[id_lv2 %in% input$myInput2, list(id_lv3, desc_lv3)])
		list(
			bootstrapSelectInput(
				inputId = "myInput3",
				label = "",
				choices = menudata$id_lv3,
				subtext = menudata$desc_lv3
			)
		)
	})
	output$UI4 <- renderUI({
		menudata <- unique(hierarchy[id_lv3 %in% input$myInput3, list(id_lv4, desc_lv4)])
		list(
			bootstrapSelectInput(
				inputId = "myInput4",
				label = "",
				choices = menudata$id_lv4,
				subtext = menudata$desc_lv4
			)
		)
	})
})