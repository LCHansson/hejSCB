library(data.table)
library(shiny)
library(sparkle)
library(ggplot2)
library(rCharts)
shinyUI(fluidPage(
	fluidRow(
		column(2),
		column(2,
			   selectInput(inputId = "x",
			   			label = "Choose X",
			   			choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
			   			selected = "SepalLength"),
			   selectInput(inputId = "y",
			   			label = "Choose Y",
			   			choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
			   			selected = "SepalWidth")
		),
		column(8,
			   showOutput("myChart", "polycharts")
		)
	)
))