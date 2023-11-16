import React, { useState, useEffect } from "react";
import HeartIcon from "../components/HeartIcon";
import Histogram from "../components/Histogram";
import "./CarDetail.css";
import image from "./headerImg.jpg";

const CarDetail = (props) => {
  let { make, model } = props.location.state;
  const [detail, setDetail] = useState([]);
  const jwtToken = localStorage.getItem("jwt");

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
        body: JSON.stringify({ make: make, model: model, jwtToken: jwtToken }),
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
      <div className="favorites-header">
        <div className="image-container">
          <img
            src={image} 
            alt="My Favorites"
            className="img-fluid"
          />
        </div>
        <div className="title-container">
          <a href="/favorites" className="favorites-title">
          CAR DETAILS
          </a> 
        </div>
      </div>

      {/* <h1>Car Details</h1> */}
      <div className="header-container">
        <div className="header-brand">
          <p id="carInfo">{make}</p>
          {/* <img src={detail.brandLogo}></img> */}
        </div>
        <div className="header-model">
          <p id="carInfo">{model}</p>
        </div>
        <div className="header-type">
          <p id="carInfo">{detail.type}</p>
        </div>
        <HeartIcon favMake={make} favModel={model} />
      </div>    
      <div className="header-price">
        <p id="carInfo">${detail.price}</p>
      </div>
      <div className="body">
        <div className="searchImage">
        <img src={detail.image} className="carImage"></img>
        </div>
        <h3 className="histogram-header">Histogram: percentage of cars sold based on bucket price</h3>
        <div className="histogramGraph">
        <Histogram data={detail.histogramData} />
        </div>
      </div>


    </div>
  );
};

export default CarDetail;
