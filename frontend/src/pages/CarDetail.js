import React, { useState, useEffect } from "react";
import HeartIcon from "../components/HeartIcon";

const CarDetail = (props) => {
  let { make, model } = props.location.state ;
  const [detail, setDetail] = useState([]);
  //const jwtToken = localStorage.getItem("jwt");

  const fetchData = async () => {
    try {
      const app_name = "wheeldeals-d3e9615ad014";
      const route = "api/search";
      const apiUrl =
        process.env.NODE_ENV === "production"
          ? `https://${app_name}.herokuapp.com/${route}`
          : `http://localhost:9000/${route}`;

      const res = await fetch(apiUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ make: make, model: model }),
      });

      if (!res.ok) {
        throw new Error(`Request failed with status: ${res.status}`);
      }

      const data = await res.json();
      setDetail(data);
      console.log(data);
    } catch (error) {
      console.error("Error:", error);
    }
  };

  useEffect(() => {
    console.log("test search API");
    fetchData();
  }, []);

  return (
    <div>
      <h1>Car Detail</h1>
      {/* <HeartIcon  /> */}
      <HeartIcon favMake={make} favModel={model} />
      <div className="header-brand">
        <p>Brand: {make}</p>
        <img src={detail.brandLogo}></img>
      </div>
      <div className="body">
        <p>Type: {detail.type}</p>
        <p>Model: {model}</p>
        <p>Price: ${detail.price}</p>
        <img src={detail.image} className="carImage"></img>
      </div>
    </div>
  );
};

export default CarDetail;
