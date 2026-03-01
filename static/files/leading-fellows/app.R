library(tidyverse)
library(readxl)
library(shiny)
library(RColorBrewer)
library(lubridate)
library(ggplot2)
library(dplyr)

#and spatial libraries
library(sf)
library(terra)
library(tmap)    # for static and interactive maps
library(leaflet) # for interactive maps
library(ggplot2)

#import everything
pzip <- read_sf("https://opendata.arcgis.com/datasets/b54ec5210cee41c3a884c9086f7af1be_0.geojson")
patt = read_csv('data/Housing_and_Murals.csv')
plot(pzip)
patt$zip_code = as.character(patt$zip_code)

#now create single file
p = full_join(pzip, patt, by = c("CODE" = "zip_code"))

#define color palette function
pal <- colorNumeric(
  palette = "Reds",
  domain = p$yearly_avg)

pal2 = colorNumeric(
  palette = "Blues",
  domain = p$mural_count)

#set labels javascript
labels1 <- sprintf(
  "<strong>%s</strong><br/>$%g",
  p$CODE, p$yearly_avg
) %>% lapply(htmltools::HTML)

labels2 <- sprintf(
  "<strong>%s</strong><br/>%g murals",
  p$CODE, p$mural_count
) %>% lapply(htmltools::HTML)


#define UI



ui = fluidPage(
  
  titlePanel("Philadelphia Average Housing Values by Zip Code"),
  sidebarLayout(
    
    sidebarPanel = sidebarPanel(
      sliderInput('year', 'Year', min = 2000, max = 2022, value = 2010, sep = ""),
      width = 3
    ),
    mainPanel = mainPanel(leafletOutput(outputId = 'map', height = "90vh"),
                          width = 9)
  )
  
)

#build the server
server = function(input, output, session){
  
  map_df2 = reactive({
    
    p %>% filter(year== input$year)
  })
  
  output$map = renderLeaflet({
    
    # #define labels for hover
    # labels <- sprintf(
    #   "<strong>%s</strong><br/>$%g</sup>",
    #   map_df2()$CODE, map_df2()$yearly_avg
    # ) %>% lapply(htmltools::HTML)
    
    leaflet(map_df2()) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~pal(yearly_avg),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "0",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels1,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"),
        group = "Housing Values") %>%
      addPolygons(
        fillColor = ~pal2(mural_count),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "0",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels2,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"),
        group = "Mural Counts") %>%
      addLegend("bottomright", pal = pal, values = ~yearly_avg,
                title = "Average Housing Value by Zip",
                labFormat = labelFormat(prefix = "$"),
                opacity = 1,
                group = "Housing Values") %>%
      addLegend("bottomright", pal = pal2, values = ~mural_count,
                title = "Mural Count by Zip",
                opacity = 1,
                group = "Mural Counts") %>%
      addLayersControl(
        overlayGroups = c("Housing Values", "Mural Counts"),
        position = "topleft",
        options = layersControlOptions(collapsed = FALSE)
      )
    
  })
}

shinyApp(ui, server)