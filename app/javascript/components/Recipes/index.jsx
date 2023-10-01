import React, { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import RecipeSearch from "../RecipeSearch";

const Recipes = () => {
  const navigate = useNavigate();
  const [recipes, setRecipes] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);
  const [keyphrase, setKeyphrase] = useState("");

  const handleSearch = (keyphrase) => {
    setKeyphrase(keyphrase);
    setCurrentPage(1); // Reset to the first page for a new search
  };

  const allRecipes = recipes.map((recipe) => (
    <div key={recipe.id} className="col-md-6 col-lg-3">
      <div className="card mb-4">
        <img
          src={recipe.imageUrl}
          className="card-img-top"
          alt={`${recipe.title} image`}
          style={{ width: "100%", height: "200px", objectFit: "cover" }}
        />
        <div className="card-body">
          <h5 className="card-title">{recipe.title}</h5>
          <hr />
          <p className="card-text">
            <strong>Prep Time:</strong> {recipe.prepTimeInMinutes}'
          </p>
          <p className="card-text">
            <strong>Cook Time:</strong> {recipe.cookTimeInMinutes}'
          </p>
          <p className="card-text">
            <strong>Ratings:</strong> {recipe.ratings} ⭐
          </p>
          <p className="card-text">
            <strong>Category:</strong> {recipe.category || "-"}
          </p>
          <hr />
          <p className="card-text">
            <strong>Ingredients:</strong>
            <ul>
              {recipe.ingredients.map((ingredient, index) => (
                <li key={index}>
                  {ingredient.quantity} {ingredient.name}
                </li>
              ))}
            </ul>
          </p>
        </div>
      </div>
    </div>
  ));

  const noRecipes = (
    <div className="vw-100 vh-50 d-flex align-items-center justify-content-center">
      <h4>Oops, our chefs are on vacation; No recipes found!</h4>
    </div>
  );

  useEffect(() => {
    let url = `/api/v1/recipes/index?page=${currentPage}`;
    if (keyphrase) {
      url += `&keyphrase=${keyphrase}`;
    }

    fetch(url)
      .then((response) => response.json())
      .then((data) => {
        setRecipes(data.recipes);
        setCurrentPage(data.meta.currentPage);
        setTotalPages(data.meta.totalPages);
      })
      .catch(() => navigate("/recipes"));
  }, [currentPage, keyphrase]);

  return (
    <>
      <section className="jumbotron jumbotron-fluid text-center">
        <div className="container py-5">
          <h1 className="display-4">Recipes Catalogue</h1>
          <p className="lead">
            Search for your favourite recipes in our ever growing catalogue!
          </p>
          <RecipeSearch onSearch={handleSearch} />
        </div>
      </section>
      <div className="py-5">
        <main className="container">
          <div className="row">
            {recipes.length > 0 ? allRecipes : noRecipes}
          </div>
        </main>
      </div>
      <div className="pagination-controls">
        <button
          className="btn btn-secondary btn-sm"
          onClick={() =>
            setCurrentPage((prevPage) => Math.max(prevPage - 1, 1))
          }
          disabled={currentPage === 1}
        >
          Previous
        </button>

        <span className="mx-3">
          Page {currentPage} of {totalPages}
        </span>

        <button
          className="btn btn-secondary btn-sm"
          onClick={() =>
            setCurrentPage((prevPage) => Math.min(prevPage + 1, totalPages))
          }
          disabled={currentPage === totalPages}
        >
          Next
        </button>
      </div>
    </>
  );
};

export default Recipes;
