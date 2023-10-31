import React, { useState } from "react";
import "./Register.css";

const Register = (props) => {
  const [email, setEmail] = useState("");
  const [userName, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");

  const app_name = "wheeldeals-d3e9615ad014";
  function buildPath(route) {
    if (process.env.NODE_ENV === "production") {
      return "https://" + app_name + ".herokuapp.com/" + route;
    } else {
      return "http://localhost:9000/" + route;
    }
  }

  const doRegister = async (event) => {
    event.preventDefault();
    var obj = { firstName, lastName, userName, email, password };
    console.log(obj);
    try {
      let response = await fetch(buildPath("api/register"), {
        method: "POST",
        body: JSON.stringify(obj),
        headers: { "Content-Type": "application/json" },
      });
      response = await response.json();

      if (response.error) {
        alert(response.error);
      } else {
        alert("User has been added");
        props.onFormSwitch("Login");
      }
    } catch (error) {
      alert(error.toString());
      return;
    }
  };

  return (
    <div>
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
    </div>
  );
};

export default Register;
