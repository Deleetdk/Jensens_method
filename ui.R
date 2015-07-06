
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Jensen's method"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("g_change",
                  "Change in general factor",
                  min = -30,
                  max = 30,
                  value = 10),
      sliderInput("group1_change",
                  "Change in group 1 factor",
                  min = -30,
                  max = 30,
                  value = 5),
      sliderInput("group2_change",
                  "Change in group 2 factor",
                  min = -30,
                  max = 30,
                  value = 0),
      sliderInput("group3_change",
                  "Change in group 3 factor",
                  min = -30,
                  max = 30,
                  value = 0),
      sliderInput("specificity_change",
                  "Change in all specificity factors",
                  min = -30,
                  max = 30,
                  value = 0)
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      HTML("<p>Jensen's method, also known as method of correlated vectors (MCV), is a method for examining how factors are related to a criteria variable (a variable of interest or a vector of related variables). One can only use it when one has more than one indicator (measure) of a factor. The general idea is that the indicators vary in how well they measure the factor (their factor loadings differ), thus if there is a relationship between the factor and the other variable, then the indicators that are the better measures of the factor should relate more strongly to the criteria variable too.</p>",
           "<p>In this visualization we will consider a situation where the same indicators are measured twice with some time in between. This could be a repeated measurement within individuals after some experimental intervention, or different individuals. Based on this, we calculate how much each indicator changed between the measurements (our criteria variable), and then how these changes relate to the factor loadings on the indicators.</p>",
           "<p>Since the concept is somewhat complex, I have split the visualization into 4 tabs which you can explore as you like, but you probably want to read the first tab now. Each of them have their own description. By the default settings, we stipulate that the general factor (g) increases by 10 points and group factor 1 (F1) increases by 5 while the remaining factors do not increase at all. Click the second tab to see how this affects the scores on the 9 indicators. They all go up, but not by the same amount. Now click the third tab to see how the indicator changes relate to the indicator loadings for each factor. We see that two of them are positive, which happens to be the same two that we actually increased. The fouth tab shows just how strong the relationships are (Jensen coefficients).</p>"),
      HTML("<p>However, the Jensen coefficients do not always reflect which factors were increased. For instance, try changing the increase in g to 0. Note how the relationship between the g loadings and the increases in scores is still slightly positive. This is because the loadings on the g factor are correlated with the loadings on F1, creating a spuriously positive result. It can get worse. Try setting the increase on F1-F3 to 2, 4, 8 and the rest to 0. Notice how we get a large positive coefficient for F1, but slightly negative for F2 and a strong negative for F3! This is despite that all three actually increased. Worse, the coefficient for g is positive despite it not increasing at all. Clearly, one must be very careful in interpreting results like these.</p>",
           "<p>Play around with the sliders to get a feel for how the results look like given different changes in the factors. Results are not always as expected!</p>"),
      tabsetPanel(
        tabPanel("Structure",
                  HTML("For the purpose of this visualization, a relatively simple scenario was created. There are 9 indicator variables each of which measure in part a general factor, a group factor and a specificity factor which is variance specific to each indicator (in reality, this factor also includes error of measurement, but we will ignore that for this visualization). Circles are factors (latent variables) while boxes are observed variables. g is the general factor, F1-F3 are the group factors, and the small circles with no names are the specificities. The dashed lines represent the relationships between the indicator variables and the criteria variable vector. The numbers on the lines are the factor loadings.</p>"),
                  HTML("<img src='structure.png'>")
        ),
        tabPanel("Indicator score changes",
                HTML("<p>The bar plot below shows the scores on each indicator variable at the first and second measurement.</p>"),
                plotOutput("plot")
        ),
        tabPanel("Scatter plot",
                   HTML("<p>The scatter plots below show the Jensen correlations, that is, the correlations between the factor loadings and the change in scores between the two measurements.</p>"),
                   plotOutput("plot2")
        ),
        tabPanel("Correlation matrix",
                 HTML("<p>The table below shows the correlations between the factor loadings and the change in indicator scores. The exact Jensen coefficients are shown in the row/column <em>change</em>.</p>"),
                 DT::dataTableOutput("table")
        )
      ),
      HTML("Made by <a href='http://emilkirkegaard.dk'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'/>Shiny</a> for <a href='http://en.wikipedia.org/wiki/R_%28programming_language%29'>R</a>. Source code available on <a href='https://github.com/Deleetdk/Jensens_method'>Github</a>.")
    )
  )
))
