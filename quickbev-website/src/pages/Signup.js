import React, { useState, useReducer } from "react";

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
      emailErrorMsg: "",
      passwordErrorMsg: "",
      confirmPasswordErrorMsg: "",
      emailDisplay: "none",
      pwdDisplay: "none",
      confirmPwdDisplay: "none",
    }
  );
  const formChangeHandler = (event) => {
    let name = event.target.name;
    let value = event.target.value;
    setFormValue({ [name]: value });
  };
  const handleNext = () => {
    // event.preventDefault();
    var newErrorMsgState = {
      emailDisplay: "none",
      pwdDisplay: "none",
      confirmPwdDisplay: "none",
    };
    if (
      formValue.email &&
      formValue.password &&
      formValue.confirmPassword &&
      formValue.password === formValue.confirmPassword
    ) {
      console.log("weee");
      return true;
    } else {
      if (!formValue.email) {
        newErrorMsgState["emailErrorMsg"] = "* Please enter a valid email";
        newErrorMsgState["emailDisplay"] = "inline-block";
      }
      if (!formValue.password) {
        newErrorMsgState["passwordErrorMsg"] = "* Please enter a password";
        newErrorMsgState["pwdDisplay"] = "inline-block";
      }
      if (!formValue.confirmPassword) {
        newErrorMsgState["confirmPasswordErrorMsg"] =
          "* Please confirm your password";
        newErrorMsgState["confirmPwdDisplay"] = "inline-block";
      }
      if (
        formValue.password &&
        formValue.confirmPassword &&
        formValue.password !== formValue.confirmPassword
      ) {
        console.log("passwords dont match");

        newErrorMsgState["confirmPasswordErrorMsg"] =
          "* Your passwords do not match";
        newErrorMsgState["confirmPwdDisplay"] = "inline-block";
      }
      setErrorMsg(newErrorMsgState);
      return false;
    }
  };
  const emailErrorMsgStyle = {
    display: errorMsg.emailDisplay,
    textAlign: "left",
    marginTop: "0",
  };
  const pwdErrorMsgStyle = {
    display: errorMsg.pwdDisplay,
    textAlign: "left",
    marginTop: "0",
  };
  const confirmPwdErrorMsgStyle = {
    display: errorMsg.confirmPwdDisplay,
    textAlign: "left",
    marginTop: "0",
  };

  return (
    <fieldset>
      <h2 className="fs-title">Create your account</h2>
      <div className="invalid-feedback" style={emailErrorMsgStyle}>
        {errorMsg.emailErrorMsg}
      </div>
      <input
        type="text"
        name="email"
        placeholder="Email"
        onChange={(e) => {
          formChangeHandler(e);
        }}
        value={formValue.email}
      />
      <div className="invalid-feedback" style={pwdErrorMsgStyle}>
        {errorMsg.passwordErrorMsg}
      </div>
      <input
        type="password"
        name="password"
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
        placeholder="Confirm Password"
        onChange={(e) => {
          formChangeHandler(e);
        }}
        value={formValue.confirmPassword}
      />
      {/* <input
        type="submit"
        name="submit"
        className="submit action-button"
        value="Submit"
        onClick={(e) => {
          handleSubmit(e);
        }}
      /> */}
      <input
        type="button"
        name="next"
        className="next action-button"
        value="Next"
        onClick={() => {
          if (handleNext()) {
            props.onClick("next");
          }
        }}
      />
    </fieldset>
  );
};
const BusinessFieldset = (props) => {
  const [formValue, setFormValue] = useReducer(
    (state, newState) => ({ ...state, ...newState }),
    {
      businessName: "",
      businessPhoneNumber: "",
      street: "",
      suite: "",
      city: "",
      state: "",
      zipcode: "",
    }
  );
  const [errorMsg, setErrorMsg] = useReducer(
    (state, newState) => ({ ...state, ...newState }),
    {
      businessNameErrorMsg: "",
      businessPhoneNumberErrorMsg: "",
      streetErrorMsg: "",
      cityErrorMsg: "",
      stateErrorMsg: "",
      zipcodeErrorMsg: "",
      businessNameErrorDisplay: "none",
      businessPhoneNumberErrorDisplay: "none",
      streetErrorDisplay: "none",
      cityErrorDisplay: "none",
      stateErrorDisplay: "none",
      zipcodeErrorDisplay: "none",
    }
  );
  const formChangeHandler = (event) => {
    let name = event.target.name;
    let value = event.target.value;
    setFormValue({ [name]: value });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    var newErrorMsgState = {
      businessNameErrorDisplay: "none",
      businessPhoneNumberErrorDisplay: "none",
      streetErrorDisplay: "none",
      cityErrorDisplay: "none",
      stateErrorDisplay: "none",
      zipcodeErrorDisplay: "none",
    };
    if (
      formValue.businessName &&
      formValue.businessPhoneNumber &&
      formValue.street &&
      formValue.city &&
      formValue.state &&
      formValue.zipcode
    ) {
      console.log("weee");
      return true;
    } else {
      console.log("formValue.businessName", formValue.businessName);
      if (!formValue.businessName) {
        console.log("not biz");
        newErrorMsgState["businessNameErrorMsg"] =
          "* Please enter your business' name";
        newErrorMsgState["businessNameErrorDisplay"] = "inline-block";
      }
      if (!formValue.businessPhoneNumber) {
        newErrorMsgState["businessPhoneNumberErrorMsg"] =
          "* Please enter a phone number";
        newErrorMsgState["businessPhoneNumberErrorDisplay"] = "inline-block";
      }
      if (!formValue.street) {
        newErrorMsgState["streetErrorMsg"] = "* Please enter a street";
        newErrorMsgState["streetErrorDisplay"] = "inline-block";
      }
      if (!formValue.city) {
        newErrorMsgState["cityErrorMsg"] = "* Please enter a city";
        newErrorMsgState["cityErrorDisplay"] = "inline-block";
      }
      if (!formValue.state) {
        newErrorMsgState["stateErrorMsg"] = "* Please enter a state";
        newErrorMsgState["stateErrorDisplay"] = "inline-block";
      }
      if (!formValue.zipcode) {
        newErrorMsgState["zipcodeErrorMsg"] = "* Please enter a state";
        newErrorMsgState["zipcodeErrorDisplay"] = "inline-block";
      }
      setErrorMsg(newErrorMsgState);
      return false;
    }
  };
  const businessNameErrorMsgStyle = {
    display: errorMsg.businessNameErrorDisplay,
    textAlign: "left",
    marginTop: "0",
  };
  const businessPhoneNumberErrorMsgStyle = {
    display: errorMsg.businessPhoneNumberErrorDisplay,
    textAlign: "left",
    marginTop: "0",
  };
  const streetErrorMsgStyle = {
    display: errorMsg.streetErrorDisplay,
    textAlign: "left",
    marginTop: "0",
  };
  const cityErrorMsgStyle = {
    display: errorMsg.cityErrorDisplay,
    textAlign: "left",
    marginTop: "0",
  };
  const stateErrorMsgStyle = {
    display: errorMsg.stateErrorDisplay,
    textAlign: "left",
    marginTop: "0",
  };
  const zipcodeErrorMsgStyle = {
    display: errorMsg.zipcodeErrorDisplay,
    textAlign: "left",
    marginTop: "0",
  };
  return (
    <fieldset>
      <h2 className="fs-title">Your Business</h2>
      <div className="invalid-feedback" style={businessNameErrorMsgStyle}>
        {errorMsg.businessNameErrorMsg}
      </div>
      <label htmlFor="businessName" style={{ display: "flex" }}>
        Business Name
      </label>
      <input
        type="text"
        className="mb-3"
        name="businessName"
        placeholder="Business Name"
        value={formValue.businessName}
        required=""
        onChange={(e) => {
          formChangeHandler(e);
        }}
      />
      <div
        className="invalid-feedback"
        style={businessPhoneNumberErrorMsgStyle}
      >
        {errorMsg.businessPhoneNumberErrorMsg}
      </div>
      <label htmlFor="businessPhoneNumber" style={{ display: "flex" }}>
        Business Phone Number
      </label>
      <input
        type="text"
        name="businessPhoneNumber"
        className="mb-3"
        placeholder="123-456-7891"
        required=""
        value={formValue.businessPhoneNumber}
        onChange={(e) => {
          formChangeHandler(e);
        }}
      />
      <div className="col-12">
        <h6 style={{ fontWeight: "bold" }}>Address Details</h6>
        <div className="row mb-3">
          <div className="invalid-feedback" style={streetErrorMsgStyle}>
            {errorMsg.streetErrorMsg}
          </div>
          <label htmlFor="street">Street</label>
          <input
            type="text"
            className="form-control"
            id="street"
            placeholder="1234 Main St"
            value={formValue.street}
            onChange={(e) => {
              formChangeHandler(e);
            }}
            required=""
          />
        </div>
      </div>

      <div className="row mb-3">
        <div className="col-6">
          <label htmlFor="suite" style={{ display: "flex" }}>
            Suite &emsp; <span className="text-muted">(Optional)</span>
          </label>
          <input
            type="text"
            className="form-control"
            id="suite"
            placeholder="Apartment or suite"
            value={formValue.suite}
            onChange={(e) => {
              formChangeHandler(e);
            }}
          />
        </div>
        <div className="col-6">
          <div className="invalid-feedback" style={cityErrorMsgStyle}>
            {errorMsg.cityErrorMsg}
          </div>
          <label htmlFor="city" style={{ display: "flex" }}>
            City
          </label>

          <input
            type="text"
            name="city"
            className="form-control"
            id="city"
            placeholder=""
            required=""
            value={formValue.city}
            onChange={(e) => {
              formChangeHandler(e);
            }}
          />
        </div>
      </div>

      <div className="row">
        <div className="col-6">
          <div className="invalid-feedback" style={stateErrorMsgStyle}>
            {errorMsg.stateErrorMsg}
          </div>
          <label htmlFor="state" style={{ display: "flex" }}>
            State
          </label>
          <select
            className="custom-select d-block w-100"
            id="state"
            required=""
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
          <div className="invalid-feedback" style={zipcodeErrorMsgStyle}>
            {errorMsg.zipcodeErrorMsg}
          </div>
          <label htmlFor="zipcode" style={{ display: "flex" }}>
            Zipcode
          </label>
          <input
            type="text"
            name="zipcode"
            className="form-control"
            placeholder=""
            required=""
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
          value="submit"
          onClick={(e) => {
            return handleSubmit(e);
          }}
        />
      </div>
    </fieldset>
  );
};
const PersonalDetailsFieldset = (props) => {
  return (
    <fieldset>
      <h2 className="fs-title">Personal Details</h2>
      <input type="text" name="fname" placeholder="First Name" />
      <input type="text" name="lname" placeholder="Last Name" />
      <input type="text" name="phone" placeholder="Phone" />
      <textarea name="address" placeholder="Address"></textarea>
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
        type="button"
        name="next"
        className="next action-button"
        value="Next"
        onClick={(e) => {
          console.log("e", e);
          props.onClick("next");
        }}
      />
    </fieldset>
  );
};
const Signup = () => {
  //jQuery time
  const handleClick = (buttonType) => {
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
  const fieldSets = [
    <CreateYourAccountFieldset
      onClick={(buttonType) => handleClick(buttonType)}
    ></CreateYourAccountFieldset>,
    <PersonalDetailsFieldset
      onClick={(buttonType) => handleClick(buttonType)}
    ></PersonalDetailsFieldset>,
    <BusinessFieldset
      onClick={(buttonType) => handleClick(buttonType)}
    ></BusinessFieldset>,
  ];
  const [currentFieldsetIndex, setCurrentFieldsetIndex] = useState(0);
  return (
    // <!-- multistep form -->
    <div className="signupBody">
      <form id="msform">
        {/* <!-- progressbar --> */}
        <ProgressBar i={currentFieldsetIndex}></ProgressBar>
        {/* <!-- fieldsets --> */}
        {fieldSets[currentFieldsetIndex]}
      </form>
    </div>
  );
};
export default Signup;
