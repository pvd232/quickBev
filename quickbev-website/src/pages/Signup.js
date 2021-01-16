import React, { useState, useReducer } from "react";
import { Redirect } from "react-router-dom";
import { Merchant, Business, makeApiRequest } from "../Models.js";
const ProgressBar = (props) => {
  const statusValues = ["Account Setup", "Personal Details", "Your Business"];
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
        props.merchant.id = formValue.email;
        props.merchant.password = formValue.password;
        props.onClick("next");
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
        <h2 className="fs-title">Create your account</h2>
        <input
          type="email"
          name="email"
          placeholder="Email"
          required={true}
          onChange={(e) => {
            formChangeHandler(e);
          }}
          value={formValue.email}
        />
        <input
          type="password"
          name="password"
          required={true}
          placeholder="Password"
          onChange={(e) => {
            formChangeHandler(e);
          }}
          value={formValue.password}
        />
        <div className="invalid-feedback" style={confirmPwdErrorMsgStyle}>
          {errorMsg.confirmPasswordErrorMsg}
        </div>
        <input
          type="password"
          name="confirmPassword"
          required={true}
          placeholder="Confirm Password"
          onChange={(e) => {
            formChangeHandler(e);
          }}
          value={formValue.confirmPassword}
        />
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
    console.log("formValue.firstName", formValue.firstName);

    let name = event.target.name;
    console.log("name", name);
    let value = event.target.value;
    console.log("value", value);
    setFormValue({ [name]: value });
  };
  const validate = (form) => {
    console.log("form.checkValidity()", form.checkValidity());

    console.log("formValue.firstName", formValue.firstName);
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
    console.log("validate(form)", validate(form));
    console.log("form.checkValidity()", form.checkValidity());

    if (validate(form)) {
      props.merchant.firstName = formValue.firstName;
      props.merchant.lastName = formValue.lastName;
      props.merchant.phoneNumber = formValue.phoneNumber;
      props.onClick("next");
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
          pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
          placeholder="Phone Number"
          onChange={(e) => {
            formChangeHandler(e);
          }}
          value={formValue.phoneNumber}
        />
        {/* <textarea name="address" placeholder="Address"></textarea> */}
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
      street: "",
      suite: "",
      city: "",
      state: "",
      zipcode: "",
    }
  );

  const formChangeHandler = (event) => {
    let name = event.target.name;
    let value = event.target.value;
    setFormValue({ [name]: value });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    const form = event.target;

    if (validate(form)) {
      // set all the values for the business
      // if the user comes back to this page before submitting to change stuff it will reset the values
      props.business.id = formValue.name;
      props.business.phoneNumber = formValue.phoneNumber;
      props.business.street = formValue.street;
      props.business.suite = formValue.suite;
      props.business.city = formValue.city;
      props.business.state = formValue.state;
      props.business.zipcode = formValue.zipcode;
      props.onSubmit();
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
    >
      <fieldset>
        <h2 className="fs-title">Your Business</h2>
        <label htmlFor="name" style={{ display: "flex" }}>
          Business Name
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
          Business Phone Number
        </label>
        <input
          type="tel"
          name="phoneNumber"
          className="mb-3"
          placeholder="123-456-7891"
          required={true}
          pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"
          value={formValue.phoneNumber}
          onChange={(e) => {
            formChangeHandler(e);
          }}
        />
        <div className="col-12">
          <div className="row mb-3">
            <label htmlFor="street">Street</label>
            <input
              type="text"
              className="form-control"
              name="street"
              placeholder="1234 Main St"
              value={formValue.street}
              onChange={(e) => {
                formChangeHandler(e);
              }}
              required={true}
            />
          </div>
        </div>

        <div className="row mb-3">
          <div className="col-6">
            <label htmlFor="suite" style={{ display: "flex" }}>
              Suite
            </label>
            <input
              type="text"
              className="form-control"
              name="suite"
              placeholder="Apartment or suite"
              value={formValue.suite}
              onChange={(e) => {
                formChangeHandler(e);
              }}
            />
          </div>
          <div className="col-6">
            <label htmlFor="city" style={{ display: "flex" }}>
              City
            </label>

            <input
              type="text"
              name="city"
              className="form-control"
              placeholder="Los Angleles"
              required={true}
              value={formValue.city}
              onChange={(e) => {
                formChangeHandler(e);
              }}
            />
          </div>
        </div>

        <div className="row">
          <div className="col-6">
            <label htmlFor="state" style={{ display: "flex" }}>
              State
            </label>
            <select
              className="custom-select d-block w-100"
              name="state"
              required={true}
              value={formValue.state}
              onChange={(e) => {
                formChangeHandler(e);
              }}
            >
              <option value="">Choose...</option>
              <option>Alabama</option>
              <option>Alaska</option>
              <option>Arizona</option>
              <option>Arkansas</option>
              <option>California</option>
              <option>Colorado</option>
              <option>Connecticut</option>
              <option>Delaware</option>
              <option>Florida</option>
              <option>Georgia</option>
              <option>Hawaii</option>
              <option>Idaho</option>
              <option>Illinois</option>
              <option>Indiana</option>
              <option>Iowa</option>
              <option>Kansas</option>
              <option>Kentucky</option>
              <option>Louisiana</option>
              <option>Maine</option>
              <option>Maryland</option>
              <option>Massachusettes</option>
              <option>Michigan</option>
              <option>Minnesota</option>
              <option>Mississippi</option>
              <option>Missouri</option>
              <option>Montana</option>
              <option>Nebraska</option>
              <option>Nevada</option>
              <option>New Hamshire</option>
              <option>New Jersey</option>
              <option>New Mexico</option>
              <option>New York</option>
              <option>North Carolina</option>
              <option>Ohio</option>
              <option>Oklahoma</option>
              <option>Oregon</option>
              <option>Pennsylvania</option>
              <option>Rhode Island</option>
              <option>South Carolina</option>
              <option>South Dakota</option>
              <option>Tennessee</option>
              <option>Texas</option>
              <option>Utah</option>
              <option>Vermont</option>
              <option>Virginia</option>
              <option>Washington</option>
              <option>West Virginia</option>
              <option>Wisconsin</option>
              <option>Wyoming</option>
            </select>
          </div>
          <div className="col-6">
            <label htmlFor="zipcode" style={{ display: "flex" }}>
              Zipcode
            </label>
            <input
              type="text"
              pattern="[0-9]{5}"
              name="zipcode"
              className="form-control"
              placeholder=""
              required={true}
              value={formValue.zipcode}
              onChange={(e) => {
                formChangeHandler(e);
              }}
            />
          </div>
        </div>
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
  const newMerchant = new Merchant();
  const newBusiness = new Business();

  const handleClick = (buttonType) => {
    if (buttonType === "previous") {
      if (currentFieldsetIndex > 0) {
        setCurrentFieldsetIndex(currentFieldsetIndex - 1);
      }
    } else if (buttonType === "next") {
      console.log("newMerchant", newMerchant);
      console.log("newBusiness", newBusiness);

      if (currentFieldsetIndex < 2) {
        setCurrentFieldsetIndex(currentFieldsetIndex + 1);
      }
    }
  };
  const onSubmit = () => {
    const data = {};
    data["merchant"] = newMerchant;
    data["business"] = newBusiness;
    const json = JSON.stringify(data);
    console.log("json", json);
    localStorage.setItem("merchant", newMerchant);
    localStorage.setItem("business", newBusiness);
    makeApiRequest("http://127.0.0.1:5000/signup", "POST", json, function () {
      setRedirect("/home");
    });
  };
  const fieldSets = [
    <CreateYourAccountFieldset
      merchant={newMerchant}
      onClick={(buttonType) => handleClick(buttonType)}
    ></CreateYourAccountFieldset>,
    <PersonalDetailsFieldset
      merchant={newMerchant}
      onClick={(buttonType) => handleClick(buttonType)}
    ></PersonalDetailsFieldset>,
    <BusinessFieldset
      onSubmit={() => onSubmit()}
      business={newBusiness}
      onClick={(buttonType) => handleClick(buttonType)}
    ></BusinessFieldset>,
  ];
  const [currentFieldsetIndex, setCurrentFieldsetIndex] = useState(0);
  if (redirect) {
    return <Redirect to={redirect} />;
  } else {
    return (
      // <!-- multistep form -->
      <div className="signupBody">
        <div id="msform">
          {/* <!-- progressbar --> */}
          <ProgressBar i={currentFieldsetIndex}></ProgressBar>
          {/* <!-- fieldsets --> */}
          {fieldSets[currentFieldsetIndex]}
        </div>
      </div>
    );
  }
};
export default Signup;
