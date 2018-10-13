import React, { Component } from "react";
import { Link } from "react-router-dom";
import axios from "axios";
const scorifyGraphQL = axios.create({
  baseURL: "http://localhost:4000/graphiql",
});

const SPORTS = `
    query {
        sports {
            id
            name
        }
    }
`;

export default class SportsPage extends Component {
    state = {
        sports: []
    }

    fetchData = () => {
        scorifyGraphQL
            .post("", { query: SPORTS })
            .then(response => {
                this.setState({
                    sports: response.data.data.sports
                });
            })
    }

    componentDidMount() {
        this.fetchData();
    }

    render() {
        return (
            <div>
                {
                    this.state.sports.map((sport, ind) => 
                        <div key={ ind }>
                            <Link to={ `/sports/${sport.id}` }>
                                { sport.name }
                            </Link>
                        </div>
                    )
                }
            </div>
        );
    }
} 