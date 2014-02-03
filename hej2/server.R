
shinyServer(function(input, output) {
	
	output$UI <- renderUI({
		menudata <- unique(hierarchy[,list(id_lv1, desc_lv1)])
		list(
			bootstrapSelectInput(
				inputId = "myInput",
				label = "",
				choices = menudata$id_lv1,
				subtext = menudata$desc_lv1,
				liveSearch = TRUE,
				options = list(
					width="150px"
				)
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
				subtext = menudata$desc_lv2,
				liveSearch = TRUE,
				options = list(
					width="150px"
				)
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
				subtext = menudata$desc_lv3,
				liveSearch = TRUE,
				options = list(
					width="150px"
				)
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
				subtext = menudata$desc_lv4,
				liveSearch = TRUE,
				options = list(
					width="150px"
				)
			)
		)
	})
	
	output$goButton <- renderUI({
		actionButton("fetchScbVar", "Hämta metadata")
	})
	
	
	## Metadata ----
	
	output$metaDataSelectors <- renderUI({
		getMetaData()
		
		metadataSelectorList <- lapply(dims, function(i) {
			bootstrapSelectInput(
				inputId = i$code,
				label = i$code,
				choices = c("*", i$values),
				subtext = c("", i$valueTexts),
				selected = "*",
				multiple = TRUE,
				options = list(
					width = "120px"
				)
			)
		})
		
		do.call(tagList, metadataSelectorList)
	})
	
	output$dataButton <- renderUI({
		actionButton("fetchScbData", "Hämta data")
	})
	
	
	## Data ----
	getMetaData <- reactive({
		datavar <<- ifelse(input$myInput4 == "", input$myInput3, input$myInput4)
		metadata <<- scbGetMetadata(datavar)
		dims <<- scbGetDims(metadata)
	})
	
	getData <- reactive({
		observe({
			input$fetchScbData
			
			isolate({
				datadims <- lapply(dims, function(i) {
					input[[i$code]]
				})
				names(datadims) <- unlist(lapply(dims, function(i) i$code))
				# 		print(datadims)
				print(paste0("URL: ", metadata$URL))
				print(datadims)
				s_data <<- scbGetData(metadata$URL, dims = datadims, clean = TRUE)
				# Correct for "åäö" in data header
				
			})
		})
	})
	
	
	## Graph ----
	output$myChart <- renderChart({
		if (!is.null(input$fetchScbData)) { if (input$fetchScbData > 0) {
			getData()
			print(s_data)
			p1 <- rPlot("värde", "tid", data = s_data, color = "variabel", 
						facet = "region", type = 'point')
			p1$addParams(dom = 'myChart')
			return(p1)
		}}
		NULL
	})
})