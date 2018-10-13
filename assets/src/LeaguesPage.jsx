import React, { Component } from "react";
import { Link } from "react-router-dom";
import { Query } from "react-apollo";
import gql from "graphql-tag";
import Loading from "./Loading.jsx";

const SPORT_DETAILS = gql`
    query Sport($sportId: Int!) {
        sport(id: $sportId) {
            id
            name
            leagues {
                id
                name
            }
        }
    }
`;
const extractSportIdFromUrl = url => parseInt(url.match(/\/sports\/(\d+)/)[1]);

const LeaguesPage = ({ match }) => (
    <Query query={ SPORT_DETAILS } variables={{ sportId: extractSportIdFromUrl(match.url) }}>
        {({ loading, error, data }) => {
            if (loading) return <Loading/>;
            if (error) return `Error!: ${error}`;

            return data.sport.leagues.map((league, ind) =>
                <div key={ ind }>
                    <Link to={ `/sports/${data.sport.id}/leagues/${league.id}` }>
                        { league.name }
                    </Link>
                </div>
            );
        }}
    </Query>
)
export default LeaguesPage;
