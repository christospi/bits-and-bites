import React from "react";
import { Link } from "react-router-dom";

const Header = () => {
  return (
    <header className="vh-5">
      <Link to="/">
        <img
          src="/assets/bnb.webp"
          alt="Bits and Bites logo"
          className="bnb-logo"
        />
      </Link>
    </header>
  );
};

export default Header;
