defmodule CaptivePortalLoginRedirector do
  def init(default_opts) do
    default_opts
  end

  def call(conn, _opts) do
    conn
    |> Plug.Conn.put_resp_header("Location", "http://elixirconf.chores.net:8080")
    |> Plug.Conn.send_resp(302, "redirect")
  end
end
