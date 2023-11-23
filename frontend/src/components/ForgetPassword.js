import React from "react";

const ForgetPassword = () => {
  return (
    <div>
      <form>
        <span>FORGOT PASSWORD</span>
        <div>Please enter the email address you use to sign in</div>
        <br />
        <label>Email</label>
        <br></br>
        <input type="email" placeholder="Email"></input>
        <br></br>
        <button>Submit</button>
      </form>
    </div>
  );
};

export default ForgetPassword;
