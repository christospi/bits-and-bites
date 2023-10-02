import React, { useState } from "react";
import { useSearchParams } from "react-router-dom";

function RecipeSearch({ onSearch }) {
  const [searchParams, setSearchParams] = useSearchParams();
  const [keyphrase, setKeyphrase] = useState(
    searchParams.get("keyphrase") || "",
  );

  const handleSearch = () => {
    onSearch(keyphrase);
  };

  return (
    <div className="container mt-3">
      <div className="row justify-content-center">
        <div className="col-md-8">
          <div className="input-group">
            <input
              type="text"
              className="form-control"
              value={keyphrase}
              onChange={(e) => setKeyphrase(e.target.value)}
              placeholder="Enter ingredients, separated by commas"
            />
            <div className="input-group-append">
              <button
                className="btn btn-dark search-button"
                onClick={handleSearch}
              >
                Search
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default RecipeSearch;
