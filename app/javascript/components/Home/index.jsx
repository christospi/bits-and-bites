import React from "react";
import { Link } from "react-router-dom";

export default () => (
  <div className="vw-100 vh-95 home-margin-top primary-color d-flex align-items-center justify-content-center">
    <div className="jumbotron jumbotron-fluid bg-transparent">
      <div className="container secondary-color">
        <div className="display-4 text-center">
          <img
            src="/assets/bnb.webp"
            alt="Bits and Bites logo"
            className="bnb-logo-home"
          />
        </div>
        <p className="lead text-center">From 0s and 1s to yums and noms!</p>
        <Link
          to="/recipes"
          className="d-flex mt-4 btn btn-lg custom-button align-items-center justify-content-center"
          role="button"
        >
          Let's go, I'm hungry!
        </Link>
      </div>
    </div>
  </div>
);
