defmodule Test do

#run the program

  def demo() do
    small(0.294, 0.4835, 1.298)
    #small(-0.02,0.8,0.508)
  end
  def small(x0, y0, xn) do
    width = 1500
    height = 1000
    depth = 400
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
  end

end
