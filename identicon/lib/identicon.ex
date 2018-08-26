defmodule Identicon do

  @moduledoc """
    Provides methods to build, draw and save Identicons
  """

  @doc """
    Create a new Identicon based in the given `input`.
    The file generated will be the values of `input` as png image.
    returns if the image was created or not (:ok, :error)

  ## Examples

        iex> Identicon.create("leonardo")
        :ok
  """
  def create(input) do
    input
    |> hash_input
    |> pick_color
    |> build_blocks
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Save the given `image` as png with the given `filename`
    returns if the image was saved or not (:ok, :error)

  ## Examples

        iex> image = :egd.create(250, 250)
        iex> Identicon.save_image(:egd.render(image), "leonardo")
        :ok
  """
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  @doc """
    Draw the blocks of the given `image`
    returns the binary of this image

  ## Examples

        iex> image = %Identicon.Image{blocks: [
        ...> %Identicon.Block{rgb: {255, 255, 255}, from: {0, 0}, to: {50, 50}}
        ...> ]}
        iex> is_binary(Identicon.draw_image(image))
        true

  """
  def draw_image(%Identicon.Image{blocks: blocks}) do
    image = :egd.create(250, 250)

    Enum.each blocks, fn(%Identicon.Block{from: from, to: to, rgb: rgb}) ->
      background = :egd.color(rgb)
      :egd.filledRectangle(image, from, to, background)
    end

    :egd.render(image)
  end

  def build_blocks(%Identicon.Image{hex: hex, rgb: rgb} = image) do
    blocks =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row(&1))
      |> List.flatten
      |> Enum.with_index
      |> Enum.map(&build_block(&1, rgb))

    %Identicon.Image{ image | blocks: blocks}
  end

  def build_block({value, index}, rgb) do
    horizontal = rem(index, 5) * 50
    vertical = div(index, 5) * 50
    %Identicon.Block{
      rgb: get_rgb_color(value, rgb),
      from: {horizontal, vertical},
      to: {horizontal + 50, vertical + 50}
    }
  end

  def get_rgb_color(number, rgb) do
    if rem(number, 2) == 0, do: rgb, else: {225, 225, 225}
  end

  def mirror_row([first, second | _third] = row) do
    row ++ [second, first]
  end

  def hash_input(input) do
    hex = :md5
    |> :crypto.hash(input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %{image | rgb: {r, g, b}}
  end

end
