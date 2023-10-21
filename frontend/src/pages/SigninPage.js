import React, { useState } from "react";
import Login from "../components/Login";
import Register from "../components/Register";

const SigninPage = () => {
  const [currentForm, setCurrentForm] = useState("Login");

  const toggleForm = (formname) => {
    setCurrentForm(formname);
  };

  return (
    <div>
      {/* <Login />
      <Register /> */}
      {currentForm === "Login" ? (
        <Login onFormSwitch={toggleForm} />
      ) : (
        <Register onFormSwitch={toggleForm} />
      )}
    </div>
  );
};

export default SigninPage;
