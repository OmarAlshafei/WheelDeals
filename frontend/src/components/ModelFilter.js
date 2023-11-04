import React, { useState, useEffect } from "react";

const ModelFilter = () => {
  // options array
  const options = [
    { Model: "Model", value: "" },
    { Model: "A" },
    { Model: "B" },
    { Model: "C" },
  ];

  // Fetch makes API when they land the page
  //   const app_name = "wheeldeals-d3e9615ad014";
  //   function buildPath(route) {
  //     if (process.env.NODE_ENV === "production") {
  //       return "https://" + app_name + ".herokuapp.com/" + route;
  //     } else {
  //       return "http://localhost:9000/" + route;
  //     }
  //   }
  //   const fetchData = async () => {
  //     let res = await fetch(buildPath("api/makes"));
  //     let data = await res.json();
  //     console.log(data);
  //   };

  //   useEffect(() => {
  //     fetchData();
  //   }, []);

  //   Set value for each make and change the table display based on the value
  const [model, setModel] = useState("");

  const handleChange = (event) => {
    setModel(event.target.value);
  };

  return (
    <div>
      <select value={model} onChange={handleChange}>
        {options.map((option) => (
          <option value={option.Model}>{option.Model}</option>
        ))}
      </select>
    </div>
  );
};

export default ModelFilter;
