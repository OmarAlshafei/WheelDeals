import React from "react";
import Navbar from "../components/Navbar";
import Slideshow from "../components/Slideshow";
import Table from "../components/Table";

const HomePage = () => {
  return (
    <div className="HomePage">
      <Navbar />
      <Slideshow />
      <Table />
    </div>
  );
};

export default HomePage;
