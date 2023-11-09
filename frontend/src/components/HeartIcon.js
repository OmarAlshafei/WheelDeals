import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart, faHeart as faHeartOutline } from "@fortawesome/free-solid-svg-icons";

const HeartIcon = (props) => {
    const favMake = props.favMake;
    const favModel = props.favModel;
    // const [isFilled, setIsFilled] = useState(false);

    // const toggleFilled = () => {
    //     setIsFilled(!isFilled);
    // };
  const [isFilled, setIsFilled] = useState(false);
  const userData = localStorage.getItem("user_data");
  const jwt = localStorage.getItem("jwt");
  // const userId = userData["userId"];
  console.log(jwt)
  // console.log(userId)

  const fetchData = async (favMake, favModel) => {
    try {
      const app_name = "wheeldeals-d3e9615ad014";
      const route = "api/addfavorite";
      const apiUrl =
        process.env.NODE_ENV === "production"
          ? `https://${app_name}.herokuapp.com/${route}`
          : `http://localhost:9000/${route}`;

      const res = await fetch(apiUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({favMake, favModel, jwt}),
      });

      if (!res.ok) {
        throw new Error(`Request failed with status: ${res.status}`);
      }
    } catch (error) {
      console.error("Error:", error);
    }
  };

  const toggleFilled = () => {
    setIsFilled(!isFilled);

    // Call API
    if (!isFilled) {
        fetchData();
    }
  };

  return (
    <td onClick={toggleFilled} style={{ cursor: "pointer" }}>
      <FontAwesomeIcon
        icon={isFilled ? faHeart : faHeartOutline}
        style={{
          color: isFilled ? "#ff0000" : "#ccc",
          fontSize: "24px",
        }}
      />
    </td>
  );
};

export default HeartIcon;
