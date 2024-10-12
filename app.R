# Load required libraries
library(shiny)
library(httr)
library(jsonlite)
library(dplyr)

# User Interface (UI)
ui <- fluidPage(
  titlePanel("Custom Recipe Finder"),
  sidebarLayout(
    sidebarPanel(
      textInput("ingredients", 
                label = "Enter your ingredients (comma-separated):", 
                placeholder = "e.g. chicken, rice, tomatoes"),
      selectInput("meal_type", 
                  label = "Select Meal Type:", 
                  choices = c("All", "Breakfast", "Lunch", "Dinner", "Snack", "Dessert"),
                  selected = "All"),
      selectInput("cuisine", 
                  label = "Select Cuisine:", 
                  choices = c("All", "Italian", "Mexican", "Chinese", "Indian", "American"),
                  selected = "All"),
      selectInput("dietary", 
                  label = "Select Dietary Preference:", 
                  choices = c("None", "Vegan", "Gluten-Free", "Vegetarian"),
                  selected = "None"),
      actionButton("search", "Find Recipes"),
      uiOutput("loading_message"),
      h4("Search History:"),
      uiOutput("search_history"),
      h4("Favorites:"),
      uiOutput("favorites_list")
    ),
    mainPanel(
      h4("Recipe Suggestions:"),
      uiOutput("recipe_table"),
      uiOutput("recipe_details")
    )
  )
)

# Server Logic
server <- function(input, output, session) {
  
  # Reactive values to store search history and favorites
  search_history <- reactiveVal(character())
  favorites <- reactiveVal(character())
  
  # Function to get recipes from the API
  get_recipes <- function(ingredients) {
    api_url <- paste0("https://www.themealdb.com/api/json/v1/1/filter.php?i=", 
                      gsub(" ", "", ingredients))
    
    response <- tryCatch({
      GET(api_url)
    }, error = function(e) {
      print("Error during API call")
      return(NULL)
    })
    
    if (!is.null(response) && response$status_code == 200) {
      meals <- fromJSON(content(response, "text", encoding = "UTF-8"))
      
      print("API Response:")
      print(meals)  # Print the API response
      
      # Defensive check
      if (is.list(meals) && !is.null(meals$meals) && length(meals$meals) > 0) {
        return(data.frame(
          Meal = sapply(meals$meals, `[[`, "strMeal"),
          Image = sapply(meals$meals, `[[`, "strMealThumb"),
          ID = sapply(meals$meals, `[[`, "idMeal"),
          stringsAsFactors = FALSE
        ))
      } else {
        print("No meals found in the response.")
      }
    } else {
      print("Invalid response or error occurred")
    }
    return(NULL)
  }

  # Observing search button click to get recipes
  observeEvent(input$search, {
    output$loading_message <- renderUI({
      tags$div("Loading... Please wait.")
    })
    
    if (nchar(input$ingredients) > 0) {
      recipe_data <- get_recipes(input$ingredients)
      
      if (!is.null(recipe_data) && nrow(recipe_data) > 0) {
        search_history(c(search_history(), paste("Ingredients:", input$ingredients)))
        
        output$recipe_table <- renderUI({
          tagList(
            lapply(1:nrow(recipe_data), function(i) {
              fluidRow(
                column(4, 
                       img(src = recipe_data$Image[i], height = 100)
                ),  
                column(8, 
                       h5(recipe_data$Meal[i]),
                       actionButton(paste0("details_", recipe_data$ID[i]), "View Details"),
                       actionButton(paste0("favorite_", recipe_data$ID[i]), "Add to Favorites")
                )
              )
            })
          )
        })
        
        output$loading_message <- renderUI({
          NULL
        })
      } else {
        output$recipe_table <- renderUI({
          h4("No recipes found. Please try different ingredients.")
        })
      }
      
    } else {
      output$recipe_table <- renderUI({
        h4("Please enter some ingredients.")
      })
    }
  })
  
  # Observing individual recipe detail requests
  observeEvent(input$search, {
    recipe_data <- get_recipes(input$ingredients)
    
    if (!is.null(recipe_data) && nrow(recipe_data) > 0) {
      lapply(1:nrow(recipe_data), function(i) {
        observeEvent(input[[paste0("details_", recipe_data$ID[i])]], {
          recipe_details <- get_recipe_details(recipe_data$ID[i])
          
          output$recipe_details <- renderUI({
            if (!is.null(recipe_details)) {
              fluidPage(
                h4(recipe_details$strMeal),
                img(src = recipe_details$strMealThumb, height = 150),
                h5("Ingredients:"),
                tags$ul(
                  lapply(1:20, function(j) {
                    ingredient <- recipe_details[[paste0("strIngredient", j)]]
                    measure <- recipe_details[[paste0("strMeasure", j)]]
                    if (!is.na(ingredient) && ingredient != "") {
                      tags$li(paste(ingredient, "(", measure, ")"))
                    }
                  })
                ),
                h5("Instructions:"),
                p(recipe_details$strInstructions)
              )
            } else {
              h4("Recipe details not found.")
            }
          })
        })
      })
    }
  })
  
  # Observing favorite button clicks
  observeEvent(input$search, {
    recipe_data <- get_recipes(input$ingredients)
    
    if (!is.null(recipe_data) && nrow(recipe_data) > 0) {
      lapply(1:nrow(recipe_data), function(i) {
        observeEvent(input[[paste0("favorite_", recipe_data$ID[i])]], {
          favorites(c(favorites(), recipe_data$Meal[i]))
          showModal(modalDialog(
            title = "Recipe Favorited",
            paste("You have favorited the recipe:", recipe_data$Meal[i]),
            easyClose = TRUE,
            footer = NULL
          ))
        })
      })
    }
  })
  
  # Render search history
  output$search_history <- renderUI({
    if (length(search_history()) > 0) {
      tagList(lapply(search_history(), function(history) {
        tags$li(history)
      }))
    } else {
      tags$li("No search history.")
    }
  })
  
  # Render favorites list
  output$favorites_list <- renderUI({
    if (length(favorites()) > 0) {
      tagList(lapply(favorites(), function(fav) {
        tags$li(fav)
      }))
    } else {
      tags$li("No favorites yet.")
    }
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
