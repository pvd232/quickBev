import React, { useState, useEffect } from "react";
import Button from "react-bootstrap/Button";
import API from "../helpers/Api.js";
import { Redirect } from "react-router-dom";

const PayoutSetup = () => {
  const getRedirectInfo = async () => {
    return API.makeRequest(
      "post",
      `http://127.0.0.1:5000/create-stripe-account`
    );
  };
  const [redirect, setRedirect] = useState(null);
  const [data, setData] = useState(false);
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
          <img src="/static/icon-bank.svg" alt="" className="icon" />
          <h3>Set up payouts to list on Kavholm</h3>
          <p>
            Kavholm partners with Stripe to transfer earnings to your bank
            account.
          </p>

          <Button
            className="btn btn-primary text-center"
            onClick={handleConnect()}
          >
            Set up payouts
          </Button>

          <p className="text-center notice">
            You'll be redirected to Stripe to complete the onboarding proces.
          </p>
        </div>
        <style jsx>{`
          .icon {
            margin-bottom: 30px;
            height: 32px;
          }
          .box {
            max-width: 300px;
            max-height: 400px;
          }
          h3 {
            font-weight: 600;
          }
          p {
            line-height: 22px;
          }
          .box .btn {
            width: 100%;
            margin-bottom: 20px;
            margin-top: 16px;
          }
          .box .notice {
            font-size: 12px;
            line-height: 1.5;
          }
          .box h3 {
            margin-bottom: 20px;
          }
        `}</style>
      </>
    );
  }
};

export default PayoutSetup;
