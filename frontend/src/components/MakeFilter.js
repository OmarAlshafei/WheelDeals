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
    <div className="filtersContainer">
      <select value={currentMake} onChange={handleChange}>
        <option value="">Select a make</option>
        {options.map((option, index) => (
          <option>{option}</option>
        ))}
      </select>
      <ModelFilter currentMake={currentMake} />
    </div>
  );
};

export default MakeFilter;
