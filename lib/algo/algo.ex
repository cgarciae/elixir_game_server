defmodule GameServer.Algo do
  use GameServer.Web, :controller

  def hola(conn,_) do
    text conn, "mundo!"
  end
end