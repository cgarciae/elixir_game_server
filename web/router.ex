defmodule GameServer.Router do
  use GameServer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GameServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/hola", Algo, :hola
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", GameServer do
    pipe_through :api

    resources "/games", GameController, except: [:new, :edit]
    get "/games/:id/players", GameController, :players
    get "/games/:id/players/top", GameController, :top
    get "/games/:id/plot", GameController, :plot

    get "/players/top", PlayerController, :top
    resources "/players", PlayerController, except: [:new, :edit]

  end
end
