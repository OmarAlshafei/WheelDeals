import React, { useState, useEffect } from "react";
import Table from "./Table";
import ModelFilter from "./ModelFilter";
import "./Filter.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faRankingStar } from "@fortawesome/free-solid-svg-icons";
import { faChartSimple } from "@fortawesome/free-solid-svg-icons";
import { faHeart } from "@fortawesome/free-solid-svg-icons";

const MakeFilter = () => {
  let [options, setOptions] = useState([]);

  const app_name = "wheeldeals-d3e9615ad014";
  function buildPath(route) {
    if (process.env.NODE_ENV === "production") {
      return "https://" + app_name + ".herokuapp.com/" + route;
    } else {
      return "http://localhost:9000/" + route;
    }
  }
  const fetchData = async () => {
    try {
      let res = await fetch(buildPath("api/makes"), {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ jwtToken: localStorage.getItem("jwt") }),
      });
      setOptions(await res.json());
    } catch (error) {
      console.log("error");
      return;
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const [currentMake, setMake] = useState("");

  const handleChange = (event) => {
    setMake(event.target.value);
  };

  return (
    <>
      <div className="flex-container">
        {/* welcome start */}
        <div className="flex-item">
          <h1 style={{ color: "#14213d", marginBottom: "5%" }}>
            EXPLORE OUR WEBSITE
          </h1>
          {/* Banner with blue background */}
          <div className="banner blue-background">
            <div>
              <FontAwesomeIcon
                icon={faRankingStar}
                className="fa-4x"
                style={{ color: "#fca311" }}
              />
              <p>Top 25</p>
            </div>

            <div>
              <FontAwesomeIcon
                icon={faChartSimple}
                className="fa-4x"
                style={{ color: "#fca311" }}
              />
              <p>Sale Distribution</p>
            </div>

            <div>
              <FontAwesomeIcon
                icon={faHeart}
                className="fa-4x"
                style={{ color: "#fca311" }}
              />
              <p>Favorites</p>
            </div>
          </div>
        </div>
        {/* Search start */}

        <div className="filtersContainer flex-item">
          <div className="search-header">
            <h1
              style={{
                color: "#14213d",
                marginBottom: "0",
                marginBottom: "5%",
              }}
            >
              SEARCH OUR INVENTORY
            </h1>
          </div>

          <div style={{ display: "flex", flexDirection: "row", gap: "100px" }}>
            <select value={currentMake} onChange={handleChange}>
              <option value="">Select a make</option>
              {options.map((option, index) => (
                <option key={index}>{option}</option>
              ))}
            </select>
            <ModelFilter currentMake={currentMake} />
          </div>
        </div>
      </div>
    </>
  );
};

export default MakeFilter;
