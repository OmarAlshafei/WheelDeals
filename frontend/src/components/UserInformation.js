import React, { useState } from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faEdit, faSquareCheck } from '@fortawesome/free-regular-svg-icons';
import image from "../assets/fav-header5.jpg";
import "./UserInformation.css";

const UserInformation = (props) => {
  const jwtToken = localStorage.getItem("jwt");
  var userDataString = localStorage.getItem('user_data');
  var ud = JSON.parse(userDataString);
  var userId = ud.id;
  var firstName = ud.firstName;
  var lastName = ud.lastName;
  var userName = ud.userName;
  var userEmail = ud.email;

  const [editing, setEditing] = useState(false);
  const [editedFirstName, setEditedFirstName] = useState(firstName);
  const [editedLastName, setEditedLastName] = useState(lastName);
  const [editedUserName, setEditedUserName] = useState(userName);

  const handleEditing = () => {
    setEditing(!editing);
  };

  const handleConfirmChanges = async () => {
    setEditing(false);
  }

  // try to call modify api on handleConfirmChanges()
  // incoming: userID; new firstName, lastName and userName
  // outgoing: new firstName, lastName and userName
  
  // const handleConfirmChanges = async () => {
  //   try {
  //     const app_name = "wheeldeals-d3e9615ad014";
  //     const route = "/api/modify";
  //     const apiUrl =
  //       process.env.NODE_ENV === "production"
  //         ? `https://${app_name}.herokuapp.com/${route}`
  //         : `http://localhost:9000/${route}`;

  //     const res = await fetch(apiUrl, {
  //       method: "POST",
  //       headers: {
  //         "Content-Type": "application/json",
  //         Authorization: `Bearer ${jwtToken}`,
  //       },
  //       body: JSON.stringify({
  //         userId,
  //         newFirstName: editedFirstName,
  //         newLastName: editedLastName,
  //         newUserName: editedUserName,
  //       }),
  //     });

  //     if (!res.ok) {
  //       throw new Error(`Request failed with status: ${res.status}`);
  //     }

  //     const result = await res.json();
  //     console.log("API Response:", result);

  //     setEditing(false);
      
  //   } catch (error) {
  //     console.error("Error:", error);
  //   }
  // };

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
      <div className="display-info">
        <p id="infoTitle">First Name</p>
        {editing ? (
          <input
            type="text"
            value={editedFirstName}
            className="info-box"
            id="info"
            onChange={(e) => setEditedFirstName(e.target.value)}
          />
        ) : (
          <p>{editedFirstName}</p>
        )}
        <p id="infoTitle">Last Name</p>
        {editing ? (
          <input
            type="text"
            value={editedLastName}
            className="info-box"
            id="info"
            onChange={(e) => setEditedLastName(e.target.value)}
          />
        ) : (
          <p>{editedLastName}</p>
        )}
        <p id="infoTitle">Username</p>
        {editing ? (
          <input
            type="text"
            value={editedUserName}
            className="info-box"
            id="info"
            onChange={(e) => setEditedUserName(e.target.value)}
          />
        ) : (
          <p>{editedUserName}</p>
        )}
        <p id="infoTitle">Email</p>
        <p>{userEmail}</p>
        {editing ? (
          <button
            variant="primary"
            className="edit-button"
            onClick={handleConfirmChanges}
          >
            Confirm Changes
            <FontAwesomeIcon icon={faSquareCheck} style={{ color: "#080808", paddingLeft: '20px' }} />
          </button>
        ) : (
          <button
            variant="primary"
            className="edit-button"
            onClick={handleEditing}
          >
            Edit
            <FontAwesomeIcon icon={faEdit} style={{ color: "#080808", paddingLeft: '20px' }} />
          </button>
        )}
      </div>
    </div>
  );
};

export default UserInformation;
