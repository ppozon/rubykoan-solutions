# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)

  if (a == 0) or (b == 0) or (c == 0) or
     (a < 0) or (b < 0) or (c < 0)
    raise TriangleError, "Triangle must have sides of positive length"
  end

  arr = [ a, b, c].sort

  if (arr[2] >= (arr[1] + arr[0])) 
    raise TriangleError, "Not valid side lengths"
  end

  # Oops! Only for right-triangles, which we're not looking at here!

  # if ( (arr[0] * arr[0]) + (arr[1] * arr[1]) != (arr[2] * arr[2]))
  #   raise TriangleError, "Side lengths don't fit Pythagorean theorem."
  # end
  
  if (a == b) and (b == c) 
    result = :equilateral
  else
    if (a != b) and (b != c) and (a != c)
      result = :scalene
    else
      result = :isosceles
    end
  end

  result
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
