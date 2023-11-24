import React, { useState } from "react";
import "./ForgetPassword.css";
import { Link } from "react-router-dom";
import Login from "./Login.js";
import logo from "./main-logo.png";
import { useHistory } from "react-router-dom";
import "./Register.css";

const ForgetPassword = (props) => {
  const [email, setEmail] = useState("");
  const [jwtToken, setToken] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [currentForm, setCurrentForm] = useState("enterEmail");
  const [message, setMessage] = useState("");

  const history = useHistory();

  const handleFormSubmit = async (e) => {
    e.preventDefault();
    var bp = require("./Path.js");

    if (currentForm === "enterEmail") {
      // Call the resetPassword API
      try {
        const response = await fetch(bp.buildPath("api/resetPassword"), {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email }),
        });

        const data = await response.json();

        if (response.ok) {
          setMessage(data.msg);
          setCurrentForm("enterCode");
        } else {
          setMessage(data.msg);
        }
      } catch (error) {
        console.error("Error:", error);
        setMessage("An error occurred. Please try again.");
      }
    } else if (currentForm === "enterCode") {
      // Call the confirmEmail API
      try {
        const response = await fetch(bp.buildPath("api/confirmEmail"), {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ jwtToken, email }),
        });

        const data = await response.json();

        if (response.ok) {
          setMessage(data.msg);
          setCurrentForm("enterPassword");
        } else {
          setMessage(data.msg);
        }
      } catch (error) {
        console.error("Error:", error);
        setMessage("An error occurred. Please try again.");
      }
    } else if (currentForm === "enterPassword") {
      // Call the changePassword API
      try {
        const response = await fetch(bp.buildPath("api/changePassword"), {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email, password: newPassword }),
        });

        const data = await response.json();

        if (response.ok) {
          setMessage(data.msg);
          setCurrentForm("resetSuccess");
        } else {
          setMessage(data.msg);
        }
      } catch (error) {
        console.error("Error:", error);
        setMessage("An error occurred. Please try again.");
      }
    }
  };

  return (
    <div>
      <form onSubmit={handleFormSubmit} className="login-form">
        {currentForm === "enterEmail" && (
          <div>
            <a href="/" className="header">
              <img
                src={logo}
                // height="60"
                alt="Logo"
                loading="lazy"
                className="logo"
              />
              <br></br>
            </a>
            <span id="inner-title" className="login-title">
              FORGOT PASSWORD
            </span>
            <div className="login-remind">
              Please enter the email address you use to Sign In!
            </div>
            <br />
            <label className="login-label">Email</label>
            <br></br>
            <input
              type="text"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
            <br></br>
            <button type="submit" className="login-button">
              Submit
            </button>
            {/* <button onClick={() => history.goBack()}>Go Back</button> */}
            {message && <div>{message}</div>}
          </div>
        )}

        {currentForm === "enterCode" && (
          <>
            <a href="/" className="header">
              <img
                src={logo}
                // height="60"
                alt="Logo"
                loading="lazy"
                className="logo"
              />
              <br></br>
            </a>
            <span id="inner-title" className="login-title">
              ENTER YOUR CODE
            </span>
            <div className="login-remind">
              {message && <div>{message}</div>}
            </div>
            {/* {message && <div>{message}</div>} */}
            <br />
            <label className="login-label">Code</label>
            <br></br>
            <input
              type="text"
              placeholder="Code"
              value={jwtToken}
              onChange={(e) => setToken(e.target.value)}
            />
            <br></br>
            <button type="submit" className="login-button">
              Verify code
            </button>
          </>
        )}

        {currentForm === "enterPassword" && (
          <>
            <a href="/" className="header">
              <img
                src={logo}
                // height="60"
                alt="Logo"
                loading="lazy"
                className="logo"
              />
              <br></br>
            </a>
            <span id="inner-title" className="login-title">
              RESET YOUR PASSWORD
            </span>
            <div className="login-remind">
              {message && <div>{message}</div>}Please enter the new password
            </div>
            <br />
            <label className="login-label">New Password</label>
            <br></br>
            <input
              type="password"
              placeholder="New Password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
            />
            <br></br>
            <button type="submit" className="login-button">
              Submit
            </button>
          </>
        )}

        {currentForm === "resetSuccess" && (
          <>
            <a href="/" className="header">
              <img
                src={logo}
                // height="60"
                alt="Logo"
                loading="lazy"
                className="logo"
              />
              <br></br>
            </a>
            <span id="inner-title" className="login-title">
              Password reset successfully. Please try to login again with your
              new password. Thank you.
            </span>
            <button
              className="login-button"
              onClick={() => props.onFormSwitch("Login")}
            >
              Login
            </button>
          </>
        )}

        {/* {message && <div>{message}</div>} */}
      </form>
    </div>
  );
};

export default ForgetPassword;
