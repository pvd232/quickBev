import React, { useState, useReducer, useEffect } from "react";
import { Redirect } from "react-router-dom";
import { Merchant, Business, makeApiRequest } from "../Models.js";
import Navbar from "../Navbar.js";
import logo from "../qbLogo.png";
import SearchLocationInput from "../SearchLocationInput.js";
const ProgressBar = (props) => {
  const statusValues = [
    "Account setup",
    "Your menu and ordering",
    "Start getting paid",
  ];
  return (
    <ul id="progressbar">
      {statusValues.map((item, i) => {
        return (
          <li className={i <= props.i ? "active" : ""} key={i}>
            {item}
          </li>
        );
      })}
    </ul>
  );
};
const CreateYourAccountFieldset = (props) => {
  // use reducer takes 2 parameters, the first is a function called a reducer, the second is the initial value of the state
  // usually the reducer funciton takes in two parameters, the state, and the action being performed. but the way ive defined it, it takes in an object that stores the new value the user has type in
  // the syntax of the reducer funciton is such that parenthesis are used for the return value instead of brackets because the only logic in the return value is the value that it returns. the return word is also omitted
  // i supply an anonymous reducer function that takes in the current and new state and returns the updated state object spreading syntax
  // this reduction function is applied in the formChangeHandler which dynamically sets the state value based on the name passed in through the event
  // i am telling React how to update the state with the reducer function, and then i am binding those instructions to my setFormValue function which then implements that logic.
  // react is passing the current state into the function, and i am passing in the second parameter, new state, i could implement some logic if i wanted, then i return what i want the new state to be to react and react updates it
  const [formValue, setFormValue] = useReducer(
    (state, newState) => ({ ...state, ...newState }),
    {
      firstName: "",
      lastName: "",
      phoneNumber: "",
      email: "",
      password: "",
      confirmPassword: "",
    }
  );
  const [errorMsg, setErrorMsg] = useReducer(
    (state, newState) => ({ ...state, ...newState }),
    {
      confirmPwdDisplay: "none",
    }
  );
  const formChangeHandler = (event) => {
    let name = event.target.name;
    let value = event.target.value;
    setFormValue({ [name]: value });
  };
  const validate = (form) => {
    form.classList.add("was-validated");
    return form.checkValidity();
  };
  const handleNext = (event) => {
    event.preventDefault();
    const form = event.target;

    if (validate(form)) {
      var newErrorMsgState = {
        confirmPwdDisplay: "none",
      };
      if (formValue.password !== formValue.confirmPassword) {
        console.log("passwords dont match");

        newErrorMsgState["confirmPasswordErrorMsg"] =
          "* Your passwords do not match";
        newErrorMsgState["confirmPwdDisplay"] = "inline-block";
        setErrorMsg(newErrorMsgState);
        return false;
      } else {
        const newMerchant = {};
        newMerchant._firstName = formValue.firstName;
        newMerchant._lastName = formValue.lastName;
        newMerchant._phoneNumber = formValue.phoneNumber;
        newMerchant._id = formValue.email;
        newMerchant._password = formValue.password;
        props.onClick("next", newMerchant);
      }
    } else {
      return false;
    }
  };
  const confirmPwdErrorMsgStyle = {
    display: errorMsg.confirmPwdDisplay,
    textAlign: "left",
    marginTop: "0",
  };

  return (
    <form
      onSubmit={(e) => {
        handleNext(e);
      }}
    >
      <fieldset>
        <h2 className="fs-title">Your menu and ordering</h2>
        <div className="row">
          <div className="col-6">
            <label
              htmlFor="firstName"
              style={{
                display: "flex",
                fontSize: "14px",
                fontWeight: "bolder",
              }}
            >
              First name
            </label>
            <input
              type="text"
              name="firstName"
              required={true}
              onChange={(e) => {
                formChangeHandler(e);
              }}
              value={formValue.firstName}
            />
          </div>
          <div className="col-6">
            <label
              htmlFor="lastName"
              style={{
                display: "flex",
                fontSize: "14px",
                fontWeight: "bolder",
              }}
            >
              Last name
            </label>
            <input
              type="text"
              name="lastName"
              required={true}
              onChange={(e) => {
                formChangeHandler(e);
              }}
              value={formValue.lastName}
            />
          </div>
        </div>
        <div className="row">
          <div className="col-12">
            <label
              htmlFor="email"
              style={{
                display: "flex",
                fontSize: "14px",
                fontWeight: "bolder",
              }}
            >
              Email
            </label>
            <input
              type="email"
              name="email"
              required={true}
              onChange={(e) => {
                formChangeHandler(e);
              }}
              value={formValue.email}
            />
          </div>
        </div>
        <div className="row">
          <div className="col-12">
            <label
              htmlFor="phoneNumber"
              style={{
                display: "flex",
                fontSize: "14px",
                fontWeight: "bolder",
              }}
            >
              Phone number
            </label>
            <input
              type="tel"
              name="phoneNumber"
              required={true}
              pattern="[0-9]{10}"
              onChange={(e) => {
                formChangeHandler(e);
              }}
              value={formValue.phoneNumber}
            />
          </div>
        </div>
        <div className="row">
          <div className="col-12">
            <label
              htmlFor="password"
              style={{
                display: "flex",
                fontSize: "14px",
                fontWeight: "bolder",
              }}
            >
              Password
            </label>
            <input
              type="password"
              name="password"
              required={true}
              onChange={(e) => {
                formChangeHandler(e);
              }}
              value={formValue.password}
            />
          </div>
        </div>

        <div className="row">
          <div className="col-12">
            <div className="invalid-feedback" style={confirmPwdErrorMsgStyle}>
              {errorMsg.confirmPasswordErrorMsg}
            </div>
            <label
              htmlFor="confirmPassword"
              style={{
                display: "flex",
                fontSize: "14px",
                fontWeight: "bolder",
              }}
            >
              Confirm password
            </label>
            <input
              type="password"
              name="confirmPassword"
              required={true}
              onChange={(e) => {
                formChangeHandler(e);
              }}
              value={formValue.confirmPassword}
            />
          </div>
        </div>

        <input
          type="submit"
          name="next"
          className="next action-button"
          value="Next"
        />
      </fieldset>
    </form>
  );
};
const PersonalDetailsFieldset = (props) => {
  const [formValue, setFormValue] = useReducer(
    (state, newState) => ({ ...state, ...newState }),
    {
      firstName: "",
      lastName: "",
      phoneNumber: "",
    }
  );
  const formChangeHandler = (event) => {
    let name = event.target.name;
    let value = event.target.value;
    setFormValue({ [name]: value });
  };
  const validate = (form) => {
    if (form.checkValidity()) {
      form.classList.add("was-validated");
      return true;
    } else {
      return false;
    }
  };

  const handleNext = (event) => {
    event.preventDefault();
    const form = event.target;

    if (validate(form)) {
      const newMerchant = {};
      newMerchant._firstName = formValue.firstName;
      newMerchant._lastName = formValue.lastName;
      newMerchant._phoneNumber = formValue.phoneNumber;
      console.log("newMerchant", newMerchant);
      props.onClick("next", newMerchant);
    } else {
      return false;
    }
  };
  return (
    <form
      onSubmit={(e) => {
        handleNext(e);
      }}
    >
      <fieldset>
        <h2 className="fs-title">Personal Details</h2>
        <input
          type="text"
          name="firstName"
          placeholder="First Name"
          required={true}
          onChange={(e) => {
            formChangeHandler(e);
          }}
          value={formValue.firstName}
        />
        <input
          type="text"
          name="lastName"
          placeholder="Last Name"
          required={true}
          onChange={(e) => {
            formChangeHandler(e);
          }}
          value={formValue.lastName}
        />
        <input
          type="tel"
          name="phoneNumber"
          required={true}
          pattern="[0-9]{10}"
          placeholder="512-899-9160"
          onChange={(e) => {
            formChangeHandler(e);
          }}
          value={formValue.phoneNumber}
        />
        <input
          type="button"
          name="previous"
          className="previous action-button"
          value="Previous"
          required={true}
          onClick={() => {
            props.onClick("previous");
          }}
        />
        <input
          type="submit"
          name="next"
          required={true}
          className="next action-button"
          value="Next"
        />
      </fieldset>
    </form>
  );
};
const BusinessFieldset = (props) => {
  const [formValue, setFormValue] = useReducer(
    (state, newState) => ({ ...state, ...newState }),
    {
      name: "",
      phoneNumber: "",
      address: "",
      street: "",
      suite: "",
      city: "",
      state: "",
      zipcode: "",
    }
  );
  const setAddress = (address) => {
    if (address.split(",").length === 4) {
      const addressObject = {};
      addressObject["address"] = address;
      const addressArray = address.split(",");
      addressObject["street"] = addressArray[0];
      addressObject["city"] = addressArray[1];
      const stateZipcodeArray = addressArray[2].split(" ");
      addressObject["state"] = stateZipcodeArray[1];
      addressObject["zipcode"] = stateZipcodeArray[2];
      console.log("addressObject", addressObject);
      setFormValue(addressObject);
    }
  };
  const formChangeHandler = (event) => {
    console.log("formValue", formValue);

    let name = event.target.name;
    console.log("name", name);
    let value = event.target.value;
    console.log("value", value);
    setFormValue({ [name]: value });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    const form = event.target;

    if (validate(form)) {
      // set all the values for the business
      // if the user comes back to this page before submitting to change stuff it will reset the values
      const newBusiness = new Business();
      newBusiness.id = formValue.name;
      newBusiness.phoneNumber = formValue.phoneNumber;
      newBusiness.address = formValue.address;
      newBusiness.street = formValue.street;
      newBusiness.suite = formValue.suite;
      newBusiness.city = formValue.city;
      newBusiness.state = formValue.state;
      newBusiness.zipcode = formValue.zipcode;
      props.onSubmit(newBusiness);
    } else {
      return false;
    }
  };
  const validate = (form) => {
    form.classList.add("was-validated");
    return form.checkValidity();
  };
  return (
    <form
      onSubmit={(e) => {
        handleSubmit(e);
      }}
      autoComplete="off"
    >
      <fieldset>
        <h2 className="fs-title">Your Business</h2>
        <label htmlFor="name" style={{ display: "flex" }}>
          Name
        </label>
        <input
          type="text"
          className="mb-3"
          name="name"
          placeholder="Business Name"
          value={formValue.name}
          required={true}
          onChange={(e) => {
            formChangeHandler(e);
          }}
        />
        <label htmlFor="phoneNumber" style={{ display: "flex" }}>
          Phone Number
        </label>
        <input
          type="tel"
          name="phoneNumber"
          className="mb-3"
          required={true}
          pattern="[0-9]{10}"
          placeholder="5128999160"
          value={formValue.phoneNumber}
          onChange={(e) => {
            formChangeHandler(e);
          }}
        />
        <label htmlFor="address" style={{ display: "flex" }}>
          Address
        </label>
        <SearchLocationInput onUpdate={(address) => setAddress(address)} />
        <div className="row" style={{ justifyContent: "space-around" }}>
          <input
            type="button"
            name="previous"
            className="previous action-button"
            value="Previous"
            onClick={() => {
              props.onClick("previous");
            }}
          />
          <input
            type="submit"
            name="submit"
            className="submit action-button"
            style={{ background: "blue" }}
            value="Submit"
          />
        </div>
      </fieldset>
    </form>
  );
};

