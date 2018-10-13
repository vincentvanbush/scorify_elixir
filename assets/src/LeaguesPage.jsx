import React, { Component } from "react";
import { Link } from "react-router-dom";
import axios from "axios";
const scorifyGraphQL = axios.create({
    baseURL: "http://localhost:4000/graphiql",
});

const sportDetailsQuery = sportId => (`
    query {
        sport(id: ${sportId}) {
            id
            name
            leagues {
                id
                name
            }
        }
    }
`);

const extractSportIdFromUrl = url => parseInt(url.match(/\/sports\/(\d+)/)[1]);

export default class LeaguesPage extends Component {
    state = {
        sport: null
    }

    fetchData = () => {
        scorifyGraphQL
            .post("", { 
                query: sportDetailsQuery(
                    extractSportIdFromUrl(this.props.match.url)
                )
            })
            .then(response => {
                this.setState({
                    sport: response.data.data.sport
                })
            })
    }

    componentDidMount() {
        this.fetchData();
    }

    render() {
        return (
            <div>
                {
                    this.state.sport
                    ?
                        this.state.sport.leagues.map((league, ind) =>
                            <div key={ ind }>
                                <Link to={ `/sports/${this.state.sport.id}/leagues/${league.id}` }>
                                    { league.name }
                                </Link>
                            </div>
                        )
                    :
                        <div>Loading...</div>
                }
            </div>
        );
    }
}

