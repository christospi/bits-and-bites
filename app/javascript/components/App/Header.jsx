import React from "react";
import { Link } from "react-router-dom";

const Header = () => {
  return (
    <header>
      <Link to="/" className="no-underline">
        <h1>🍜</h1>
      </Link>
    </header>
  );
};

export default Header;
