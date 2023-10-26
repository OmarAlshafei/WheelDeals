import "./App.css";
import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import SigninPage from "./pages/SigninPage";
import HomePage from "./pages/HomePage";
import TestPage from "./pages/TestPage";
import Navbar from "./components/Navbar";
import AccountPage from "./pages/AccountPage";
import FavoritesPage from "./pages/FavoritesPage";

function App() {
  return (
    <Router>
      <Navbar />
      <Switch>
        <Route exact path="/" component={HomePage} />
        <Route path="/home" component={HomePage} />
        <Route path="/signin" component={SigninPage} />
        <Route path="/test" component={TestPage} />
        <Route path="/cards" component={TestPage} />
        <Route path="/account" component={AccountPage} />
        <Route path="/favorites" component={FavoritesPage} />
      </Switch>
    </Router>
  );
}

export default App;