const Signup = () => {
  const [redirect, setRedirect] = useState(null);
  const [dataBool, setDataBool] = useState(null);
  const [merchant, setMerchant] = useState(new Merchant());

  const handleClick = (buttonType, newMerchant) => {
    if (newMerchant) {
      setMerchant({ ...merchant, ...newMerchant });
    }

    if (buttonType === "previous") {
      if (currentFieldsetIndex > 0) {
        setCurrentFieldsetIndex(currentFieldsetIndex - 1);
      }
    } else if (buttonType === "next") {
      if (currentFieldsetIndex < 2) {
        setCurrentFieldsetIndex(currentFieldsetIndex + 1);
      }
    }
  };
  useEffect(() => {
    //had to do this because memory leak due to component not unmounting properly
    let mount = true;
    if (dataBool && mount) {
      setRedirect("/home");
    }

    return () => (mount = false);
  }, [dataBool]);
  const onSubmit = (newBusiness) => {
    const data = {};
    // the merchant in state was being converted back to a regular object
    const formattedMerchant = new Merchant(null, merchant);
    data["merchant"] = formattedMerchant;
    data["business"] = newBusiness;
    const json = JSON.stringify(data);
    localStorage.setItem("merchant", merchant);
    localStorage.setItem("business", newBusiness);
    makeApiRequest("http://127.0.0.1:5000/signup", "POST", json, function () {
      setDataBool(true);
    });
  };
  const fieldSets = [
    <CreateYourAccountFieldset
      onClick={(buttonType, merchant) => handleClick(buttonType, merchant)}
    ></CreateYourAccountFieldset>,
    <PersonalDetailsFieldset
      onClick={(buttonType, merchant) => handleClick(buttonType, merchant)}
    ></PersonalDetailsFieldset>,
    <BusinessFieldset
      onSubmit={(newBusiness) => onSubmit(newBusiness)}
      onClick={(buttonType) => handleClick(buttonType)}
    ></BusinessFieldset>,
  ];
  const [currentFieldsetIndex, setCurrentFieldsetIndex] = useState(0);
  if (redirect) {
    return <Redirect to={redirect} />;
  } else {
    return (
      <>
        <Navbar src={logo} />
        {/* <!-- multistep form -->*/}
        <div className="signupBody">
          <div id="msform">
            {/* <!-- progressbar --> */}
            <ProgressBar i={currentFieldsetIndex}></ProgressBar>
            {/* <!-- fieldsets --> */}
            {fieldSets[currentFieldsetIndex]}
          </div>
        </div>
      </>
    );
  }
};
export default Signup;
