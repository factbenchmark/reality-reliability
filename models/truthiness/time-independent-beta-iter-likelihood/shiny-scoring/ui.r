library(data.table)
library(shiny)
library(shinyWidgets)
library(shinyjs)
library(shinydashboard)
library(DT)
library(leaflet)
library(rhandsontable)

addResourcePath('data', 'data')

function(request) {
    
    loadingLogo <- function(href, src, loadingsrc, height = NULL, width = NULL, alt = NULL) {
        tagList(
            tags$head(
                     tags$script(
                              "setInterval(function(){
                     if ($('html').attr('class')=='shiny-busy') {
                     $('div.busy').show();
                     $('div.notbusy').hide();
                     } else {
                     $('div.busy').hide();
                     $('div.notbusy').show();
           }
         },100)")
         )
         , div(class = "busy",  
             img(src=loadingsrc, height = height, width = width, alt = alt))
         , div(class = 'notbusy',
               div(class = 'logo', "Truthiness"))
        )
    }

    ## useShinyjs()
    
    dashboardPage(
        title = "Truthiness",
        header = dashboardHeader(
            title = loadingLogo('http://www.google.co.nz',
                                'data/logo.png',
                                'data/out.gif')
        )

      , sidebar = dashboardSidebar(
            tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"))
          , tags$head(
                     HTML(
                         "
          <script>
          var socket_timeout_interval
          var n = 0
          $(document).on('shiny:connected', function(event) {
          socket_timeout_interval = setInterval(function(){
          Shiny.onInputChange('count', n++)
          }, 15000)
          });
          $(document).on('shiny:disconnected', function(event) {
          clearInterval(socket_timeout_interval)
          });
          </script>
          "
          )
          )
        , uiOutput('iter')
        , fluidRow(column(4, actionButton('prevbutt', '<', width='100%')),
                   column(4, h5('Response')),
                   column(4, actionButton('nextbutt', '>', width='100%')))
        , fluidRow(column(4, actionButton('prevbutts', '<<', width='100%')),
                   column(4, h5('Statement')),
                   column(4, actionButton('nextbutts', '>>', width='100%')))
        , fluidRow(column(4, actionButton('prevbutta', '<-', width='100%')),
                   column(4, h5('Agent response')),
                   column(4, actionButton('nextbutta', '->', width='100%')))
        ## , textOutput("keepAlive")
        )
        
      , body = dashboardBody(
            width = 12
          , useShinyjs()
          , h2(htmlOutput('answer_txt'))
          , br()
          , fluidRow(
                column(7
                     , h3('Effect of response')
                     , plotOutput('plot_dist', height='600px')
                     , h5('Red line: agent\'s response; white dotted line: "real" value')
                       ),
                column(5
                     , plotOutput('ll_plots', height = '300px')
                     , br()
                       ## , h4(htmlOutput('score_txt2'))
                       ## , h3(htmlOutput('score_txt'))
                       ## , br()
                     , plotOutput('plot_triangle')
                       )
            )
            ## , verbatimTextOutput('somelog')
        )
    )
}
