defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_blocks
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Image{blocks: blocks}) do
    image = :egd.create(250, 250)

    Enum.each blocks, fn(%Block{from_horizontal: from_horizontal, from_vertical: from_vertical, rgb: rgb}) ->
      background = :egd.color(rgb)
      :egd.filledRectangle(image, {from_horizontal, from_vertical}, {from_horizontal + 50, from_vertical + 50}, background)
    end

    :egd.render(image)
  end

  def build_blocks(%Image{hex: hex, rgb: rgb} = image) do
    blocks =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row(&1))
      |> List.flatten
      |> Enum.with_index
      |> Enum.map(&build_block(&1, rgb))

    %Image{ image | blocks: blocks}
  end

  def build_block({value, index}, rgb) do
    %Block{
      rgb: get_rgb_color(value, rgb),
      index: index,
      from_horizontal: rem(index, 5) * 50,
      from_vertical: div(index, 5) * 50
    }
  end

  def get_rgb_color(number, rgb) do
    if rem(number, 2) == 0, do: rgb, else: {255, 255, 255}
  end

  def mirror_row([first, second | _third] = row) do
    row ++ [second, first]
  end

  def hash_input(input) do
    hex = :md5
    |> :crypto.hash(input)
    |> :binary.bin_to_list

    %Image{hex: hex}
  end

  def pick_color(%Image{hex: [r, g, b | _tail]} = image) do
    %{image | rgb: {r, g, b}}
  end

end
