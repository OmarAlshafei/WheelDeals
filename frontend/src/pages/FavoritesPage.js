import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart } from "@fortawesome/free-regular-svg-icons";
import { Link, NavLink, useHistory } from "react-router-dom";
import HeartIcon from "../components/HeartIcon";

const FavoritesPage = () => {
  const userDataString = localStorage.getItem("user_data");
  const userData = JSON.parse(userDataString);
  const [newCars, setNewCars] = useState([]);
  const [id, setId] = useState(userData.id);

  useEffect(() => {
    const jwtToken = localStorage.getItem("jwt");

    const getFavorite = async () => {
      try {
        const app_name = "wheeldeals-d3e9615ad014";
        const route = "api/getfavorites";
        const apiUrl =
          process.env.NODE_ENV === "production"
            ? `https://${app_name}.herokuapp.com/${route}`
            : `http://localhost:9000/${route}`;

        const res = await fetch(apiUrl, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ id, jwtToken }),
        });

        if (!res.ok) {
          throw new Error(`Request failed with status: ${res.status}`);
        }

        const result = await res.json();
        setNewCars(result["favorites"]);
      } catch (error) {
        console.error("Error:", error);
      }
    };

    getFavorite();
  }, [newCars]);

  const history = useHistory();

  const handleRowClick = (item) => {
    // Use history.push to navigate to the details page and pass data as state
    history.push({
      pathname: "/cardetail",
      state: { make: item.make, model: item.model },
    });
  };

  return (
    <>
      <h1 className="tableTitle">Your favorite cars</h1>
      <table
        className="table table-hover align-middle mb-0 bg-white"
        style={{ marginTop: "30px" }}
      >
        <thead className="bg-light">
          <tr>
            <th>Number</th>
            <th>Type</th>
            <th>Brand</th>
            <th>Model</th>
            <th>Price</th>
            <th>Favorite</th>
          </tr>
        </thead>
        <tbody>
          {newCars.map((car, index) => (
            <tr key={index}>
              <td onClick={() => handleRowClick(car)}>{index + 1}</td>
              <td onClick={() => handleRowClick(car)}>{car.type}</td>
              <td onClick={() => handleRowClick(car)}>{car.make}</td>
              <td onClick={() => handleRowClick(car)}>{car.model}</td>
              <td onClick={() => handleRowClick(car)}>${car.price}</td>
              <HeartIcon favMake={car.make} favModel={car.model} />
            </tr>
          ))}
        </tbody>
      </table>
    </>
  );
};

export default FavoritesPage;
