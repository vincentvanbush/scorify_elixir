import React from "react";
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

            return (
                <div>
                    <h2>Sports:</h2>
                    {
                        data.sports.map((sport, ind) =>
                            <div key={ ind }>
                                <Link to={ `/sports/${sport.id}/leagues` }>
                                    { sport.name }
                                </Link>
                            </div>
                        )
                    }
                </div>
            );
        }}
    </Query>
);

export default SportsPage;
