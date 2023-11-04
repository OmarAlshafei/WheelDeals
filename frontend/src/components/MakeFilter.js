import React, { useState, useEffect } from "react";
import Table from "./Table";

const MakeFilter = () => {
  // options array
  const [options, setOptions] = useState([]);

  // Fetch makes API when they land the page, API returns an array of strings
  const app_name = "wheeldeals-d3e9615ad014";
  function buildPath(route) {
    if (process.env.NODE_ENV === "production") {
      return "https://" + app_name + ".herokuapp.com/" + route;
    } else {
      return "http://localhost:9000/" + route;
    }
  }
  const fetchData = async () => {
    let res = await fetch(buildPath("api/makes"), {
      method: "POST",
      headers: { "Content-Type": "application/json" },
    });
    setOptions(await res.json());
    // options.push(data);
    // console.log(options);
    console.log(options);
  };

  useEffect(() => {
    fetchData();
  }, []);

  //   Set value for each make and change the table display based on the value
  const [currentMake, setMake] = useState("");

  const handleChange = (event) => {
    setMake(event.target.value);
  };

  return (
    <div>
      <select value={currentMake} onChange={handleChange}>
        {options.map((option, index) => (
          <option>{option}</option>
        ))}
      </select>
      {/* <Table make={make} /> */}
    </div>
  );
};

export default MakeFilter;
