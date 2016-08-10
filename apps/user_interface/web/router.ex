defmodule UserInterface.Router do
  use UserInterface.Web, :router

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

  scope "/", UserInterface do
    pipe_through :browser # Use the default browser stack

    get "/", ChoreController, :index
    get "/chores/:id/next", ChoreController, :next
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserInterface do
  #   pipe_through :api
  # end
end
