import React, { useState } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import { Link } from "react-router-dom";

const Navbar = () => {
  return (
    <nav class="navbar navbar-light bg-light">
      <div class="container">
        {/* Logo */}
        <Link to="/home" class="navbar-brand" href="#">
          <img
            src="https://mdbcdn.b-cdn.net/img/logo/mdb-transaprent-noshadows.webp"
            height="20"
            alt="MDB Logo"
            loading="lazy"
          />
        </Link>

        {/* Links */}
        <ul class="nav nav-pills">
          <li class="nav-item">
            <Link to="/" class="nav-link" href="#">
              Home
            </Link>
          </li>

          <li class="nav-item">
            <Link to="/account" class="nav-link" href="#">
              Account
            </Link>
          </li>

          <li class="nav-item">
            <Link to="/favorite" class="nav-link" href="#">
              Favorites
            </Link>
          </li>

          <li class="nav-item">
            <Link to="/signin" class="nav-link">
              Sign in
            </Link>
          </li>
        </ul>
      </div>
    </nav>
  );
};

export default Navbar;
