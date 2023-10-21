import "bootstrap/dist/css/bootstrap.min.css";
import { Link } from "react-router-dom";
import logo from "./main-logo.png";

const Navbar = () => {
  return (
    <nav className="navbar navbar-light bg-light">
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
            <a href="/favorite" className="nav-link">
              Favorites
            </a>
          </li>

          <li className="nav-item">
            <a href="/signin" className="nav-link">
              Sign in
            </a>
          </li>
          <li className="nav-item">
            <a href="/test" className="nav-link">
              Test
            </a>
          </li>
        </ul>
      </div>
    </nav>
  );
};

export default Navbar;
