
shinyServer(function(input, output) {
	
	
	
	## Variable selectors (top) ----
	
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
		if (is.null(input$myInput)) return()
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
		if (is.null(input$myInput2)) return()
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
		if (is.null(input$myInput3)) return()
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
		actionButton("fetchScbVar", "Get metadata")
	})
	
	
	
	## Metadata selectors (left) ----
	
	output$leftBar <- renderUI({

		if (!is.null(input$fetchScbVar)) { if (input$fetchScbVar > 0) {
# 			print(var_data())
			uiOutput("metaDataSelectors")
			uiOutput("dataButton")
		} else {
			return(NULL)
		}}
		
	})
	
	output$metaDataSelectors <- renderUI({
		# 		print(dims)
		if (is.null(input$fetchScbVar)) return()
		if (input$fetchScbVar == 0) return()
		isolate({ dims <- var_data()$dims })
		if (is.null(dims)) return()

		
		metadataSelectorList <- lapply(dims, function(i) {
			if (i$code != "Tid") {	return(
				bootstrapSelectInput(
					inputId = i$code,
					label = i$code,
					choices = c("*", i$values),
					subtext = c("", i$valueTexts),
					selected = "*",
					multiple = FALSE,
					options = list(
						width = "120px"
					)
				)
			)} else { return(
				sliderInput(
					inputId = i$code,
					label = i$code,
					value = c(as.numeric(min(i$values)), as.numeric(max(i$values))),
					min = as.numeric(min(i$values)),
					max = as.numeric(max(i$values)),
					format = "####",
					step = 1
				)
			)}
		})
		
		return(do.call(tagList, metadataSelectorList))
	})
	
	output$dataButton <- renderUI({
		actionButton("fetchScbData", "Get data")
	})
	
	
	
	## Data reactives ----
	
	var_data <- reactive({
		datavar <- ifelse(input$myInput4 == "", input$myInput3, input$myInput4)
		metadata <- scbGetMetadata(datavar)
		dims <- scbGetDims(metadata, verbose = FALSE)
				
		return(list(datavar=datavar, metadata=metadata, dims=dims))
	})
	
	main_data <- reactive({
			datadims <- lapply(var_data()$dims, function(i) {
				if (i$code != "Tid") {
					return(input[[i$code]])
				} else {
					return(as.character(input[[i$code]][1]:input[[i$code]][2]))
				}
			})
			names(datadims) <- unlist(lapply(var_data()$dims, function(i) i$code))
			# 		print(datadims)
# 			print(paste0("URL: ", var_data()$metadata$URL))
# 			print(datadims)
			
			scbData <- scbGetData(var_data()$metadata$URL, dims = var_data()$datadims, clean = TRUE)
			setnames(scbData, names(scbData)[ncol(scbData)], "varde")
			s_data <- copy(scbData)
			# Correct for "åäö" in data header
		
		return(s_data)
		
	})
	
	observe({
		if (is.null(input$fetchScbData)) return()
		if (input$fetchScbData == 0) return()
		
		input$fetchScbData
# 		print(input$fetchScbData)
		main_data()
	})
	
	observe({
		if (is.null(input$fetchScbVar)) return()
		if (input$fetchScbVar == 0) return()
		
		input$fetchScbVar
# 		print(input$fetchScbVar)
		var_data()
	})
	
	
	## Graph (center) ----
	output$myChart <- renderUI({
		if (!is.null(input$fetchScbData)) { if (input$fetchScbData > 0) {
			return(showOutput("rChart", "polycharts"))
		}} else {
			return(textOutput("chartText"))
		}
	})
	
	output$rChart <- renderChart({
		isolate({
			p1 <- rPlot("tid", "varde", data = main_data(), color = "variabel", 
						facets = "region", type = 'line')
			p1$addParams(dom = 'myChart')
			p1
		})
	})
	
	output$chartText <- renderPrint({
		'3. Click the "Get Data" button to display a graph.'
	})
		
	
# 	output$myChart <- renderPlot({
# 		if (!is.null(input$fetchScbData)) { if (input$fetchScbData > 0) {
# 			getData()
# 			print(s_data)
# 			
# 			p <- ggplot(s_data, aes_string(x="tid", y="varde", fill="variabel"
# 			)) + geom_point()
# 			print(p)
# 			
# 		}}
# 	})
})