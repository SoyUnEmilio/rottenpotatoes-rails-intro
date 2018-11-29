module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def selected(parameter, name)
    parameter.to_s == name ? "hilite" : ""
  end
end