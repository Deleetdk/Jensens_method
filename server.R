
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(plyr)
library(reshape)
library(scales)
library(DT)
library(stringr)

shinyServer(function(input, output) {
  
  #reactive dataset
  reac_d = reactive({
    g_loadings = c(.50, .60, .75,
                   .65, .70, .55,
                   .80, .45, .30)
    
    group1_loadings = c(.50, .50, .50,
                        0, 0, 0,
                        0, 0, 0)
    
    group2_loadings = c(0, 0, 0,
                        .50, .50, .50,
                        0, 0, 0)
    
    group3_loadings = c(0, 0, 0,
                        0, 0, 0,
                        .50, .50, .50)
    
    d = data.frame(g_loadings,
                   group1_loadings,
                   group2_loadings,
                   group3_loadings)
    
    d$specificity = apply(d, 1, function(x) {
      var_g_group = sum(x^2)
      var_remain = 1 - var_g_group
      loading_specificity = sqrt(var_remain)
      return(loading_specificity)
    }
    )
    
    d$time_1 = rep(100, nrow(d))
    
    d$time_2 = d$time_1 + 
      input$g_change * g_loadings + 
      input$group1_change * d$group1_loadings +
      input$group2_change * d$group2_loadings +
      input$group3_change * d$group3_loadings +
      input$specificity_change * d$specificity
    
    d$change = d$time_2 - d$time_1
    
    return(d)
  })
  
  #long version, reactive
  reac_d_long = reactive({
    #fetch data
    d = reac_d()
    
    d_long = data.frame(time_1 = d$time_1,
                        time_2 = d$time_2,
                        indicator = str_c("I", 1:9))
    
    d_long = melt(d_long, id.vars = "indicator")
    
    return(d_long)
  })
  
  #before and after means
  output$plot <- renderPlot({
    
    #fetch data
    d_long = reac_d_long()

    #plot
    ggplot(d_long, aes(indicator, value, fill = variable, group = variable)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_y_continuous(breaks = seq(0, 200, 10),
                         limits=c(80, NA),
                         oob = rescale_none) +
      scale_fill_discrete(labels = c("Time 1", "Time 2")) +
      xlab("Indicator variables") + ylab("Score")
    
  })
  
  # Jensen's method scatter plot
  output$plot2 = renderPlot({
    #fetch data
    d = reac_d()
    d$time_1 = NULL
    d$time_2 = NULL
    change = d$change
    d$change = NULL
    
    d_long2 = melt(d)
    d_long2$change = rep(change, length = nrow(d_long2))

    
    #plot
    ggplot(d_long2, aes(value, change, color = variable)) +
      geom_point() +
      geom_smooth(method = "lm", se = F, fullrange = T, linetype = "dashed") +
      scale_color_discrete(labels = c("general factor", 
                           "group factor 1",
                           "group factor 2",
                           "group factor 3",
                           "specificity")
                           ) +
      xlab("Factor loading") + ylab("Change in scores") +
      scale_x_continuous(breaks = seq(0, 1, .05))
    
  })
  
  output$table = DT::renderDataTable({
    #fetch data
    d = reac_d()
    d$time_1 = NULL
    d$time_2 = NULL
    colnames(d) = c("general factor", "group factor 1", "group factor 2", "group factor 3",
                           "specificity", "change")
    
    cor = round(cor(d), 2)
    cor = as.data.frame(cor)
    return(cor)
  },
  options = list(searching = F,
                 ordering = F,
                 paging = F,
                 info = F))

})
