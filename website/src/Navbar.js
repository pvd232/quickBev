import { Link } from "react-router-dom";
import { ReactComponent as Logo } from "./static/landscapelogo.svg";
const Navbar = () => {
  const navbarCenteredStyle = {
    // background:
    //   "linear-gradient(rgba(155, 89, 182, 0.6),rgba(196, 102, 70, 0.6) )",
    // height: "10vh",
    // marginTop: "0vh",
    minWidth: "auto",
    minHeight: "auto",
    marginBottom: "auto",
    marginTop: "auto",
  };

  // const navbarCenteredImageStyle = { height: "150px", width: "100vw" };
  return (
    <nav
      className="header-navbar navbar-dark navbar-expand-lg"
      style={navbarCenteredStyle}
    >
      {/* <nav className="navbar navbar-expand-lg" style={navbarStyle}> */}
      <button
        className="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarTogglerDemo02"
        aria-controls="navbarTogglerDemo02"
        aria-expanded="false"
        aria-label="Toggle navigation"
        style={{ color: "black", marginTop: "20px" }}
      >
        <span className="navbar-toggler-icon"></span>
      </button>
      <div className="collapse navbar-collapse" id="navbarTogglerDemo02">
        <ul
          className="navbar-nav"
          style={{
            position: "relative",
            marginLeft: "50vw",
            transform: "translateX(-50%)",
            alignItems: "center",
          }}
        >
          <li className="nav-item px-3">
            <Link to="/" className="nav-link navbar-link-size-lg">
              {/* <div
                style={{
                  position: "absolute",
                  // top: "50%",
                  // left: "50%",
                  transform: "scale(1.0814606741573036)",
                  width: "388px",
                  height: "135px",
                }}
              > */}
              <Logo />
              {/* <img
                  className="App-logo"
                  src={logo}
                  // style={navbarCenteredImageStyle}
                  alt="NA"
                  // style={{ marginRight: ".5vw" }}
                /> */}
              {/* </div> */}

              {/* <Logo className="App-logo" /> */}
            </Link>
          </li>
          {/* <li className="nav-item px-3">
            <Link
              to="/"
              className="nav-link navbar-link-size-lg"
              // style={{ fontFamily: "Century Gothic" }}
            >
              QuickBev
            </Link>
          </li> */}
        </ul>
        <ul className="navbar-nav ml-auto" style={{ alignItems: "center" }}>
          <li className="nav-item px-3">
            <Link
              to="/signin"
              className="nav-link navbar-link-size"
              // style={{ fontFamily: "Century Gothic" }}
            >
              Sign in
            </Link>
          </li>
          <li className="nav-item px-3">
            <Link
              to="/signup"
              className="nav-link navbar-link-size"
              // style={{ fontFamily: "Century Gothic" }}
            >
              Sign up
            </Link>
          </li>
        </ul>
      </div>
      {/* </nav> */}
    </nav>
  );
};
export default Navbar;
