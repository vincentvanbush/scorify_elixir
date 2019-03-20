import React, { Component } from "react";
import ReactDOM from "react-dom"
import style from "./style.less";
import PropTypes from "prop-types";
import mainLogo from "./assets/logo.png";
import { BrowserRouter as Router, Route, Link, Switch } from "react-router-dom";
import SportsPage from "./SportsPage.jsx";
import LeaguesPage from "./LeaguesPage.jsx";
import LeaguePage from "./LeaguePage.jsx";
import LeagueSeasons from "./LeagueSeasons.jsx";

import ApolloClient from "apollo-boost";
import { ApolloProvider } from "react-apollo";

import * as serviceWorker from './serviceWorker';

const client = new ApolloClient({
    // If you don’t pass in uri directly, it defaults to the /graphql endpoint on the same host your app is served from
    // uri: "http://localhost:4000/graphql"
});

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
                        path="/sports/:sportId/leagues"
                        component={ LeaguesPage }
                    ></Route>
                    <Route
                        exact
                        path="/sports/:sportId/leagues/:leagueId"
                        component={ LeaguePage }
                    ></Route>
                    <Route
                        exact
                        path="/sports/:sportId/leagues/:leagueId/seasons"
                        component={ LeagueSeasons }
                    ></Route>
                </Switch>
                <img src={ mainLogo }></img>
            </div>
        )
    }
}
  
ReactDOM.render(
    <ApolloProvider client={client}>
        <Router>
            <ScorifyApp/>
        </Router>
    </ApolloProvider>,
    document.getElementById("app")
);
console.log("in app js");
alert("dupa")
serviceWorker.register();