import React, { useState, useEffect } from "react";

const ModelFilter = (props) => {
  const currentMake = props.currentMake;
  console.log(currentMake);

  // options array
  let [options, setOptions] = useState([]);

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
    try {
      let res = await fetch(buildPath("api/models"), {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ make: currentMake }),
      });
      setOptions(await res.json());
      //console.log(options);
    } catch (error) {
      console.log("error");
      return;
    }
  };

  useEffect(() => {
    fetchData();
  }, [currentMake]);

  //   Set value for each make and change the table display based on the value
  const [model, setModel] = useState("");

  const handleChange = (event) => {
    setModel(event.target.value);
  };

  return (
    <div>
      <select value={model} onChange={handleChange}>
        {options.map((option) => (
          <option>{option}</option>
        ))}
      </select>
    </div>
  );
};

export default ModelFilter;
