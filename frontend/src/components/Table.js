import React, { useState, useEffect, lazy, Suspense } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart } from "@fortawesome/free-regular-svg-icons";
import MakeFilter from "./MakeFilter";
import ModelFilter from "./ModelFilter";
import "./Table.css";

const Table = () => {
  //Temporary template
  //newCars is an arry of object
  //setNewCars used to change the array value
  const [newCars, setNewCars] = useState([]);

  // Fetch table data here(fetch not working Nov 4)
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
      let res = await fetch(buildPath("api/homepage"), {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      });
      if (!res.ok) {
        throw new Error(`Request failed with status: ${res.status}`);
      }

      const data = await res.json();

      if (data.matchedCars) {
        setNewCars(data.matchedCars);
        console.log(data.matchedCars);
      } else {
        console.log("No 'matchedCars' found");
      }
    } catch (error) {
      console.error("Error: " + error.message);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <>
      <div className="filterRow">
        <MakeFilter />
        <ModelFilter />
        {/* {make !== '' && (
        <ModelFilter style={{marginLeft: '20px'}}/>
      )} */}
      </div>
      <table
        className="table table-hover align-middle mb-0 bg-white"
        style={{ marginTop: "30px" }}
      >
        <thead className="bg-light">
          <tr>
            <th>Rank</th>
            <th>Type</th>
            <th>Brand</th>
            <th>Model</th>
            <th>Price</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {newCars.map((car) => (
            <tr>
              <td>{car.rank}</td>
              <td>{car.type}</td>
              <td>{car.brand}</td>
              <td>{car.model}</td>
              <td>{car.price}</td>
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
    </>
  );
};

export default Table;
