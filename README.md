# Custom Recipe Finder

Custom Recipe Finder is a Shiny-based web application that helps users find recipes based on available ingredients. The app allows filtering by meal type, cuisine, and dietary preferences, providing an interactive experience for discovering new recipes. Users can also track their search history and save favorite recipes for future reference.

## Features

- **Search by Ingredients**: Enter a list of ingredients to find recipes that include them.
- **Filter Options**:
  - Meal Type: All, Breakfast, Lunch, Dinner, Snack, Dessert
  - Cuisine: All, Italian, Mexican, Chinese, Indian, American
  - Dietary Preferences: None, Vegan, Gluten-Free, Vegetarian
- **Search History**: View a list of previous searches.
- **Favorites**: Save and manage favorite recipes.
- **Recipe Details**: View detailed information about a recipe, including ingredients, instructions, and an image.

## Built With

- **R**: Programming language used for building the application.
- **Shiny**: R package for creating interactive web applications.
- **HTTR**: R package for performing API requests.
- **JSONlite**: R package for parsing JSON data.
- **dplyr**: R package for data manipulation.

## Installation

To run this application locally, follow these steps:

1. **Install R and RStudio**: Make sure you have R and RStudio installed. You can download them from:
   - [R](https://cran.r-project.org/)
   - [RStudio](https://rstudio.com/products/rstudio/download/)

2. **Install Required R Packages**:
   Open RStudio and run the following commands to install the necessary packages:
   ```R
   install.packages(c("shiny", "httr", "jsonlite", "dplyr"))
   ```

3. **Clone the Repository**:
   Clone this repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/custom-recipe-finder.git
   ```

4. **Run the App**:
   Open the project folder in RStudio and run the following command:
   ```R
   shiny::runApp("app.R")
   ```

5. **Access the Application**:
   The app will start running locally, and you can access it by navigating to `http://localhost:8787` in your web browser.

## Usage

1. **Enter Ingredients**: Input the ingredients you have on hand, separated by commas (e.g., "chicken, rice, tomatoes").
2. **Select Filters**: Choose your desired meal type, cuisine, and dietary preferences.
3. **Find Recipes**: Click the "Find Recipes" button to see a list of recipes that match your criteria.
4. **View Recipe Details**: Click "View Details" for detailed instructions and ingredients for a selected recipe.
5. **Add to Favorites**: Click "Add to Favorites" to save recipes for future reference.
6. **Search History**: Track your previous searches for easy access.

## API Information

The app uses the [TheMealDB API](https://www.themealdb.com/api.php) for fetching recipe data. It performs an API call to get a list of recipes based on the specified ingredients.

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes and commit them (`git commit -m 'Add your feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.


## Acknowledgments

- [TheMealDB API](https://www.themealdb.com/api.php) for providing recipe data.
- [RStudio](https://rstudio.com/) for making R development easier.
