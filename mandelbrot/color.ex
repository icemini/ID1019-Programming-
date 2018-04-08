defmodule Color do

  #given a depth on scale from zero to max
  #return color
  def convert(depth, maxDepth) do
    f = depth/maxDepth
    a = f*4
    #x and y are used to give a RGB value
    x = trunc(a)
    y = trunc(255 * (a-x))

    case x do

      0 ->
        # black -> red
        {:rgb, y, 0, 0}

      1 ->
        # red -> yellow
        {:rgb, 255, y, 0}

      2 ->
        # yellow -> green
        {:rgb, 255 - y, 255, 0}

      3 ->
        # green -> cyan
        {:rgb, 0, 255, y}

      4 ->
        # cyan -> blue
        {:rgb, 0, 255 - y, 255}

    end

  end

#another way of coloring
  def convert1(depth, max) do
    fraction = (depth / max) * 4
    section = trunc(fraction)
    percent = (fraction - section)

    case section do
        0 -> color({0,0,0}, {255,0,0}, percent)
        1 -> color({160,82,45}, {188,143,143}, percent)
        2 -> color({255,192,203}, {244,164,96}, percent)
        3 -> color({160,82,45}, {165,42,42}, percent)
        4 -> color({222,184,135}, {255,182,193}, percent)
    end
  end

  def color({r1, g1, b1}, {r2, g2, b2}, percent) do
    {shade(r1, r2, percent), shade(g1, g2, percent), shade(b1, b2, percent)}
  end

  #put some shading
    def shade(x, y, percent) do
      trunc(x + (percent * (y - x)))
    end

end
