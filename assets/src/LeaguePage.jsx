import React from "react";
import { Link } from "react-router-dom";
import { Query } from "react-apollo";
import gql from "graphql-tag";
import Loading from "./Loading.jsx";

const LEAGUE_DETAILS = gql`
    query League($leagueId: Int!) {
        league(id: $leagueId) {
            id
            name
            sides {
              name
            }
          }
    }
`

const extractLeagueIdFromUrl = url => parseInt(url.match(/\/sports\/\d+\/leagues\/(\d+)/)[1]);
const extractSportIdFromUrl = url => parseInt(url.match(/\/sports\/(\d+)/)[1]);

const LeaguePage = ({ match }) => (
    <Query query={ LEAGUE_DETAILS } variables={{ leagueId: extractLeagueIdFromUrl(match.url) }}>
        {({ loading, error, data }) => {
            if (loading) return <Loading/>;
            if (error) return `Error!: ${error}`;

            return (
                <div>
                    <h2>{ data.league.name }</h2>
                    <h4>Next metches:</h4>
                    <br></br>
                    <h4>Previous metches:</h4>
                    <br></br>
                    <h4>Sides:</h4>
                    {
                        data.league.sides.map((side, ind) =>
                            <div key={ ind }>
                                <div>{ side.name }</div>
                            </div>
                        )
                    }
                    <Link to={ `/sports/${extractSportIdFromUrl(match.url)}/leagues/${data.league.id}/seasons` }>
                        Archives
                    </Link>
                </div>
            )
        }}
    </Query>
);
export default LeaguePage;
