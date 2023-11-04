import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart } from "@fortawesome/free-regular-svg-icons";

const Table = () => {
  // Fetch table data here(fetch not working Nov 4)
  // const app_name = "wheeldeals-d3e9615ad014";
  // function buildPath(route) {
  //   if (process.env.NODE_ENV === "production") {
  //     return "https://" + app_name + ".herokuapp.com/" + route;
  //   } else {
  //     return "http://localhost:9000/" + route;
  //   }
  // }

  // var make;
  // var model;
  // var year;
  // var price;

  // useEffect(() => {
  //   fetch(buildPath("api/homepage"))
  //     .then((response) => response.json())
  //     .then((data) => console.log(data));
  // }, []);

  //Temporary template
  const [newCars, setNewCars] = useState([
    {
      Type: "Truck",
      Make: "Ford",
      Model: "F-150",
      Year: "2021",
      Price: "50,000",
      id: 1,
    },
    {
      Type: "SUV",
      Make: "Toyota",
      Model: "CS350",
      Year: "2023",
      Price: "20,000",
      id: 2,
    },
    {
      Type: "Sedan",
      Make: "Lexus",
      Model: "F-150",
      Year: "2021",
      Price: "50,000",
      id: 3,
    },
  ]);

  return (
    <table
      className="table table-hover align-middle mb-0 bg-white"
      style={{ marginTop: "30px" }}
    >
      <thead className="bg-light">
        <tr>
          <th>Icon</th>
          <th>Make</th>
          <th>Model</th>
          <th>Year</th>
          <th>Price</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {/* Template for table values */}
        {newCars.map((car) => (
          <tr key={car.id}>
            <td>{car.Type}</td>
            <td>{car.Make}</td>
            <td>{car.Model}</td>
            <td>{car.Year}</td>
            <td>{car.Price}</td>
            <td>
              <FontAwesomeIcon
                icon={faHeart}
                style={{ color: "#ff0000", paddingLeft: "20px" }}
              />
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default Table;
