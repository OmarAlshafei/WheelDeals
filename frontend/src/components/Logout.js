import React from "react";
import { useHistory } from "react-router-dom";

const Logout = () => {
  const history = useHistory();

  const handleLogout = () => {
    // Clear local storage
//     localStorage.clear();

    // Redirect to the landing page
    history.push("/");

    // Prevent going back to the previous page
    history.go(1);
  };

  return (
    <div>
      <p>Are you sure you want to logout?</p>
      <button onClick={handleLogout}>Logout</button>
    </div>
  );
};

export default Logout;