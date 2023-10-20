import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import "./App.css";
import LoginPage from "./pages/LoginPage";
import HomePage from "./pages/HomePage";

function App() {
  return (
    <Router>
      <Switch>
        <Route path="/">
          <HomePage />
          {/* <LoginPage /> */}
        </Route>
        <Route path="/signin">
          <LoginPage />
        </Route>
      </Switch>
    </Router>
  );
}

export default App;
