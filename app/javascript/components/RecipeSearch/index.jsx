import React, { useState } from "react";
import { Link, useSearchParams } from "react-router-dom";

function RecipeSearch({ onSearch }) {
  const [searchParams, setSearchParams] = useSearchParams();
  const [keyphrase, setKeyphrase] = useState(
    searchParams.get("keyphrase") || "",
  );

  const handleSearch = () => {
    onSearch(keyphrase);
  };

  const clearSearch = () => {
    setKeyphrase("");
    setSearchParams({ keyphrase: "" });
  };

  return (
    <div className="container mt-3">
      <div className="row justify-content-center">
        <div className="col-md-10">
          <div className="input-group">
            <div className="col-md-1"></div>
            <input
              type="text"
              className="form-control rounded-start"
              value={keyphrase}
              onChange={(e) => setKeyphrase(e.target.value)}
              onKeyUp={(e) => {
                if (e.key === "Enter") {
                  handleSearch();
                }
              }}
              placeholder="Enter ingredients, comma separated (e.g. chicken, rice, tomato)"
            />
            <div className="input-group-append">
              <button
                className="btn btn-dark search-button"
                onClick={handleSearch}
              >
                Search
              </button>
            </div>
            <div className="input-group-append col-md-1">
              {keyphrase && (
                <Link
                  to="/recipes"
                  className="btn btn-outline-secondary"
                  onClick={clearSearch}
                >
                  Clear
                </Link>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default RecipeSearch;
