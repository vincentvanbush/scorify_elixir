import React from "react";
import ReactDOM from "react-dom"
// import style from "./style.less";
import PropTypes from "prop-types";

function HelloMessage({ name }) {
    return (
        <div className="component">
            Hello { name }
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
