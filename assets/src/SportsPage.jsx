import React, { Component } from "react";
import { Link } from "react-router-dom";
import { Query } from "react-apollo";
import gql from "graphql-tag";
import Loading from "./Loading.jsx";

const SPORTS = gql`
    {
        sports {
            id
            name
        }
    }
`;

const SportsPage = () => (
    <Query
        query={ SPORTS }
    >
        {({ loading, error, data }) => {
            if (loading) return <Loading/>;
            if (error) return <p>Error :(</p>;

            return data.sports.map((sport, ind) =>
                <div key={ ind }>
                    <Link to={ `/sports/${sport.id}` }>
                        { sport.name }
                    </Link>
                </div>
            )
        }}
    </Query>
);

export default SportsPage;
