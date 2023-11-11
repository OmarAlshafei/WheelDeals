import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faHeart as faHeartFilled,
  faHeart as faHeartOutline,
} from "@fortawesome/free-solid-svg-icons";

const HeartIcon = (props) => {
  const make = props.favMake;
  const model = props.favModel;

  console.log(make);
  console.log(model);


  const [isFilled, setIsFilled] = useState(false);

  useEffect(() => {
    const jwtToken = localStorage.getItem("jwt");
    const userDataString = localStorage.getItem("user_data");
    const userData = JSON.parse(userDataString);
    const id = userData.id;

    const getFavorite = async () => {
      try {
        const app_name = "wheeldeals-d3e9615ad014";
        const route = "api/getfavorites";
        const apiUrl =
          process.env.NODE_ENV === "production"
            ? `https://${app_name}.herokuapp.com/${route}`
            : `http://localhost:9000/${route}`;

        const res = await fetch(apiUrl, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ id, jwtToken }),
        });

        if (!res.ok) {
          throw new Error(`Request failed with status: ${res.status}`);
        }

        const result = await res.json();

        result["favorites"].map((favorite) => {
          if(make === favorite["make"] && favorite["model"] === model){
            setIsFilled(true);
          }
        })

        // setIsFilled(result !== null);
      } catch (error) {
        console.error("Error:", error);
      }
    };

    getFavorite();
  }, [make, model]);

  const toggleFilled = async () => {
    // Call API only if not already filled
    if (!isFilled) {
      try {
        const jwtToken = localStorage.getItem("jwt");
        const userDataString = localStorage.getItem("user_data");
        const userData = JSON.parse(userDataString);
        const id = userData.id;

        const app_name = "wheeldeals-d3e9615ad014";
        const route = "api/addfavorite";
        const apiUrl =
          process.env.NODE_ENV === "production"
            ? `https://${app_name}.herokuapp.com/${route}`
            : `http://localhost:9000/${route}`;

        const res = await fetch(apiUrl, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ id, make, model, jwtToken }),
        });

        if (!res.ok) {
          throw new Error(`Request failed with status: ${res.status}`);
        }

        setIsFilled(true);
      } catch (error) {
        console.error("Error:", error);
      }
    }else{
      try {
        const jwtToken = localStorage.getItem("jwt");
        const userDataString = localStorage.getItem("user_data");
        const userData = JSON.parse(userDataString);
        const id = userData.id;

        const app_name = "wheeldeals-d3e9615ad014";
        const route = "api/removefavorite";
        const apiUrl =
          process.env.NODE_ENV === "production"
            ? `https://${app_name}.herokuapp.com/${route}`
            : `http://localhost:9000/${route}`;

        const res = await fetch(apiUrl, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ id, make, model, jwtToken }),
        });

        if (!res.ok) {
          throw new Error(`Request failed with status: ${res.status}`);
        }

        setIsFilled(false);
      } catch (error) {
        console.error("Error:", error);
      }
    }

  };

  return (
    <td style={{ cursor: "pointer" }}>
      <FontAwesomeIcon
        onClick={() => toggleFilled()}
        icon={isFilled ? faHeartFilled : faHeartOutline}
        style={{
          color: isFilled ? "#ff0000" : "#ccc",
          fontSize: "24px",
        }}
      />
    </td>
  );
};

export default HeartIcon;
