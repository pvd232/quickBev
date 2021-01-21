import React, { useState, useEffect } from "react";
import Button from "react-bootstrap/Button";
import { API } from "../helpers/Api.js";
import { Redirect } from "react-router-dom";
import bankIcon from "../static/icon-bank.svg";

const PayoutSetup = (props) => {
  const [redirect, setRedirect] = useState(null);
  const [data, setData] = useState(false);
  const localAPI = new API();
  const getRedirectInfo = async () => {
    return localAPI.makeRequest(
      "post",
      `http://127.0.0.1:5000/create-stripe-account`
    );
  };

  const handleConnect = async () => {
    let response = await getRedirectInfo();
    let url = response.location;
    if (url) {
      setRedirect(url);
    }
  };
  useEffect(() => {
    //had to do this because memory leak due to component not unmounting properly
    let mount = true;
    if (data && mount) {
      setData(true);
    }

    return () => (mount = false);
  }, [data]);
  if (data) {
    return <Redirect to={redirect} />;
  } else {
    return (
      <>
        <div className="text-center box">
          <img src={bankIcon} alt="" className="icon" />
          <h3>Set up payouts to list on Kavholm</h3>
          <p>
            Kavholm partners with Stripe to transfer earnings to your bank
            account.
          </p>

          <Button
            className="btn btn-primary text-center"
            onClick={() => {
              handleConnect();
            }}
          >
            Set up payouts
          </Button>

          <p className="text-center notice">
            You'll be redirected to Stripe to complete the onboarding proces.
          </p>
        </div>
      </>
    );
  }
};

export default PayoutSetup;
