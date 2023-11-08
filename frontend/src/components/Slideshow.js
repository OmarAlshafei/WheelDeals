import React from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import Carousel  from "react-bootstrap/Carousel";
import { useState } from 'react';

const Slideshow = () => {

  const [index, setIndex] = useState(0); 
  const handleSelect = (selectedIndex) => {
    setIndex(selectedIndex);
  };

  return (
    <Carousel activeIndex={index} onSelect={handleSelect}>
    <Carousel.Item>
    <img src="https://images.pexels.com/photos/3422964/pexels-photo-3422964.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" class="d-block w-100" style={{height: '600px', marginTop: '50px', marginBottom: '10px', paddingRight: '50px', paddingLeft: '50px'}} alt="Car 1"/>
      <Carousel.Caption>
        <h3>First car label</h3>
        <p>Caption.</p>
      </Carousel.Caption>
    </Carousel.Item>
    <Carousel.Item>
    <img src="https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" class="d-block w-100" style={{height: '600px', marginTop: '50px', marginBottom: '10px', paddingRight: '50px', paddingLeft: '50px'}} alt="Car 2"/>
      <Carousel.Caption>
        <h3>Second car label</h3>
        <p>Caption.</p>
      </Carousel.Caption>
    </Carousel.Item>
    <Carousel.Item>
    <img src="https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" class="d-block w-100" style={{height: '600px', marginTop: '50px', marginBottom: '10px', paddingRight: '50px', paddingLeft: '50px'}} alt="Car 3"/>
      <Carousel.Caption>
        <h3>Third car label</h3>
        <p>Caption</p>
      </Carousel.Caption>
    </Carousel.Item>
  </Carousel>
  );
};

export default Slideshow;
