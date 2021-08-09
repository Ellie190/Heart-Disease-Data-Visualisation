server <- function(input, output, session) {
  
  # Read data 
  hd_df <- read.csv("Heart_Data.csv")
  
  # Removing the first column 
  hd_df <- hd_df[,2:ncol(hd_df)]
  
  # Renaming columns 
  names(hd_df)[names(hd_df) == "age"] <- "Age"
  names(hd_df)[names(hd_df) == "sex"] <- "Sex"
  names(hd_df)[names(hd_df) == "cp"] <- "Chest pain type"
  names(hd_df)[names(hd_df) == "trestbps"] <- "Resting blood pressure (in mm Hg on admission to the hospital)"
  names(hd_df)[names(hd_df) == "chol"] <- "Serum cholestoral in mg/dl"
  names(hd_df)[names(hd_df) == "fbs"] <- "Fasting blood sugar > 120 mg/dl"
  names(hd_df)[names(hd_df) == "restecg"] <- "Resting electrocardiography results"
  names(hd_df)[names(hd_df) == "thalach"] <- "Maximum heart rate achieved"
  names(hd_df)[names(hd_df) == "exang"] <- "Exercise induced angina"
  names(hd_df)[names(hd_df) == "oldpeak"] <- "ST depression induced by exercise relative to rest"
  names(hd_df)[names(hd_df) == "slope"] <- "The slope of the peak exercise ST segment"
  names(hd_df)[names(hd_df) == "ca"] <- "Number of major vessels colored by fluoroscopic"
  names(hd_df)[names(hd_df) == "thal"] <- "Status of the heart"
  names(hd_df)[names(hd_df) == "target"] <- "Heart Disease"
  
  # Percent of Heart Disease Patients 
  heart_cal <- hd_df %>% 
    filter(`Heart Disease` == "Yes") %>% 
    count()/nrow(hd_df)*100
  
  output$heart_pct <- renderGauge({
    gauge(round(heart_cal$n, 0), min = 0, max = 100, symbol = '%', label = "Heart Disease Patients",
          gaugeSectors(
            success = c(0, 9), warning = c(10, 25), danger = c(26, 100)
          ))
  })
  
  # Comparison Analysis 
  
  output$sel_1 <- renderUI({
    varSelectInput("select_1", label = h4(" "),
                   hd_df[, -c(1,4,5,8,10,14)], selected = hd_df[1])
  })
  
  output$heart_fig1 <- renderPlotly({
    req(input$select_1)
    
    comdata <- hd_df %>% 
      group_by(!!input$select_1, `Heart Disease`) %>% 
      summarise(n = n()) %>% 
      mutate(percent = n/sum(n), 
             lbl = scales::percent(percent))
    
    cplot <- comdata %>% 
      ggplot(aes(x = reorder(!!input$select_1, -n),
                 y = percent, fill = `Heart Disease`)) +
      geom_bar(stat = "identity",
               position = "dodge") +
      # geom_text(aes(label = lbl),
      #           vjust = -0.25,
      #           nudge_x = -0.15) +
      scale_y_continuous(labels = percent) +
      labs(x = "", y = "",
           title = paste0(input$select_1, ""),
           fill = "Positive") +
      scale_fill_manual(values = c("green", "red")) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45))
    
    ggplotly(cplot)
  })
  
  
  
  # Distribution Analysis 
  output$heart_fig2 <- renderPlotly({
    req(input$select_2)
    fig <- hd_df %>%
      plot_ly(
        x = ~`Heart Disease`,
        y = as.formula(paste0('~', input$select_2)), 
        split = ~`Heart Disease`,
        type = 'violin',box = list(visible = T), meanline = list(visible = T), 
        colors = c("green", "red"), color = ~`Heart Disease`)  %>%
      layout(
        title = paste0(input$select_2, " "),
        xaxis = list(title = "Positive"),
        yaxis = list(title = "",zeroline = F))
    
    fig
  })
  
  # Relationship Analysis 
  
  # Change hd_df to hd_df[, c(1,4,5,8,10)] for only Numerical Variables
  output$sel_3 <- renderUI({
    varSelectInput("select_3", label = h4(" "),
                   hd_df, selected = hd_df[1]) 
  })
  
  # Change hd_df to hd_df[, c(1,4,5,8,10)] for only Numerical Variables
  output$sel_4 <- renderUI({
    varSelectInput("select_4", label = h4(" "),
                   hd_df, selected = hd_df[2]) 
  })
  
  output$heart_fig3 <- renderPlotly({
    req(input$select_3)
    req(input$select_4)
    
    rplot <- hd_df %>% 
      ggplot(aes(x=!!input$select_3, y = !!input$select_4,
                 color = `Heart Disease`)) + 
      scale_color_manual(values=c("green", "red")) +
      geom_point(size=2) +
      labs(color = "Positive",
           y = "Y-axis",
           x = "X-axis") +
      theme_minimal()
    
    ggplotly(rplot)
  })
}