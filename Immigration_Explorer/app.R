#
# this is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(markdown)
library(shiny)
library(ggplot2)
library(dplyr)
library(moderndive)
library(broom)
library(htmltools)
library(vembedr)
library(tidyverse)

# read clean data into Shiny

english_continent <- read_csv("data/english_continent.csv")
                             
english_country <- read_csv("data/english_country.csv")

employment_country <- read_csv("data/employment_country.csv")
                            
immigration_continent <- read_csv("data/immigration_continent.csv")
                                
immigration_continent_long <- read_csv("data/immigration_continent_long.csv")

immigration_country <- read_csv("data/immigration_country.csv")

immigration_country_long <- read_csv("data/immigration_country_long.csv")

# get datasets ready for regression

# add work visa percentage
immigration_country_regression <- immigration_country %>%
  mutate(work_visa_percent = employment/total) 

# filter out South Korea from regression, add employment column

employment_country_regression <- employment_country %>%
  filter(country != "Korea, South") %>%
  mutate(employment_in_laborforce = 1- unemployment_rate_unemployed_labor_force)

english_country_regression <- english_country %>%
  filter(country != "Korea, South")

# join datasets to prepare for regression

immigration_employment_combined <- left_join(employment_country_regression, immigration_country_regression, 
                                             by = c("country", "year"))

immigration_language_combined <- left_join(english_country_regression, immigration_country_regression, 
                                           by = c("country", "year"))


# percent function for formatting
percent <- function(x, digits = 1, format = "f", ...) {
    paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}


#sliderInput("year", "Year:",
# min = 2007, max = 2017,
# value = 2007),
#plotOutput("barchart")
                            
# define UI for application that draws a histogram
# create Navigation bar for both overview and by country
# create an input for selecting specific country to examine

ui<- navbarPage("Gov1005 Final Project: US Immigration Explorer",
                
                tabPanel("Overview",
                         
                        fixedRow(
                          column(12,align = "center",
                                 includeMarkdown("md/panel1_opening.md"))
                         ),
                        
                        fixedRow(
                          hr(),
                          column(3,align = "center",
                               includeMarkdown("md/panel1_p1.md")),
                          column(9,
                               imageOutput("map_overall"))
                          ),
                        
                        fixedRow(
                          column(4, align = "center",
                                 imageOutput("top10_gif"),
                                 br()),
                          column(8, align = "center",
                                 br(),
                                 br(),
                                 br(),
                                 imageOutput("top10_flag"))
                        
                        ),
                        
                        fixedRow(
                          hr(),
                          column(3,align = "center",
                                 includeMarkdown("md/panel1_p2.md")),
                          column(9,
                                 br(),
                                 imageOutput("map_percap"))
                        )
                        ),
                
                tabPanel("A Closer Look",
                         headerPanel("Closer Look into Top 10 Source Countries: Select One You are Interested In"),
                         br(),
                          fixedRow(
                          column(8, align="center",
                          selectInput("variable", "Country:",
                                                list("Mexico" = "Mexico",
                                                     "China, People's Republic" = "China, People's Republic", 
                                                     "India" = "India",
                                                     "Philippines" = "Philippines",
                                                     "Dominican Republic" = "Dominican Republic",
                                                     "Cuba" = "Cuba",
                                                     "Vietnam" = "Vietnam",
                                                     "Colombia" = "Colombia",
                                                     "Haiti" = "Haiti",
                                                     "Jamaica" = "Jamaica")),
                         plotOutput("trendchart")),
                         column(4, align = "center",
                                includeMarkdown("md/panel2_p1.md")
                        ),
                        fixedRow(
                          column(12,align = "center",
                                 hr(),
                                 includeMarkdown("md/panel2_p2.md"))
                        ),
                        fixedRow(
                          column(4,align = "center",
                                 plotOutput("donut_language")),
                          column(4,align = "center",
                                 plotOutput("donut_labor")),
                          column(4,align = "center",
                                 plotOutput("donut_employment"))
                        )),
                        fixedRow(
                          column(12, align = "center",
                                 includeMarkdown("md/panel2_p3.md"))
                        )
                        ),
                tabPanel("Story",
                         headerPanel("Is Admission Class a Good Indicator of How US immigrants Are Performing After the Entrance?"),
                         br(),
                         fixedRow( 
                           column(4,align = "left",
                                          includeMarkdown("md/panel3_p1.md")),
                           column(8, align = "left",
                                  plotOutput("story_1"),
                                  tableOutput("model_table_1"),
                                  tableOutput("model_table_1_2"))
                         ),
                         fixedRow( 
                           hr(),
                           column(4,align = "left",
                                  includeMarkdown("md/panel3_p2.md")),
                           column(8, align = "left",
                                 plotOutput("story_2"),
                                 tableOutput("model_table_2"),
                                 tableOutput("model_table_2_2"))
                         ),
                         fixedRow(
                           hr(),
                           column(4,align = "left",
                                  includeMarkdown("md/panel3_p3.md")),
                           column(8, align = "left",
                                  plotOutput("story_3"),
                                  tableOutput("model_table_3"),
                                  tableOutput("model_table_3_2"))
                           
                         )),

                tabPanel("About",
                         column(12,align = "left",
                                includeMarkdown("md/panel4_p1.md"),
                                embed_vimeo("378216482"))
                )
)


