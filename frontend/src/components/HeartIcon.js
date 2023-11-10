import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart, faHeart as faHeartOutline } from "@fortawesome/free-solid-svg-icons";

const HeartIcon = (props) => {
    const make = props.favMake;
    const model = props.favModel;
  
    const [isFilled, setIsFilled] = useState(
      localStorage.getItem("isFilled") === "true"
    );

    useEffect(() => {
      localStorage.setItem("isFilled", isFilled);
    }, [isFilled]);
  
  
  const jwtToken = localStorage.getItem("jwt");
  const userDataString = localStorage.getItem('user_data');
  const userData = JSON.parse (userDataString);
  const id = userData.id;
  //console.log("jwt: " +jwtToken);


  const fetchData = async () => {
    // console.log(id);
    // console.log(make);
    // console.log(model);
    
    
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
        body: JSON.stringify({id, make, model, jwtToken}),
        
        
      });

      if (!res.ok) {
        throw new Error(`Request failed with status: ${res.status}`);
      }
    } catch (error) {
      console.error("Error:", error);
    }
  };

  

  const toggleFilled = () => {
    // Call API
    if (isFilled == false) {
      setIsFilled(true);
      fetchData();
    }
    
  };

  return (
    <td  style={{ cursor: "pointer" }}>
      <FontAwesomeIcon
        onClick={() => toggleFilled()}
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
