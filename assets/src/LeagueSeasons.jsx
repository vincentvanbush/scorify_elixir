import React, { Component } from "react";
import { Link } from "react-router-dom";
import { Query } from "react-apollo";
import gql from "graphql-tag";
import Loading from "./Loading.jsx";

const SEASONS = gql`
    query Seasons($leagueId: Int!) {
        league(id: $leagueId) {
            id
            name
            leagueSeasons {
                name
            }
        }
    }
`
const extractLeagueIdFromUrl = url => parseInt(url.match(/\/sports\/\d+\/leagues\/(\d+)/)[1]);

const SeasonsPage = ({ match }) => (
    <Query query={ SEASONS } variables={{ leagueId: extractLeagueIdFromUrl(match.url) }}>
        {({ loading, error, data }) => {
            if (loading) return <Loading/>;
            if (error) return `Error!: ${error}`;

            return (
                <div>
                    <h2>{ data.league.name } seasons:</h2>
                    {
                        data.league.leagueSeasons.map((season, ind) =>
                            <div key={ ind }>
                                <div>{ season.name }</div>
                            </div>
                        )
                    }
                </div>
            );
        }}
    </Query>
);
export default SeasonsPage;
