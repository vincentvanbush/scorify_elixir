import React from "react";
import ReactDOM from "react-dom"
import style from "./style.less";
import PropTypes from "prop-types";
import mainLogo from "./assets/logo.png";

function HelloMessage({ name }) {
    return (
        <div className="component">
            Hello 123{ name }
            <img src={ mainLogo } />
        </div>
    );
}

HelloMessage.propTypes = {
    name: PropTypes.string.isRequired
}
  
ReactDOM.render(
    <HelloMessage name="Taylor" />,
    document.getElementById("app")
);
