import React from "react";
import { Link } from "react-router-dom";

export default () => (
  <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
    <div className="jumbotron jumbotron-fluid bg-transparent">
      <div className="container secondary-color">
        <h1 className="display-4">Bits and Bites 🍜</h1>
        <p className="lead">
          Transforming bits to delicious bites since 2023®
        </p>
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
