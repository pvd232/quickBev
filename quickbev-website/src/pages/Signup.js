import React, { useState } from "react";

const ProgressBar = (props) => {
  const statusValues = ["Account Setup", "Social Profiles", "Personal Details"];
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
  return (
    <fieldset>
      <h2 className="fs-title">Create your account</h2>
      <h3 className="fs-subtitle">This is step 1</h3>
      <input type="text" name="email" placeholder="Email" />
      <input type="password" name="pass" placeholder="Password" />
      <input type="password" name="cpass" placeholder="Confirm Password" />
      <input
        type="button"
        name="next"
        className="next action-button"
        value="Next"
        onClick={() => {
          props.onClick("next");
        }}
      />
    </fieldset>
  );
};
const SocialProfileFieldset = (props) => {
  return (
    <fieldset>
      <h2 className="fs-title">Social Profiles</h2>
      <h3 className="fs-subtitle">Your presence on the social network</h3>
      <input type="text" name="twitter" placeholder="Twitter" />
      <input type="text" name="facebook" placeholder="Facebook" />
      <input type="text" name="gplus" placeholder="Google Plus" />
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
        onClick={() => {
          props.onClick("next");
        }}
      />
    </fieldset>
  );
};
const PersonalDetailsFieldset = (props) => {
  return (
    <fieldset>
      <h2 className="fs-title">Personal Details</h2>
      <h3 className="fs-subtitle">We will never sell it</h3>
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
        type="submit"
        name="submit"
        class="submit action-button"
        value="Submit"
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
    <SocialProfileFieldset
      onClick={(buttonType) => handleClick(buttonType)}
    ></SocialProfileFieldset>,
    <PersonalDetailsFieldset
      onClick={(buttonType) => handleClick(buttonType)}
    ></PersonalDetailsFieldset>,
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
