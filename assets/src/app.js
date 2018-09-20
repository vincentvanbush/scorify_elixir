import React from "react";
import ReactDOM from "react-dom"
// import style from "./style.less";
import PropTypes from "prop-types";
import mainLogo from "./assets/logo.png";

function HelloMessage({ name }) {
    return (
        <div className="component">
            Hello { name }
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

// app.html.exx do <head> dodać  coś takiego if Mix.env == :dev żeby zaserwować style z osobnego pliku (podobnie jak na dole pliku z js)
// docelowo na prod chcemy katalogi js css assets z odpowiednim kontentem
// zaciągając stronkę z 4000 powininem się wyrenderować komonenent reactowy
// plik compile stanowi instrukcję builda i deploymentu produkcyjnego z którego korzysta heroku -> musi być odpowiedni skrypt yarn/npm