# define server
server <- function(input, output, session){

  
  
  # render the gif image
  
  output$top10_gif <- renderImage(
    list(src = "image/top_10.gif"),
    deleteFile = FALSE
  )
  
  # render the flag image
  
  output$top10_flag <- renderImage(
    list(src = "image/countries_top10.png",
         width = 800),
    deleteFile = FALSE
  )
  

  # render the overall map image
  
  output$map_overall <- renderImage(
    list(src = "image/map_overall.png",
         width = 1000),
    deleteFile = FALSE
  )
  
  # render the perCap map image
  
  output$map_percap <- renderImage(
    list(src = "image/map_percap.png",
         width = 1000),
    deleteFile = FALSE
  )
  
  
  # render the bar chart on the opening page
  
  output$barchart <- renderPlot({
    
    # filter down to top 20 countries in a particular year
    immigration_current10 <- immigration_country %>%
                                          filter(year == as.numeric(input$year)) %>%
                                          arrange(desc(total)) %>%
                                          head(20)
    
    # create bar chart
    # if reorder, use x = reorder(country, -total)
    barchart <- ggplot(immigration_current10, 
                       aes(x = country, y = total)) + 
      geom_col(aes(fill = total)) + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
      scale_fill_gradient2(low = "blue", high = "red", midpoint = median(immigration_current10$total)) +
      labs(x = "Country", y = "Total Immigrants",title = paste0("20 Source Countries with Most Immigrants into US in ", input$year))
      
    # return image
    
    print(barchart)
    
  })
  
  
# render the regression chart for labor force versus work visa percentage
  
  output$story_1 <- renderPlot({
    
    regression_1 <- ggplot(immigration_employment_combined, 
                           aes(y = percentage_in_labor_force, x = work_visa_percent)) + 
      geom_jitter() +
      geom_smooth(method = "loess") +
      scale_y_continuous(labels = scales::percent) +
      scale_x_continuous(labels = scales::percent) +
      labs(title = "Labor Force Percentage in relationship to Work Visa Percentage",
           subtitle = "for the top 10 US immigration source countries, 2007 - 2017, each point is a country in a particular year",
           y = "% in Labor Force",
           x = "% entering through Work Visa",
           caption = "Data Source: Homeland Security and US Census Bureau")
    
    print(regression_1)
    
  })
  
  # create regression table for the 1st graph
  
  model_1 <- lm(percentage_in_labor_force ~ work_visa_percent, data = immigration_employment_combined)
  model_table_1 <- get_regression_table(model_1)
  model_1_glance <- as.data.frame(glance(model_1))
  
  # render the linear regression table
  
  output$model_table_1 <- renderTable(model_table_1)
  
  # render the r^2 table
  
  output$model_table_1_2 <- renderTable(model_1_glance)
  
  # render the regression chart for employment versus work visa
  
  output$story_2 <- renderPlot({
    
    regression_2 <-   ggplot(immigration_employment_combined, mapping = aes(y = employment_in_laborforce, x = work_visa_percent)) + 
      geom_jitter() +
      geom_smooth(method = "loess") +
      scale_y_continuous(labels = scales::percent) +
      scale_x_continuous(labels = scales::percent) +
      labs(title = "Employment Percentage in relationship to Work Visa Percentage",
           subtitle = "for the top 10 US immigration source countries, 2007 - 2017, each point is a country in a particular year",
           y = "% Labor Force in Employment",
           x = "% entering through Work Visa",
           caption = "Data Source: Homeland Security and US Census Bureau")
    
    print(regression_2)
    
  })
  
  # create regression table for the 2nd graph
  
  model_2 <- lm(employment_in_laborforce ~ work_visa_percent, data = immigration_employment_combined)
  model_table_2 <- get_regression_table(model_2)
  model_2_glance <- as.data.frame(glance(model_2))
  
  # render the linear regression table
  
  output$model_table_2 <- renderTable(model_table_2)
  
  # render the r^2 table
  
  output$model_table_2_2 <- renderTable(model_2_glance)
  
  
  # render the regression chart for language versus work visa percentage
  
  output$story_3 <- renderPlot({
    
    regression_3 <-   ggplot(immigration_language_combined, mapping = aes(y = percentage_very_well, x = work_visa_percent)) + 
      geom_jitter() +
      geom_smooth(method = "loess") +
      scale_y_continuous(labels = scales::percent) +
      scale_x_continuous(labels = scales::percent) +
      labs(title = "English Proficiency Percentage in relationship to Work Visa Percentage",
           subtitle = "for the top 10 US immigration source countries, 2007 - 2017, each point is a country in a particular year",
           y = "% Speaking English Very Well",
           x = "% entering through Work Visa",
           caption = "Data Source: Homeland Security and US Census Bureau")
    
    print(regression_3)
    
  })
  
  # create regression table for the 3rd graph
  
  model_3 <- lm(percentage_very_well ~ work_visa_percent, data = immigration_language_combined)
  model_table_3 <- get_regression_table(model_3)
  model_3_glance <- as.data.frame(glance(model_3))
  
  # render the linear regression table
  
  output$model_table_3 <- renderTable(model_table_3)
  
  # render the r^2 table
  
  output$model_table_3_2 <- renderTable(model_3_glance)
  
  
# render the trend chart on the left
  output$trendchart <- renderPlot({
    
    # this chart is going to be the graph shown on the left
    immigration_country_current <- immigration_country_long %>% 
      filter(country == input$variable)
    
    # create the chart
    graph_left <- ggplot(immigration_country_current, 
                         aes(x = year, y = count, fill = admission_class)) +
        geom_area(position = 'stack', alpha = 0.75) + 
        labs(y = "Total Immigrants", x = "Year", 
             fill = "Admission Class", 
             title = paste0("Immigration by Admission Class from ", input$variable,  " to US"),
             subtitle = "from 2007 - 2017",
             caption = "Data Source: Homeland Security") + 
        scale_fill_discrete(labels = c("Diversity", "Employment",
                                       "Immediate Relatives", "Other Relatives", "Refugee", "Other")) +  
        scale_x_continuous(breaks = c(2007, 2009, 2011, 2013, 2015, 2017))
    
    print(graph_left)
  })
 
# render language donut chart
  output$donut_language <- renderPlot({
      
      # this chart is going to be shown on the right
      english_country_current <- english_country %>%
          filter(country == input$variable)
      
      # make a summary chart
      english_country_current_summary <- english_country_current %>%
          summarize(total = sum(total_number), 
                    total_very_well = sum(population_very_well),
                    not_very_well = total - total_very_well) %>%
          select(total_very_well, not_very_well)
      
      # gather information from long to short format
      english_country_current_summary <- english_country_current_summary%>%
          gather(key = "english", value = "population",total_very_well:not_very_well)
      
      # compute percentages
      english_country_current_summary$fraction = english_country_current_summary$population / sum(english_country_current_summary$population)
      
      # compute the cumulative percentages (top of each rectangle)
      english_country_current_summary$ymax = cumsum(english_country_current_summary$fraction)
      
      # compute the bottom of each rectangle
      english_country_current_summary$ymin = c(0, head(english_country_current_summary$ymax, n=-1))
      
      donut <- ggplot(english_country_current_summary, 
          aes(ymax = ymax, ymin=ymin, 
          xmax=4, xmin=3, fill=english)) +
          geom_rect() +
          coord_polar(theta = "y") +
          xlim(c(2, 4)) + 
          scale_fill_manual(labels = c("Not Very Well", "Very Well"), values = c("grey", "yellowgreen")) +
          labs(title = paste0(percent(english_country_current_summary$fraction[1]) ,
                              " Immigrants from ", input$variable, " Speak English Very Well"),
                             fill = "English Speaking Ability", 
                        subtitle = "Weighted Average, 2007 - 2017",
                        caption = "Data Source: US Census Bureau") +
          theme(axis.text.y=element_blank(), 
                axis.ticks=element_blank())
      
      print(donut)
  })  
  
  # render labor force donut chart
  output$donut_labor <- renderPlot({
    
    # this chart is going to be shown on the right
    employment_country_current <- employment_country %>%
      filter(country == input$variable)
    
    # make a summary chart
    employment_country_current_summary <- employment_country_current %>%
      summarize(total = sum(total_number), 
                total_in = sum(population_in_labor_force),
                total_out = total - total_in) %>%
      select(total_in, total_out)
    
    # gather information from long to short format
    employment_country_current_summary <- employment_country_current_summary%>%
      gather(key = "labor", value = "population",total_in:total_out)
    
    # compute percentages
    employment_country_current_summary$fraction = employment_country_current_summary$population / sum(employment_country_current_summary$population)
    
    # compute the cumulative percentages (top of each rectangle)
    employment_country_current_summary$ymax = cumsum(employment_country_current_summary$fraction)
    
    # compute the bottom of each rectangle
    employment_country_current_summary$ymin = c(0, head(employment_country_current_summary$ymax, n=-1))
    
    donut <- ggplot(employment_country_current_summary, 
                    aes(ymax = ymax, ymin= ymin, 
                        xmax = 4, xmin = 3, fill = labor)) +
      geom_rect() +
      coord_polar(theta = "y") +
      xlim(c(2, 4)) + 
      scale_fill_manual(labels = c("In Labor Force", "Not in Labor Force"), values = c("yellowgreen", "grey")) +
      labs(title = paste0(percent(employment_country_current_summary$fraction[1]) ,
                          " Immigrants from ", input$variable, " are in Labor Force"),
           fill = "Labor Force", 
           subtitle = "Weighted Average, 2007 - 2017",
           caption = "Data Source: US Census Bureau") +
      theme(axis.text.y=element_blank(), 
            axis.ticks=element_blank())
    
    print(donut)
  })  
  
  
  
  
  # render employment donut chart
  output$donut_employment <- renderPlot({
    
    # this chart is going to be shown on the right
    employment_country_current <- employment_country %>%
      filter(country == input$variable)
    
    # make a summary chart
    employment_country_current_summary <- employment_country_current %>%
      summarize(total = sum(population_in_labor_force), 
                total_employed = sum(employment_population),
                total_unemployed = sum(unemployment_population)) %>%
      select(total_employed, total_unemployed)
    
    # gather information from long to short format
    employment_country_current_summary <- employment_country_current_summary%>%
      gather(key = "employment", value = "population",total_employed:total_unemployed)
    
    # compute percentages
    employment_country_current_summary$fraction = employment_country_current_summary$population / sum(employment_country_current_summary$population)
    
    # compute the cumulative percentages (top of each rectangle)
    employment_country_current_summary$ymax = cumsum(employment_country_current_summary$fraction)
    
    # compute the bottom of each rectangle
    employment_country_current_summary$ymin = c(0, head(employment_country_current_summary$ymax, n=-1))
    
    donut <- ggplot(employment_country_current_summary, 
                    aes(ymax = ymax, ymin=ymin, 
                        xmax=4, xmin=3, fill=employment)) +
      geom_rect() +
      coord_polar(theta = "y") +
      xlim(c(2, 4)) + 
      scale_fill_manual(labels = c("Employed", "Unemployed"), values = c("yellowgreen", "grey")) +
      labs(title = paste0(percent(employment_country_current_summary$fraction[1]) ,
                          " Labor Force from ", input$variable, " are Employed"),
           fill = "Employment", 
           subtitle = "Weighted Average, 2007 - 2017",
           caption = "Data Source: US Census Bureau") +
      theme(axis.text.y=element_blank(), 
            axis.ticks=element_blank())
    
    print(donut)
    
  })  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

