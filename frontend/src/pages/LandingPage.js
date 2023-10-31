import React, { useState } from "react";
import "./LandingPage.css";
import videoBg from "../assets/car.mp4";
import Modal from "react-modal";
import "bootstrap/dist/css/bootstrap.min.css";
// import "../components/Navbar.css";
import logo from "../components/main-logo.png";
import Login from "../components/Login";
import SigninPage from "./SigninPage";

const LandingPage = () => {
  const [visible, setVisible] = useState(false);
  return (
    <div className="landingpage">
      <div className="video-background">
        <video autoPlay loop muted>
          <source src={videoBg} type="video/mp4" />
        </video>

        <nav className="navbar navbar-light signin-section">
          <div className="container">
            <a href="/" className="navbar-brand">
              <img src={logo} height="40" alt="Logo" loading="lazy" />
            </a>

            <ul className="nav nav-pills">
              <li className="nav-item">
                <button className="nav-link" onClick={() => setVisible(true)}>
                  Sign in
                </button>
              </li>
            </ul>
          </div>
        </nav>

        <div className="intro-section">
          <h1 className="intro-section-title">WHEEL DEALS</h1>
          <p className="intro-section-subtitle">
            Keep you updated with the lastest trendy cars!
          </p>
          <button
            onClick={() => setVisible(true)}
            className="intro-section-button"
          >
            Join in
          </button>
        </div>

        <Modal isOpen={visible} onRequestClose={() => setVisible(false)} className="modal-section">
          <SigninPage></SigninPage>
          <button onClick={() => setVisible(false)}>Close modal</button>
        </Modal>
      </div>
    </div>
  );
};

export default LandingPage;
