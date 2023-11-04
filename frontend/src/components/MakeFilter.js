import React, { useState, useEffect } from "react";

const MakeFilter = () => {
  // options array
  const options = [
    { Makes: "Make", value: "" },
    { Makes: "Toyota" },
    { Makes: "Lexus" },
    { Makes: "BMW" },
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
  const [make, setMake] = useState("");

  const handleChange = (event) => {
    setMake(event.target.value);
  };

  return (
    <div>
      <select value={make} onChange={handleChange}>
        {options.map((option) => (
          <option value={option.Makes}>{option.Makes}</option>
        ))}
      </select>
    </div>
  );
};

export default MakeFilter;
