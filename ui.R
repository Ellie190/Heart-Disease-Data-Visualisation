# source("utils/loadpackages.R")
library(shinydashboard)
library(shiny)
library(stringr)
library(tidyverse)
library(scales)
library(ggplot2)
library(plotly)
library(knitr)
library(DT)
library(rpivotTable)
library(openintro)
library(tidyr)
library(rlang)
library(shinycssloaders)
library(flexdashboard)

#  Adding image or logo along with the title in the header (must be in www folder)
title <- tags$a(href='https://en.wikipedia.org/wiki/Cardiovascular_disease',
                tags$img(src="logo.png", height = '45', width = '50',
                         style = "top:0;left:0;bottom:0;"),
                'Heart Disease', 
                target="_blank")

# background image 
bgImg <- tags$img(src = "background.jpg",
                  style = "position: absolute;
                           height:100%;width:100%")

dashboardPage(skin = "black", title = "HD Analytics",
              dashboardHeader(title = title, titleWidth = 250), # end of header 
              dashboardSidebar(disable = TRUE), # end of side bar 
              dashboardBody(
                tags$head(
                  tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
                ),
                bgImg,
                fluidRow(
                  box(title = "Comparison of patient indicators", status = "danger",solidHeader = TRUE,
                      collapsible = TRUE, width = 8,
                      withSpinner(plotlyOutput("heart_fig1"))),
                  box(title = "Indicator", status = "danger", solidHeader = TRUE,
                      collapsible = TRUE, width = 4,
                      uiOutput("sel_1"), h3("Info"), 
                      "The Comparison graph(s) provides insights on how heart disease % varies between symptoms or 
                       categories. % of Guage is Based on:
                       The number of patients with heart disease divided by total population",
                      gaugeOutput("heart_pct"),
                      
                  )
                ),
                fluidRow(
                  box(title = "Distribution of patient indicators", status = "danger", solidHeader = TRUE,
                      collapsible = TRUE, width = 8, collapsed = TRUE,
                      withSpinner(plotlyOutput("heart_fig2"))),
                  box(title = "Indicator", status = "danger", solidHeader = TRUE, collapsed = TRUE,
                      collapsible = TRUE, width = 4,
                      selectInput("select_2", label = h3(""),
                                  choices = c("`Age`",
                                              "`Resting blood pressure (in mm Hg on admission to the hospital)`",
                                              "`Serum cholestoral in mg/dl`",
                                              "`Maximum heart rate achieved`",
                                              "`ST depression induced by exercise relative to rest`"),
                                  selected = "`Age`"), h3("Info"),
                      "The violin chart provides insights on how the data is spread/distributed across patients that 
                      have/do not have heart disease for a particular indicator of insterest")
                ),
                fluidRow(
                  box(title = "Relationship between patient indicators", status = "danger", solidHeader = TRUE,
                      collapsible = TRUE, width = 8, collapsed = TRUE,
                      withSpinner(plotlyOutput("heart_fig3"))),
                  box(title = "Indicator", status = "danger", solidHeader = TRUE, collapsed = TRUE,
                      collapsible = TRUE, width = 4, h3("Horizontal Indicator (X-axis)"),
                      uiOutput("sel_3"), h3("Vertical Indicator (Y-axis)"), uiOutput("sel_4"), 
                      "The chart on X vs Y provides insights on the relationships the inidcators have with one another.
                       The strenght of the relationship(s) can help select significant indicators to predict patients
                       with heart disease or avoid multicollinearity")
                )
                
                
              ) # end of body 
) # end of page