import React from "react";
import Slideshow from "../components/Slideshow";
import Table from "../components/Table";
import MakeFilter from "../components/MakeFilter";
import "./HomePage.css";

const HomePage = () => {
  return (
    <div className="HomePage">
      <Slideshow />
      <MakeFilter />
      <Table />
    </div>
  );
};

export default HomePage;
