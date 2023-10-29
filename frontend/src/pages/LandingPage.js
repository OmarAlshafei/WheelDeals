import React from "react";
import "./LandingPage.css";
import videoBg from "../assets/car.mp4";

const LandingPage = () => {
  return (
    <div className="landingpage">
      <div className="video-background">
        <video autoPlay loop muted>
          <source src={videoBg} type="video/mp4" />
        </video>

        <div className="intro-section">
          <h1 className="intro-section-title">WHEEL DEALS</h1>
          <p className="intro-section-subtitle">
            Keep you updated with the lastest trendy cars!
          </p>
          <a href="/" className="intro-section-button">
            Join in
          </a>
        </div>
      </div>
    </div>
  );
};

export default LandingPage;
