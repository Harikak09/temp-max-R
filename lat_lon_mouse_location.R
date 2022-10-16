# https://stackoverflow.com/questions/46132742/coordinates-of-current-mouse-position-on-leaflet-map-with-shiny
library(shiny)
library(leaflet)
library(htmlwidgets)

ui <- fluidPage(
  leafletOutput("map"),
  br(),
  verbatimTextOutput("out")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addProviderTiles("OpenStreetMap.Mapnik") %>%
      setView(-122.4105513,37.78250256, zoom = 12) %>%
      onRender(
        "function(el,x){
                    this.on('mousemove', function(e) {
                        var lat = e.latlng.lat;
                        var lng = e.latlng.lng;
                        var coord = [lat, lng];
                        Shiny.onInputChange('hover_coordinates', coord)
                    });
                    this.on('mouseout', function(e) {
                        Shiny.onInputChange('hover_coordinates', null)
                    })
                }"
      )
  })
  
  output$out <- renderText({
    if(is.null(input$hover_coordinates)) {
      "Mouse outside of map"
    } else {
      paste0("Lat: ", input$hover_coordinates[1], 
             "\nLng: ", input$hover_coordinates[2])
    }
  })
}
shinyApp(ui, server)
