import React, { useState, useEffect } from "react";
import Button from "react-bootstrap/Button";
import API from "../helpers/Api.js";
import bankIcon from "../static/icon-bank.svg";

const PayoutSetup = (props) => {
  const [redirect, setRedirect] = useState(null);
  const getRedirectInfo = async () => {
    return API.makeRequest(
      "GET",
      `http://127.0.0.1:5000/create-stripe-account`
    );
  };

  const handleConnect = async () => {
    // event.preventDefault()
    let response = await getRedirectInfo();
    console.log("response", response);
    let url = response.url;
    if (url) {
      console.log("url", url);
      setRedirect(url);
    }
  };
  useEffect(() => {
    //had to do this because memory leak due to component not unmounting properly
    let mount = true;
    if (mount && redirect) {
      window.location.assign(redirect);
    }

    return () => (mount = false);
  }, [redirect]);

  if (props.callBack) {
    return (
      <>
        <div className="text-center box">
          <img src={bankIcon} alt="" className="icon" />
          <h5 style={{ marginTop: "5%", marginBottom: "5%" }}>
            Stripe account onboarding incomplete
          </h5>
          <p>
            Please click the button below to be redirected to Stripe to complete
            the onboarding proces
          </p>

          <Button
            className="btn btn-primary text-center"
            onClick={() => {
              props.onSubmit();
              handleConnect();
            }}
          >
            Set up payouts
          </Button>
        </div>
      </>
    );
  } else {
    return (
      <>
        <div className="text-center box">
          <img src={bankIcon} alt="" className="icon" />
          <h5>Set up payouts to list on Kavholm</h5>
          <p>
            Kavholm partners with Stripe to transfer earnings to your bank
            account.
          </p>

          <Button
            className="btn btn-primary text-center"
            onClick={(event) => {
              props.onSubmit(event);
              handleConnect();
            }}
            type="submit"
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
