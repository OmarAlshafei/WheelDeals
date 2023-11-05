import React from "react";
import Slideshow from "../components/Slideshow";
import Table from "../components/Table";
import MakeFilter from "../components/MakeFilter";

const HomePage = () => {
  return (
    <div className="HomePage">
      <MakeFilter />
      <Slideshow />
      <Table />
    </div>
  );
};

export default HomePage;
