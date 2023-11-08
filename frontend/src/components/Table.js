import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart } from "@fortawesome/free-regular-svg-icons";
import HeartIcon from "./HeartIcon";
import "./Table.css";
import { Link, NavLink, useHistory } from "react-router-dom";

const Table = () => {
  const [newCars, setNewCars] = useState([]);

  const fetchData = async () => {
    try {
      const app_name = "wheeldeals-d3e9615ad014";
      const route = "api/homepage";
      const apiUrl =
        process.env.NODE_ENV === "production"
          ? `https://${app_name}.herokuapp.com/${route}`
          : `http://localhost:9000/${route}`;

      const res = await fetch(apiUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      });

      if (!res.ok) {
        throw new Error(`Request failed with status: ${res.status}`);
      }

      const data = await res.json();

      if (data.matchedCars) {
        setNewCars(data.matchedCars);
      } else {
        console.log("No 'matchedCars' found");
      }
    } catch (error) {
      console.error("Error:", error);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const history = useHistory();

  const handleRowClick = (item) => {
    // Use history.push to navigate to the details page and pass data as state
    history.push({
      pathname: "/cardetail",
      state: { make: item.brand, model: item.model },
    });
  };

  return (
    <>
      <h1 className="tableTitle">Top popular cars</h1>
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
            <th>Favorite</th>
          </tr>
        </thead>
        <tbody>
          {newCars.map((car, index) => (
            <tr key={index} onClick={() => handleRowClick(car)}>
              <td>{car.rank}</td>
              <td>{car.type}</td>
              <td>{car.brand}</td>
              <td>{car.model}</td>
              <td>{car.price}</td>
              <td>
                <HeartIcon />
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  );
};

export default Table;
