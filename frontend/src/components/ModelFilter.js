import React, { useState, useEffect } from "react";
import { Link, NavLink } from "react-router-dom";

const ModelFilter = (props) => {
  const { currentMake } = props;
  const [options, setOptions] = useState([]);

  const fetchData = async () => {
    try {
      const app_name = "wheeldeals-d3e9615ad014";
      const route = "api/models";
      const apiUrl =
        process.env.NODE_ENV === "production"
          ? `https://${app_name}.herokuapp.com/${route}`
          : `http://localhost:9000/${route}`;

      const res = await fetch(apiUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ make: currentMake,  jwtToken: localStorage.getItem("jwt") }),
      });
      
      if (!res.ok) {
        throw new Error(`Request failed with status: ${res.status}`);
      }

      const data = await res.json();
      setOptions(data);
    } catch (error) {
      console.error("Error:", error);
    }
  };

  useEffect(() => {
    if (currentMake) {
      fetchData();
    }
  }, [currentMake]);

  const [model, setModel] = useState("");

  const handleChange = (event) => {
    setModel(event.target.value);
  };

  return (
    <div>
      <select value={model} onChange={handleChange}>
        <option value="">Select a model</option>
        {options.map((option) => (
          <option key={option}>{option}</option>
        ))}
      </select>
      <Link
        to={{
          pathname: "/cardetail",
          state: { make: currentMake, model: model },
        }}
      >
        search
      </Link>
    </div>
  );
};

export default ModelFilter;
