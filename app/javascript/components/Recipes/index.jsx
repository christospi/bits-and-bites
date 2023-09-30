import React, { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";

const Recipes = () => {
  const navigate = useNavigate();
  const [recipes, setRecipes] = useState([]);

  useEffect(() => {
    const url = "/api/v1/recipes/index";
    fetch(url)
      .then((response) => response.json())
      .then((data) => {
        setRecipes(data.recipes);
      })
      .catch(() => navigate("/"));
  }, []);

  const allRecipes = recipes.map((recipe, index) => (
    <div key={index} className="col-md-6 col-lg-4">
      <div className="card mb-4">
        <img
          src={recipe.imageUrl}
          className="card-img-top"
          alt={`${recipe.title} image`}
        />
        <div className="card-body">
          <h5 className="card-title">{recipe.title}</h5>

          <p className="card-text">
            <strong>Prep Time:</strong> {recipe.prepTimeInMinutes} minutes
          </p>
          <p className="card-text">
            <strong>Cook Time:</strong> {recipe.cookTimeInMinutes} minutes
          </p>
          <p className="card-text">
            <strong>Ratings:</strong> {recipe.ratings} stars
          </p>
          <p className="card-text">
            <strong>Cuisine:</strong> {recipe.cuisine}
          </p>

          <Link to="#" className="btn custom-button">
            View Recipe
          </Link>
        </div>
      </div>
    </div>
  ));

  const noRecipes = (
    <div className="vw-100 vh-50 d-flex align-items-center justify-content-center">
      <h4>Unfortunately, our chefs are on vacation; No recipes found!</h4>
    </div>
  );

  return (
    <>
      <section className="jumbotron jumbotron-fluid text-center">
        <div className="container py-5">
          <h1 className="display-4">Recipes Catalogue</h1>
          <p className="lead">
            Search for your favourite recipes in our ever growing catalogue!
          </p>
        </div>
      </section>
      <div className="py-5">
        <main className="container">
          <div className="row">
            {recipes.length > 0 ? allRecipes : noRecipes}
          </div>
        </main>
      </div>
    </>
  );
};

export default Recipes;
