import React, { useState } from "react";
import Login from "../components/Login";
import Register from "../components/Register";
import ForgetPassword from "../components/ForgetPassword";

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
        <>
          <Login onFormSwitch={toggleForm} />
        </>
      ) : currentForm === "Register" ? (
        <Register onFormSwitch={toggleForm} />
      ) : (
        <ForgetPassword onFormSwitch={toggleForm} />
      )}
    </div>
  );
};

export default SigninPage;
