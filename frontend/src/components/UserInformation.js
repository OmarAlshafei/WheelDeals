import React, { useEffect, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEdit } from "@fortawesome/free-regular-svg-icons";
import { underscore } from "i/lib/methods";

const UserInfomation = (props) => {
  //     var _ud = localStorage.getItem('user_data');
  //     var ud = JSON.parse(_ud);
  //     var userId = ud.id;
  //     var firstName = ud.firstName;
  //     var lastName = ud.lastName;
  //     var userName = ud.userName
  //     var email = ud.email;
  //     //var password = ud.password
  //   const [message, setMessage] = useState("");

  return (
    <div className="container py-5">
      <div className="row d-flex justify-content-center align-items-center">
        <div className="col">
          <h1
            style={{ textDecoration: "underline", textUnderlineOffset: "10px" }}
          >
            MY PROFILE
          </h1>
          <div className="card my-4 shadow-3">
            <div className="row g-0">
              <div className="col-xl-6 d-xl-block bg-image">
                <img
                  src="https://images.pexels.com/photos/3264504/pexels-photo-3264504.jpeg?auto=compress&cs=tinysrgb&w=800"
                  alt="Sample photo"
                  className="img-fluid"
                />
              </div>
              <div className="col-xl-6">
                <div className="card-body p-md-5 text-black">
                  <h4 className="mb-4 text-uppercase">Manage Account</h4>

                  <div class="row">
                    <div className="col-md-6 mb-4">
                      <div className="form-outline">
                        <input
                          type="fname"
                          class="form-control"
                          id="exampleFormControlInput1"
                          placeholder=""
                        />
                        <label className="form-label" for="form3Example1m">
                          First name
                        </label>
                      </div>
                    </div>
                    <div className="col-md-6 mb-4">
                      <div className="form-outline">
                        <input
                          type="lname"
                          className="form-control"
                          id="exampleFormControlInput1"
                          placeholder=""
                        />
                        <label className="form-label" for="form3Example1n">
                          Last name
                        </label>
                      </div>
                    </div>
                  </div>

                  <div className="form-outline mb-4">
                    <input
                      type="email"
                      id="form3Example8"
                      className="form-control form-control-lg"
                    />
                    <label className="form-label" for="form3Example8">
                      Email
                    </label>
                  </div>

                  <div className="row">
                    {/* <button type="button" className="btn btn-success btn-lg ms-2" style={{color: "grey"}}>Edit</button> */}
                    <button
                      type="button"
                      style={{ color: "grey", marginBottom: "10px" }}
                    >
                      Edit Information
                      <FontAwesomeIcon
                        icon={faEdit}
                        style={{ color: "#080808", paddingLeft: "20px" }}
                      />
                    </button>
                    <button type="button" style={{ color: "grey" }}>
                      Edit Password
                      <FontAwesomeIcon
                        icon={faEdit}
                        style={{ color: "#080808", paddingLeft: "20px" }}
                      />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default UserInfomation;
