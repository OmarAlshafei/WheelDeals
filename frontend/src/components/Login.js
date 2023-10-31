import React, { useState } from "react";
import "./Login.css";

const Login = (props) => {
  const app_name = "wheeldeals-d3e9615ad014";
  function buildPath(route) {
    if (process.env.NODE_ENV === "production") {
      return "https://" + app_name + ".herokuapp.com/" + route;
    } else {
      return "http://localhost:9000/" + route;
    }
  }

  var loginName;
  var loginPassword;
  const [message, setMessage] = useState("");

  const doLogin = async (event) => {
    event.preventDefault();
    var obj = { userName: loginName.value, password: loginPassword.value };
    try {
      const response = await fetch(buildPath("api/login"), {
        method: "POST",
        body: JSON.stringify(obj),
        headers: { "Content-Type": "application/json" },
      });
      var res = JSON.parse(await response.text());
      if (res.id <= 0) {
        setMessage("User/Password combination incorrect");
      } else {
        var user = {
          firstName: res.firstName,
          lastName: res.lastName,
          id: res.id,
        };
        localStorage.setItem("user_data", JSON.stringify(user));
        setMessage("");
        window.location.href = "/cards";
      }
    } catch (e) {
      alert(e.toString());
      return;
    }
  };

  return (
    <div id="loginDiv" className="login-form">
      <form onSubmit={doLogin}>
        <span id="inner-title" className="login-title">
          LOGIN
        </span>
        <div className="login-remind">
          Please enter your login and password!
        </div>
        <br />
        <label className="login-label">Username</label>
        <br />
        <input
          type="text"
          id="loginName"
          placeholder="Username"
          ref={(c) => (loginName = c)}
        />
        <br />
        <label className="login-label">Password</label>

        <input
          type="password"
          id="loginPassword"
          placeholder="Password"
          ref={(c) => (loginPassword = c)}
        />
        <br />
        <input
          type="submit"
          id="loginButton"
          className="buttons"
          value="LOGIN"
        />
        <br />
      </form>
      <button
        onClick={() => props.onFormSwitch("Register")}
        className="register-button"
      >
        Don't have an account? Register here
      </button>
      <span id="loginResult">{message}</span>
    </div>
  );
};

export default Login;
