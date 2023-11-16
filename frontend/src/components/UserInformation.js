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
      var userEmail = ud.email;
      //var password = ud.password
    //const [message, setMessage] = useState("");
 
  //const [readOnly, setReadOnly] = useState(true);
  const [editing, setEditing] = useState(false);

  let viewMode = {};
  let editMode = {};
  if (editing) {
    viewMode.display = 'none';
  } else {
    editMode.display = 'none';
  }

  const handleEditing = () => {
    setEditing(true);
  };


  return (
    <div>
      {/* header */}
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
            MY ACCOUNT
          </a>
        </div>
      </div>
     
     {/* info boxes */}
    <div className="display-info" >
      <p id="infoTitle">Fist Name</p>

        <input
          type="text"
          value={firstName}
          className="info-box"
          id="info"
        />
        <p id="infoTitle">Last Name</p>
         <input
          type="text"
          value={lastName}
          className="info-box"
          id="info"
        />
        <p id="infoTitle">Username</p>
        <input
          type="text"
          value={userName}
          className="info-box"
          id="info"
        />
        <p id="infoTitle" >Email</p>
         <input
          type="text"
          value={userEmail}
          className="info-box"
          id="info"
        />
         <button variant="primary"  className="search-button" onClick={handleEditing}>
            Edit
            <FontAwesomeIcon icon={faEdit} style={{color: "#080808", paddingLeft:'20px'}} />
          </button>

         
    </div>
    </div>
  );
};

export default UserInfomation;
