import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEdit } from '@fortawesome/free-regular-svg-icons'
import UserInfomation from "../components/UserInformation";

const AccountPage = () => {
  return (
      <div className="AccountPage">
        <UserInfomation/>
      </div>
  );
};

export default AccountPage;