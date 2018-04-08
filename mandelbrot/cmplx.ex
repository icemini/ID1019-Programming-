defmodule Cmplx do

  # returns complex number with real value real and imaginary img
  def new(real, img) do
    {:cmplx, real, img}
  end

  # add two complex numbers
  def add({:cmplx, real1, img1}, {:cmplx, real2, img2}) do
    {:cmplx, real1+real2, img1+img2}
  end

  # squares a complex number
  def sqr({:cmplx, real, img}) do
    {:cmplx, real*real - img*img, 2*real*img}
  end

  # takes the absolute value of a complex number
  def abs({:cmplx, real, img}) do
    :math.sqrt(real*real + img*img)
  end

end
