
shinyServer(function(input, output, session) {
	
	
	
	## Reactive internals ------------------------------------------------------
	
	var_data <- reactive({
		datavar <- ifelse(
			input$myInput4 == "",
			hierarchy[id_lv3 == input$myInput3, URL_lv3],
			hierarchy[id_lv4 == input$myInput4, URL_lv4]
		)
		metadata <- scbGetMetadata(datavar)
		dims <- scbGetDims(metadata, verbose = FALSE)
		
		return(list(datavar=datavar, metadata=metadata, dims=dims))
	})
	
	main_data <- reactive({
		input$fetchScbData
		
		isolate({
			dims <- var_data()$dims
			datadims <- lapply(dims, function(i) {
				if (i$code != "Tid") {
					return(input[[i$code]])
				} else {
					return(as.character(input[[i$code]][1]:input[[i$code]][2]))
				}
			})
			names(datadims) <- unlist(lapply(dims, function(i) i$code))
# 			print(datadims)
			
			scbData <- scbGetData(var_data()$metadata$URL, dims = datadims, clean = TRUE)
			setnames(scbData, names(scbData)[ncol(scbData)], "varde")
			
			return(scbData)
		})
	})
	
	get_varcode <- reactive({
		codename <- sapply(var_data()$dims, function(dim) {if(dim$code == input$compareTSVar) return(dim$text) else return(NA) } )
		codename <- codename[complete.cases(codename)]
		
		return(codename)
	})
	
	observe({
		if (is.null(input$fetchScbVar)) return()
		if (input$fetchScbVar == 0) return()
		
		input$fetchScbVar
		var_data()
	})	
	
	observe({
		if (is.null(input$fetchScbData)) return()
		if (input$fetchScbData == 0) return()
		
		input$fetchScbData
		main_data()
	})
	
	
	
	## Variable selectors (1st row) --------------------------------------------
	
	output$UI <- renderUI({
		menudata <- unique(hierarchy[,list(id_lv1, description_lv1)])
		list(
			bootstrapSelectInput(
				inputId = "myInput",
				label = "",
				choices = menudata$id_lv1,
				subtext = menudata$description_lv1,
				options = list(
					width="150px"
				)
			)
		)
	})
	output$UI2 <- renderUI({
		if (is.null(input$myInput)) return()
		menudata <- unique(hierarchy[id_lv1 %in% input$myInput, list(id_lv2, description_lv2)])
		list(
			bootstrapSelectInput(
				inputId = "myInput2",
				label = "",
				choices = menudata$id_lv2,
				subtext = menudata$description_lv2,
				liveSearch = FALSE,
				options = list(
					width="150px"
				)
			)
		)
	})
	output$UI3 <- renderUI({
		if (is.null(input$myInput2)) return()
		menudata <- unique(hierarchy[id_lv2 %in% input$myInput2, list(id_lv3, description_lv3)])
		list(
			bootstrapSelectInput(
				inputId = "myInput3",
				label = "",
				choices = menudata$id_lv3,
				subtext = menudata$description_lv3,
				liveSearch = TRUE,
				options = list(
					width="150px"
				)
			)
		)
	})
	output$UI4 <- renderUI({
		if (is.null(input$myInput3)) return()
		menudata <- unique(hierarchy[id_lv3 %in% input$myInput3, list(id_lv4, description_lv4)])
		list(
			bootstrapSelectInput(
				inputId = "myInput4",
				label = "",
				choices = menudata$id_lv4,
				subtext = menudata$description_lv4,
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
	
	
	
	## Metadata selectors (2nd row) --------------------------------------------
	
	output$metadataBar <- renderUI({
		if (is.null(input$fetchScbVar)) return()
		if (input$fetchScbVar == 0) {
			uiList <- list(textOutput("leftText"))
		} else {
			uiList <- list(
				uiOutput("metaDataSelectors"),
				uiOutput("dataButton")
			)
		}
		
		do.call(tagList, uiList)
	})
	
	output$leftText <- renderText({
		'2. Select a variable above and click "Get Metadata".'
	})
	
	output$metaDataSelectors <- renderUI({
		dims <- var_data()$dims
		# Initialization error handling
		if (is.null(dims)) return()
		
		# Columns should be as wide as they have to be to accomodate all 
		# metadata selectors. 
		ncols <- length(dims)
		colwidth = 2
		
		# Create controls
		metadataSelectorList <- lapply(1:ncols, function(n) {
			i <- dims[n][[1]]
			if (i$code != "Tid") {	return(
				column(
					colwidth,
					bootstrapSelectInput(
						inputId = i$code,
						label = i$code,
						choices = c(i$values, "*"),
						subtext = c(i$valueTexts, "*"),
						selected = i$values[1],
						multiple = TRUE,
						options = list(
							width = "120px"
						)
					)
				)
			)} else { return(
				column(
					colwidth,
					sliderInput(
						inputId = i$code,
						label = i$code,
						value = c(as.numeric(min(i$values)), as.numeric(max(i$values))),
						min = as.numeric(min(i$values)),
						max = as.numeric(max(i$values)),
						format = "####",
						step = 1
					)
				)
			)}
		})
		
		# 		if (ncols < 4)
		# 			metadataSelectorList <- append(metadataSelectorList, list(column(2*(4 - ncols))))
		# 		browser()
		
		
		# 		metadataSelectorList <- lapply(dims, function(i) {
		# 			if (i$code != "Tid") {	return(
		# 				bootstrapSelectInput(
		# 					inputId = i$code,
		# 					label = i$code,
		# 					choices = c(i$values, "*"),
		# 					subtext = c(i$valueTexts, "*"),
		# 					selected = i$value[1],
		# 					multiple = TRUE,
		# 					options = list(
		# 						width = "120px"
		# 					)
		# 				)
		# 			)} else { return(
		# 				sliderInput(
		# 					inputId = i$code,
		# 					label = i$code,
		# 					value = c(as.numeric(min(i$values)), as.numeric(max(i$values))),
		# 					min = as.numeric(min(i$values)),
		# 					max = as.numeric(max(i$values)),
		# 					format = "####",
		# 					step = 1
		# 				)
		# 			)}
		# 		})
		
		# 		return(do.call(tagList, metadataSelectorList))
	})
	
	output$dataButton <- renderUI({
		column(2, actionButton("fetchScbData", "Get data"))
	})
	
	
	
	## Graph (center) ----------------------------------------------------------
	
	## Chart container
	output$scbChart <- renderUI({
		if (is.null(input$fetchScbData)) return()
		if (input$fetchScbData == 0) {
			return(textOutput("chartText"))
		} else {
			return(tabsetPanel(
				tabPanel("Tidsserier", showOutput("timeSeries", "nvd3"), uiOutput("timeSeriesControls")),
				tabPanel("Ladda hem data"),
				id = "chartPanel",
				type = "pills"
			))
		}
	})
	
	## Filler text (before the graph is drawn)
	output$chartText <- renderText({
		'3. Click the "Get Data" button to display a graph.'
	})
	
	## Time series graph
	output$timeSeries <- renderChart2({
		plotdata <- main_data()
		# 		p1 <- rPlot("tid", "varde", data = plotdata, color = "region", 
		# 					facet = "region", type = 'line')
		# 		p1$addParams(dom = 'myChart')
		# 		p1
		
		# 		print(input$compareTSVar)
		# Find the variable to pivot by
		codename <- sapply(var_data()$dims, function(dim) {
			if(dim$code == input$compareTSVar) return(dim$text) else return(NA)
		})
		codename <- codename[complete.cases(codename)]
		codename <- str_replace(codename, "å", "\u00e5")
		print(codename)
		# 		browser()
		
		# Define and draw graph
		n1 <- nPlot(varde ~ tid, data = plotdata, group = codename, type="lineChart", dom = 'rChart')
		n1
	})
	
	output$timeSeriesControls <- renderUI({
		dims <- var_data()$dims
		dimnames <- na.omit(sapply(dims, function(dim) {
			if (dim$code != "Tid")
				return(dim$code)
			else
				return(NA)
		}))
		
		bootstrapSelectInput(
			inputId = "compareTSVar",
			label = "Jämförelsevariabel",
			choices = dimnames,
# 			subtext = c(i$valueTexts, "*"),
			selected = dimnames[1],
			multiple = FALSE,
			options = list(
				width = "120px"
			)
		)
	})
	
	
	
	
	# 	output$myChart <- renderPlot({
	# 		if (!is.null(input$fetchScbData)) { if (input$fetchScbData > 0) {
	# 			getData()
	# 			
	# 			p <- ggplot(s_data, aes_string(x="tid", y="varde", fill="variabel"
	# 			)) + geom_point()
	# 			print(p)
	# 			
	# 		}}
	# 	})
})