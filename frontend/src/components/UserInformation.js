import React, { useEffect, useState } from "react";
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import Image from 'react-bootstrap/Image';
import Container from 'react-bootstrap/Container';
import ImageHeader from "./headerImg.jpg";

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
      <div style={{ position: 'absolute', top: '50%', right: '60%', transform: 'translate(-50%, -50%)', zIndex: '1', textAlign: 'center', color: 'white' }}>
        <h1>My Account</h1>
      </div>
      <Image src={ImageHeader} fluid style={{ width: '100%',  height: '700px' }} />

      <div style={{color: 'black',  textAlign: 'center' }}>
        <h1>Manage Account</h1>
      </div>
     
    <Form className="mx-3 mx-md-5">
      <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
        <Form.Label>First Name</Form.Label>
        <Form.Control
          type="email"
          placeholder={firstName}
          readOnly={readOnly}
          style={{ maxWidth: '400px' }} 
        />
      </Form.Group>
      <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
        <Form.Label>Last Name</Form.Label>
        <Form.Control
          type="email"
          placeholder={lastName}
          readOnly={readOnly}
          style={{ maxWidth: '400px' }} 
        />
      </Form.Group>
      <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
        <Form.Label>Username</Form.Label>
        <Form.Control
          type="email"
          placeholder={userName}
          readOnly={readOnly}
          style={{ maxWidth: '400px' }} 
        />
      </Form.Group>
      <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
        <Form.Label>Email</Form.Label>
        <Form.Control
          type="email"
          placeholder={email}
          readOnly={readOnly}
          style={{ maxWidth: '400px' }} 
        />
      </Form.Group>
      <Button variant="primary" onClick={handleEditClick}>
        Edit
      </Button>
    </Form>
    </div>
  );
};

export default UserInfomation;
