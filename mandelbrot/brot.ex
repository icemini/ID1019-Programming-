defmodule Brot do

  # calculate the mandelbrot value of
  # complex value c with a maximum iteration of m
  # returns 0..(m - 1)
  def mandelbrot(c, m) do
    z0 = Cmplx.new(0, 0)    # start value of z = 0
    i = 0
    test(i, z0, c, m)
  end

  # if we have reached the maximum iteration -> return 0
  # if the absolute value of z is greater than 2 -> return i
  def test(m, _z, _c, m) do 0 end
  def test(i, z, c, m) do
    z_abs = Cmplx.abs(z)
    z_pow = :math.pow(z_abs, 2)
    # if |z| < 2
    if z_pow < 4 do
      newZ = Cmplx.add(Cmplx.sqr(z), c) # perform the formula zn+1 = z^2n + c
      test(i+1, newZ, c, m)

    # if |z| > 2
    # number does not belong to the mandelbrot set
    else
      i   #point where |zi| > 2, this is the color -> where we break the |z| < 2 rule
    end
  end

end
