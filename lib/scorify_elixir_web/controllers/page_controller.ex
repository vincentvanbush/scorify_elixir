defmodule ScorifyElixirWeb.PageController do
  use ScorifyElixirWeb, :controller

  def index(conn, _params) do
    conn |> render("index.html")
  end
end
