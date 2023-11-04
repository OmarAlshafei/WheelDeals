import React, { useEffect, useState } from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEdit } from '@fortawesome/free-regular-svg-icons'

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
    <div class="container py-5">
      <div class="row d-flex justify-content-center align-items-center">
        <div class="col">
          <div class="card my-4 shadow-3">
            <div class="row g-0">
              <div class="col-xl-6 d-xl-block bg-image">
                <img src="https://images.pexels.com/photos/3264504/pexels-photo-3264504.jpeg?auto=compress&cs=tinysrgb&w=800" alt="Sample photo"
                  class="img-fluid" />
              </div>
              <div class="col-xl-6">
                <div class="card-body p-md-5 text-black">
                  <h3 class="mb-4 text-uppercase">Account Information</h3>

                  <div class="row">
                    <div class="col-md-6 mb-4" >
                    <div class="form-outline">
                    <input type="fname" class="form-control" id="exampleFormControlInput1" placeholder=""/>
                    <label class="form-label" for="form3Example1m">First name</label>
                  </div>
                    </div>
                    <div class="col-md-6 mb-4">
                      <div class="form-outline">
                      <input type="lname" class="form-control" id="exampleFormControlInput1" placeholder=""/>
                        <label class="form-label" for="form3Example1n">Last name</label>
                      </div>
                    </div>
                  </div>

                  <div class="form-outline mb-4">
                    <input type="email" id="form3Example8" class="form-control form-control-lg" />
                    <label class="form-label" for="form3Example8">Email</label>
                  </div>

                  <div class="row">
                    
                    {/* <button type="button" class="btn btn-success btn-lg ms-2" style={{color: "grey"}}>Edit</button> */}
                    <button type="button" style={{color: "grey", marginBottom: '10px'}}>
                      Edit Information
                      <FontAwesomeIcon icon={faEdit} style={{color: "#080808", paddingLeft:'20px'}} />
                    </button>
                    <button type="button" style={{color: "grey"}}>
                      Edit Password
                      <FontAwesomeIcon icon={faEdit} style={{color: "#080808", paddingLeft:'20px'}} />
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
