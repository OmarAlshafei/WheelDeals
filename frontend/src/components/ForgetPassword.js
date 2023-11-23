import React, { useState } from "react";

const ForgetPassword = () => {
  const [email, setEmail] = useState("");
  const [jwtToken, setToken] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [currentForm, setCurrentForm] = useState("enterEmail");
  const [message, setMessage] = useState("");

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
      <form onSubmit={handleFormSubmit}>
        {currentForm === "enterEmail" && (
          <>
            <span>FORGOT PASSWORD</span>
            <div>Please enter the email address you use to sign in</div>
            <br />
            <label>Email</label>
            <br></br>
            <input
              type="email"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
            <br></br>
            <button type="submit">Submit</button>
          </>
        )}

        {currentForm === "enterCode" && (
          <>
            <span>ENTER YOUR CODE</span>
            <div>Please enter the reset code that has been sent to you</div>
            <br />
            <label>Code</label>
            <br></br>
            <input
              type="text"
              placeholder="Code"
              value={jwtToken}
              onChange={(e) => setToken(e.target.value)}
            />
            <br></br>
            <button type="submit">Verify code</button>
          </>
        )}

        {currentForm === "enterPassword" && (
          <>
            <span>RESET YOUR PASSWORD</span>
            <div>Please enter the new password</div>
            <br />
            <label>New Password</label>
            <br></br>
            <input
              type="password"
              placeholder="New Password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
            />
            <br></br>
            <button type="submit">Submit</button>
          </>
        )}

        {currentForm === "resetSuccess" && (
          <>
            <span>Password reset successfully. Please try to login again.</span>
          </>
        )}

        {message && <div>{message}</div>}
      </form>
    </div>
  );
};

export default ForgetPassword;
