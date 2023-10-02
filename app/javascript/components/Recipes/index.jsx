import React, { useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import RecipeSearch from "../RecipeSearch";

const Recipes = () => {
  const navigate = useNavigate();
  const [recipes, setRecipes] = useState([]);
  const [totalPages, setTotalPages] = useState(0);
  const [searchParams, setSearchParams] = useSearchParams();

  const handleSearch = (keyphrase) => {
    setSearchParams(keyphrase ? { keyphrase } : {});
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
    let url = `/api/v1/recipes/index?`;
    if (searchParams.has("keyphrase")) {
      url += `&keyphrase=${searchParams.get("keyphrase")}`;
    }
    if (searchParams.has("page")) {
      url += `&page=${searchParams.get("page")}`;
    }

    fetch(url)
      .then((response) => response.json())
      .then((data) => {
        setRecipes(data.recipes);
        setTotalPages(data.meta.totalPages);
      })
      .catch(() => navigate("/recipes"));
  }, [searchParams]);

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
            setSearchParams((prevParams) => ({
              ...prevParams,
              page: Math.max(Number(prevParams.get("page")) - 1, 1),
            }))
          }
          disabled={
            searchParams.get("page") === "1" || !searchParams.has("page")
          }
        >
          Previous
        </button>

        <span className="mx-3">
          Page {searchParams.get("page") || 1} of {totalPages}
        </span>

        <button
          className="btn btn-secondary btn-sm"
          onClick={() =>
            setSearchParams((prevParams) => ({
              ...prevParams,
              page: Math.min(
                Number(prevParams.get("page") || "1") + 1,
                totalPages,
              ).toString(),
            }))
          }
          disabled={
            searchParams.get("page") === totalPages.toString() || totalPages < 2
          }
        >
          Next
        </button>
      </div>
    </>
  );
};

export default Recipes;
