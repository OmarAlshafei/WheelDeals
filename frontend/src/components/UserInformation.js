import React, { useEffect, useState } from "react";
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEdit } from '@fortawesome/free-regular-svg-icons'
import image from "../assets/fav-header5.jpg";
import "./UserInformation.css";

const UserInfomation = (props) => {
      var _ud = localStorage.getItem('user_data');
      var ud = JSON.parse(_ud);
      var userId = ud.id;
      var firstName = ud.firstName;
      var lastName = ud.lastName;
      var userName = ud.userName
      var email = ud.email;
      //var password = ud.password
    const [message, setMessage] = useState("");

  const [readOnly, setReadOnly] = useState(true);

  const handleEditClick = () => {
    setReadOnly(false);
  };


  return (
    <div>
     <div className="favorites-header">
        <div className="image-container">
          <img
            src={image} 
            alt="My Favorites"
            className="img-fluid"
          />
        </div>
        <div className="title-container">
          <a href="/favorites" className="favorites-title">
            MY PROFILE
          </a>
        </div>
      </div>
     
    <div className="display-info">
    <Form className="mx-3 mx-md-5">
      <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
        <Form.Label>First Name </Form.Label>
        <Form.Control
          type="text"
          placeholder={firstName}
          readOnly={readOnly}
          className="info-box"
        />
      </Form.Group>
      <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
        <Form.Label>Last Name</Form.Label>
        <Form.Control
          type="text"
          placeholder={lastName}
          readOnly={readOnly}
          className="info-box"
        />
      </Form.Group>
      <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
        <Form.Label>Username</Form.Label>
        <Form.Control
          type="text"
          placeholder={userName}
          readOnly={readOnly}
          className="info-box"
        />
      </Form.Group>
      <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
        <Form.Label>Email</Form.Label>
        <Form.Control
          type="email"
          placeholder={email}
          readOnly={true}
          className="info-box"
        />
      </Form.Group>
  
      <button variant="primary"  className="search-button" onClick={handleEditClick}>
        Edit
        <FontAwesomeIcon icon={faEdit} style={{color: "#080808", paddingLeft:'20px'}} />
      </button>
    </Form>
    </div>
    </div>
  );
};

export default UserInfomation;
