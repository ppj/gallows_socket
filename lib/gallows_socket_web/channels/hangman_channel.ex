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
            |> cleaned_up_tally() # :used is a MapSet that needs to be converted to a list
    push(socket, "tally", tally)
    {:noreply, socket}
  end

  defp cleaned_up_tally(tally) do
    tally = tally
            |> Map.put(:used, MapSet.to_list(tally.used))
  end
end
