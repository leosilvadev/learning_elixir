defmodule Todo.List do

  alias Todo.Item
  alias Todo.List

  @moduledoc """
  Documentation for Todo.
  """
  defstruct auto_id: 1, entries: %{}

  def new(), do: %List{}

  def add_entry(%List{auto_id: auto_id, entries: entries} = todo_list, %Item{} = item) do
    entry = Map.put(item, :id, auto_id)
    %List{
      todo_list |
      auto_id: auto_id + 1,
      entries: Map.put(entries, auto_id, entry)
    }
  end

  def entries(%List{entries: entries}, %Date{} = date) do
    entries
    |> Stream.filter(fn {_, %Item{date: entry_date}} -> entry_date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(%List{entries: entries} = todo_list, id, updater) do
    case Map.fetch(entries, id) do
      :error -> todo_list
      {:ok, entry} ->
        new_entry = %Item{id: ^id} = updater.(entry)
        %List{
          todo_list |
          entries: Map.put(entries, id, new_entry)
        }
    end
  end
end
