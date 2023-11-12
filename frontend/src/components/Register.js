import React, { useState } from "react";
import "./Register.css";
import logo from "./main-logo.png";
import { faEnvelopeCircleCheck } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

const Register = (props) => {
  const [email, setEmail] = useState("");
  const [userName, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [confirmationMessage, setConfirmationMessage] = useState("");

  const doRegister = async (event) => {
    event.preventDefault();
    if (!firstName || !lastName || !userName || !email || !password) {
      alert("Please fill in all the fields.");
    } else {
      var bp = require("./Path.js");
      var obj = { firstName, lastName, userName, email, password };
      console.log(obj);
      try {
        let response = await fetch(bp.buildPath("api/register"), {
          method: "POST",
          body: JSON.stringify(obj),
          headers: { "Content-Type": "application/json" },
        });
        response = await response.json();

        if (response.error) {
          alert(response.error);
        } else {
          setConfirmationMessage("A verification email has been sent to you.");
          // alert("User has been added");
          // props.onFormSwitch("Login");
        }
      } catch (error) {
        alert(error.toString());
        return;
      }
    }
  };

  return (
    <div>
      {confirmationMessage && (
        <div className="confirmation-message">
          <a href="/" className="header">
            <img
              src={logo}
              height="40"
              alt="Logo"
              loading="lazy"
              className="logo"
            />
            <br></br>
            <FontAwesomeIcon
              icon={faEnvelopeCircleCheck}
              size="3x"
              style={{ color: "#ffffff" }}
            />
          </a>

          <div className="message">{confirmationMessage}</div>
          <div className="second-message">
            Check your inbox and verify your email address to get started. If
            you don't see it, please check your spam folder.
          </div>
        </div>
      )}
      {!confirmationMessage && (
        <form onSubmit={doRegister} className="register-form">
          <span id="inner-title" className="register-title">
            REGISTER
          </span>
          <label>First Name</label>
          <br></br>
          <input
            type="text"
            name="firstName"
            value={firstName}
            placeholder="First Name"
            onChange={(e) => setFirstName(e.target.value)}
          />
          <br></br>

          <label>Last Name</label>
          <br></br>
          <input
            type="text"
            name="lastName"
            placeholder="Last Name"
            value={lastName}
            onChange={(e) => setLastName(e.target.value)}
          />
          <br></br>

          <label>Email</label>
          <br></br>
          <input
            type="text"
            name="email"
            placeholder="Email"
            onChange={(e) => setEmail(e.target.value)}
          />
          <br></br>

          <label>Username</label>
          <br></br>
          <input
            type="text"
            name="userName"
            placeholder="Username"
            onChange={(e) => setUsername(e.target.value)}
          />
          <br></br>

          <label>Password</label>
          <br></br>
          <input
            type="password"
            name="password"
            placeholder="Password"
            onChange={(e) => setPassword(e.target.value)}
          />
          <br></br>

          <button type="submit" className="register-button">
            REGISTER
          </button>
          <button
            onClick={() => props.onFormSwitch("Login")}
            className="login-link"
          >
            Already have an account? Login here
          </button>
        </form>
      )}
    </div>
  );
};

export default Register;
