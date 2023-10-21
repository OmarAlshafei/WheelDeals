import React, { useState } from "react";

const Register = (props) => {
  const [email, setEmail] = useState(" ");
  const [userName, setUsername] = useState(" ");
  const [password, setPassword] = useState(" ");
  const [firstName, setFirstName] = useState(" ");
  const [lastName, setLastName] = useState(" ");

  const handleSubmit = (e) => {
    e.preventDefault();
    const user = { email, userName, password, firstName, lastName };
    console.log(user);
  };

  return (
    <div>
      <h1>Register</h1>
      <form onSubmit={handleSubmit}>
        <label>First Name</label>
        <br></br>
        <input
          type="text"
          name="firstName"
          onChange={(e) => setFirstName(e.target.value)}
        />
        <br></br>

        <label>Last Name</label>
        <br></br>
        <input
          type="text"
          name="lastName"
          onChange={(e) => setLastName(e.target.value)}
        />
        <br></br>

        <label>Email</label>
        <br></br>
        <input
          type="text"
          name="email"
          onChange={(e) => setEmail(e.target.value)}
        />
        <br></br>

        <label>Username</label>
        <br></br>
        <input
          type="text"
          name="userName"
          onChange={(e) => setUsername(e.target.value)}
        />
        <br></br>

        <label>Password</label>
        <br></br>
        <input
          type="password"
          name="password"
          onChange={(e) => setPassword(e.target.value)}
        />
        <br></br>

        <button type="submit">Register</button>
      </form>
      <button onClick={() => props.onFormSwitch("Login")}>
        Already have an account? Login here
      </button>
    </div>
  );
};

export default Register;
