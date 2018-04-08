defmodule Mandel do



  #calculate an image

#interface
#generate image of size Width, Height
#offset between two points is k
#k is so you can move in rows and columns
def mandelbrot(width, height, x, y, k, depth) do
  #takes a pixel position and returns complex number
  #we should compute the depth of the complex number
  trans = fn(w, h) ->
  #k is 0 at the beginning
  #when k increases the width and height will decrease
  Cmplx.new(x + k * (w - 1), y - k * (h - 1))
  end
  rows(width, height, trans, depth, [])
end

#return a list of rows where each row is a list of colors
def rows(_, 0, _, _, rowsList) do  #we have gone through one row
  rowsList
end
def rows(width, height, trans, depth, rowsList) do
  row = row(width, height, trans, depth, [])
  rows(width, height-1, trans, depth, [row | rowsList])
end

#go through one row
#each item in a row is a tuple containing complex numbers that corresponds to a pixel
def row(0, _, _, _, rowList) do  #we have gone through one row
  rowList
end
def row(width, height, trans, depth, rowList) do
  cmplx = trans.(width, height)   #get complex number that corresponds to a pixel
  cmplx_depth = Brot.mandelbrot(cmplx,depth)  #calculate the depth of the complex value
  #color = Color.convert(cmplx_depth, depth) #old
  color = Color.convert1(cmplx_depth, depth)   #convert depth to a color
  new_rowList = [color | rowList]              #add the color to our list
  row(width-1, height, trans, depth, new_rowList)
end



end
