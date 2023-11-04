import "./App.css";
import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import SigninPage from "./pages/SigninPage";
import HomePage from "./pages/HomePage";
import TestPage from "./pages/TestPage";
import Navbar from "./components/Navbar";
import AccountPage from "./pages/AccountPage";
import FavoritesPage from "./pages/FavoritesPage";
import LandingPage from "./pages/LandingPage";
import Modal from "./components/Modal";

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/" component={LandingPage} />
        {/* <Route exact path="/" component={Modal} /> */}
        <div>
          <Navbar />
          <Route path="/home" component={HomePage} />
          <Route path="/signin" component={SigninPage} />
          <Route path="/cards" component={TestPage} />
          <Route path="/account" component={AccountPage} />
          <Route path="/favorites" component={FavoritesPage} />
        </div>
      </Switch>
    </Router>
  );
}

export default App;
