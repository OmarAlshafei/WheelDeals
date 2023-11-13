import React, { useState, useEffect } from "react";
import Table from "./Table";
import ModelFilter from "./ModelFilter";
import "./Filter.css";

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
          <h4 style={{ color: "#14213d" }}>
            <strong>WELCOME</strong> TO OUR WEBSITE
          </h4>
          <p style={{ marginTop: "19px", fontSize: "larger" }}>
            We are CS seniors at University of Central Florida. This is a course
            project. Our mission is to provide you the top popular cars and
            their sale distributions to boost up your business.
          </p>
        </div>
        {/* Search start */}

        <div className="filtersContainer flex-item">
          <div className="search-header">
            <h4 style={{ color: "#14213d" }}>
              <strong>SEARCH</strong> OUR INVENTORY
            </h4>
          </div>

          <select value={currentMake} onChange={handleChange}>
            <option value="">Select a make</option>
            {options.map((option, index) => (
              <option>{option}</option>
            ))}
          </select>

          <ModelFilter currentMake={currentMake} />
        </div>
      </div>
    </>
  );
};

export default MakeFilter;
