defmodule GallowsSocketWeb.HangmanChannel do
  require Logger
  use Phoenix.Channel

  def join("hangman:game", _, socket) do
    game = Hangman.new_game()
    socket = assign(socket, :game, game)
    { :ok, socket }
  end

  def handle_in("tally", _, socket) do
    tally = socket.assigns.game
            |> Hangman.tally()
            |> Map.update!(:used, &MapSet.to_list/1) # convert :used MapSet to list
    push(socket, "tally", tally)
    {:noreply, socket}
  end
end
