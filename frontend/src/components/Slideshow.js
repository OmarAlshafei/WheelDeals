import "bootstrap/dist/css/bootstrap.min.css";
import Carousel from "react-bootstrap/Carousel";
import React, { useState, useEffect } from "react";
import Image1 from "./Toyota_Rav4.jpg";
import Image2 from "./Toyota_Corolla.jpg";
import Image3 from "./Toyota_Camry.jpg";
import "./Slideshow.css";

const Slideshow = () => {
  const [index, setIndex] = useState(0);
  const handleSelect = (selectedIndex) => {
    setIndex(selectedIndex);
  };
  const [detail, setDetail] = useState([]);
  const jwtToken = localStorage.getItem("jwt");
  const fetchData1 = async () => {
    try {
      const app_name = "wheeldeals-d3e9615ad014";
      const route = "api/search";
      const apiUrl =
        process.env.NODE_ENV === "production"
          ? `https://${app_name}.herokuapp.com/${route}`
          : `http://localhost:9000/${route}`;

      const res = await fetch(apiUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          make: "Toyota",
          model: "Rav4",
          jwtToken: jwtToken,
        }),
      });

      if (!res.ok) {
        throw new Error(`Request failed with status: ${res.status}`);
      }

      const data = await res.json();
      setDetail(data);
      console.log("slideshow testing: ");
      console.log(data);
    } catch (error) {
      console.error("Error:", error);
    }
  };

  useEffect(() => {
    console.log("test search API");
    fetchData1();
  }, []);

  return (
    <Carousel
      activeIndex={index}
      onSelect={handleSelect}
    >
      <Carousel.Item>
        <img
          className="d-block w-100"
          src={Image1}
          style={{
            height: "600px",
            marginTop: "50px",
            marginBottom: "10px",
            paddingRight: "50px",
            paddingLeft: "50px",
          }}
          alt="Car 1"
        />
        <Carousel.Caption>
          <h3>Toyota Rav4</h3>
          <p>Top 1</p>
        </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        <img
          src={Image2}
          className="d-block w-100"
          style={{
            height: "600px",
            marginTop: "50px",
            marginBottom: "10px",
            paddingRight: "50px",
            paddingLeft: "50px",
          }}
          alt="Car 2"
        />
        <Carousel.Caption>
          <h3>Toyota Corolla</h3>
          <p>Top 2</p>
        </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        <img
          src={Image3}
          className="d-block w-100"
          style={{
            height: "600px",
            marginTop: "50px",
            marginBottom: "10px",
            paddingRight: "50px",
            paddingLeft: "50px",
          }}
          alt="Car 3"
        />
        <Carousel.Caption>
          <h3>Toyota Camry</h3>
          <p>Top 3</p>
        </Carousel.Caption>
      </Carousel.Item>
    </Carousel>
  );
};

export default Slideshow;
