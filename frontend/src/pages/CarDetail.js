import React, { useState, useEffect } from "react";
import HeartIcon from "../components/HeartIcon";
import Histogram from "../components/Histogram";
import "./CarDetail.css";
import image from "./headerImg.jpg";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faInfoCircle,
  faCircleInfo 
} from "@fortawesome/free-solid-svg-icons";


const CarDetail = (props) => {
  let { make, model } = props.location.state;
  const [detail, setDetail] = useState([]);
  const jwtToken = localStorage.getItem("jwt");

  const [isPopupVisible, setPopupVisibility] = useState(false);
  const handleIconClick = () => {
    setPopupVisibility(!isPopupVisible);
  };

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
          <a href="/cardetail" className="favorites-title">
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
        <div className="header-like">
        <HeartIcon favMake={make} favModel={model} />
        </div>
      </div>    
      <div className="header-price">
        <p id="carPrice"> Price: ${detail.price}</p>
      </div>
      <div className="body">
        <div className="searchImage">
        <img src={detail.image} className="carImage"></img>
        </div>
        <div className="histogramHeader">
          <div className="histogramInfo">
            <h2 id="text-glow" >Price Distribution Histogram</h2>
            <FontAwesomeIcon icon={faInfoCircle} onClick={handleIconClick} style={{color: "#080808", paddingLeft:'20px'}} />
          </div>
          {isPopupVisible && (
            <div className="popup">
              <p>Use this graph to help decide if a car’s price is right for you.</p>
              <p>The histogram organizes data by prices and visually represents the quantity of cars sold at each price point to give you a comprehensive picture of the market, 
              so that you can easily recognize a fair price for the car you want. 
            </p>
            </div>
          )}
        </div>
        <div className="histogramGraph">
         <Histogram data={detail.histogramData} />
        </div>
      </div>


    </div>
  );
};

export default CarDetail;
