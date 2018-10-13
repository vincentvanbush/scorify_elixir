import React, { Component } from "react";
import ReactDOM from "react-dom"
// import style from "./style.less";
import PropTypes from "prop-types";
import mainLogo from "./assets/logo.png";
import { BrowserRouter as Router, Route, Link, Switch } from "react-router-dom";
import SportsPage from "./SportsPage.jsx";
import LeaguesPage from "./LeaguesPage.jsx";

const MainPage = () => (
    <div>
        <h1>Welocome in Scorify app!</h1>
        <Link to="/sports">Sports</Link>
    </div>
);

class ScorifyApp extends Component {
    render() {
        return (
            <div>
                <Switch>
                    <Route
                        exact
                        path="/"
                        component={ MainPage }
                    >
                    </Route>
                    <Route
                        exact
                        path="/sports"
                        component={ SportsPage }
                    ></Route>
                    <Route
                        exact
                        path="/sports/:sportId"
                        component={ LeaguesPage }
                    ></Route>
                </Switch>
            </div>
        )
    }
}
  
ReactDOM.render(
    <Router>
        <ScorifyApp/>
    </Router>,
    document.getElementById("app")
);
