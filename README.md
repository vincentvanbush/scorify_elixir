# ScorifyElixir

Scorify app in Elixir with a HTML + JS (frontend technology TBD) app.

## Installation

Install Erlang (current version - 21.0.7 as of the time of writing), and then Elixir 1.7, preferrably using https://github.com/asdf-vm, https://github.com/asdf-vm/asdf-elixir and https://github.com/asdf-vm/asdf-elixir. NodeJS is also required, you can either use your already installed node or try using https://github.com/asdf-vm/asdf-nodejs.

Use `mix deps.get` to ensure all dependencies required by the app are in place.

Having ensured PostgreSQL is installed on your machine, run `mix ecto.create` and then `mix ecto.migrate` to create the application's DB schema.

Then, run `mix run priv/repo/seeds.exs` to create some seed data for initial app usage.

Finally, go to `assets` folder and use `yarn` to get JS dependencies.

## Usage

To start the server in development mode, use `mix phx.server`. By default the website is available at `localhost:4000`.

At `localhost:4000/graphiql`, GraphiQL UI for exploring the GraphQL api is exposed, so that the API can be tested.

## Deployment

Currently Dokku and Heroku deployment are supported out of the box.

In Dokku, all one needs is to create an app and link a PostgreSQL container to it, and then push to the app's Dokku remote.

For Heroku deployment, one has to add the content of `.buildpacks` to the list of buildpacks for the Heroku app (Heroku does not read this file).
