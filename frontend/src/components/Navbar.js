import "bootstrap/dist/css/bootstrap.min.css";
import { Link } from "react-router-dom";
import logo from "./main-logo.png";
import React from "react";
import Form from "react-bootstrap/Form";
import "./Navbar.css";
import { useHistory } from "react-router-dom";

const Navbar = () => {
  const history = useHistory();

  const handleLogout = () => {
    alert("Are you sure that you want to log out?");
    // Clear local storage
    localStorage.clear();

    // Redirect to the landing page
    history.push("/");

    // Prevent going back to the previous page
    history.go(1);
  };
  return (
    <nav className="navbar navbar-light">
      <div className="container">
        <a href="/home" className="navbar-brand">
          <img src={logo} height="40" alt="Logo" loading="lazy" />
        </a>

        <ul className="nav nav-pills">
          <li className="nav-item">
            <a href="/home" className="nav-link">
              Home
            </a>
          </li>

          <li className="nav-item">
            <a href="/account" className="nav-link">
              Account
            </a>
          </li>

          <li className="nav-item">
            <a href="/favorites" className="nav-link">
              Favorites
            </a>
          </li>

          <li className="nav-item">
            <alert>
              <Link onClick={handleLogout} className="nav-link">
                Log out
              </Link>
            </alert>
          </li>
        </ul>
      </div>
    </nav>
  );
};

export default Navbar;
