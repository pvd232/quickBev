import Dashboard from "./dashboard/Dashboard.js";
import { useState, useEffect } from "react";
import { Merchant, Business, setLocalStorage } from "../Models.js";
import API from "../helpers/Api.js";

const Home = () => {
  const [list, setList] = useState([]);

  useEffect(() => {
    let mounted = true;
    API.getOrders().then((items) => {
      console.log("items", items);
      if (mounted) {
        setList(items);
      }
    });
    return () => (mounted = false);
  }, []);
  return <Dashboard orderArray={list}></Dashboard>;
};
export default Home;
