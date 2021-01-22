import React from "react";
import { Switch, Route } from "react-router-dom";

import Home from "./pages/Home.js";
import Signup from "./pages/Signup.js";
import PayoutSetupCallback from "./pages/PayoutSetupCallback.js";

const Main = () => {
  return (
    <Switch>
      {/* The Switch decides which component to show based on the current URL.*/}
      <Route exact path="/home" component={Home}></Route>
      <Route exact path="/signup" component={Signup}></Route>
      <Route
        exact
        path="/payout-setup-callback"
        component={PayoutSetupCallback}
      ></Route>
    </Switch>
  );
};

export default Main;
