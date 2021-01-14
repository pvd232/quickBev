import { Link } from "react-router-dom";
const Navbar = (props) => {
  const navbarCenteredStyle = {
    backgroundColor: "black",
    height: "10vh",
    marginTop: "0vh",
  };

  // const navbarCenteredImageStyle = { height: "150px", width: "100vw" };
  return (
    <nav
      className="header-navbar navbar navbar-expand-lg"
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
          }}
        >
          <li>
            <Link to="/" className="nav-link navbar-link-size-lg">
              <img
                className="App-logo"
                src={props.src}
                // style={navbarCenteredImageStyle}
                alt=""
                style={{ marginRight: ".5vw" }}
              />
            </Link>
          </li>
          <li className="nav-item px-3">
            <Link
              to="/"
              className="nav-link navbar-link-size-lg"
              style={{ fontFamily: "Century Gothic" }}
            >
              QuickBev
            </Link>
          </li>
        </ul>
        <ul className="navbar-nav ml-auto">
          <li className="nav-item px-3">
            <Link
              to="/signin"
              className="nav-link navbar-link-size"
              style={{ fontFamily: "Century Gothic" }}
            >
              Sign in
            </Link>
          </li>
          <li className="nav-item px-3">
            <Link
              to="/signup"
              className="nav-link navbar-link-size"
              style={{ fontFamily: "Century Gothic" }}
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
