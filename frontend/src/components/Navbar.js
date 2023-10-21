import "bootstrap/dist/css/bootstrap.min.css";
import { Link } from "react-router-dom";
import logo from "./main-logo.png";

const Navbar = () => {
  return (
    <nav className="navbar navbar-light bg-light">
      <div className="container">
        <Link to="/home" className="navbar-brand">
          <img src={logo} height="40" alt="Logo" loading="lazy" />
        </Link>
        <ul className="nav nav-pills">
          <li className="nav-item">
            <Link to="/home" className="nav-link">
              Home
            </Link>
          </li>

          <li className="nav-item">
            <Link to="/account" className="nav-link">
              Account
            </Link>
          </li>

          <li className="nav-item">
            <Link to="/favorite" className="nav-link">
              Favorites
            </Link>
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
