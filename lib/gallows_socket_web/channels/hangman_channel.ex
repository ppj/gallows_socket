defmodule GallowsSocketWeb.HangmanChannel do
  require Logger
  use Phoenix.Channel

  def join("hangman:game", _, socket) do
    socket = socket
             |> assign(:game, Hangman.new_game())
    { :ok, socket }
  end

  def handle_in("tally", _, socket) do
    tally = socket.assigns.game
            |> Hangman.tally()
            |> Map.update!(:used, &MapSet.to_list/1) # convert :used MapSet to list
    push(socket, "tally", tally)
    {:noreply, socket}
  end

  def handle_in("make_move", guess, socket) do
    tally = socket.assigns.game
            |> Hangman.make_move(guess)
            |> Map.update!(:used, &MapSet.to_list/1) # convert :used MapSet to list
    push(socket, "tally", tally)
    { :noreply, socket }
  end

  def handle_in("new_game", _, socket) do
    Logger.info("Starting new game...")
    socket = socket
             |> assign(:game, Hangman.new_game())
    handle_in("tally", nil, socket)
  end

  def handle_in(message, _, socket) do
    Logger.error("Invalid message received: #{message}")
    {:noreply, socket}
  end
end
