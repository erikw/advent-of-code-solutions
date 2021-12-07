class Array
  def median
    sorted = sort
    if size.even?
      (sorted[size / 2 - 1] + sorted[size / 2]) / 2.0
    else
      sort[size / 2]
    end
  end

  def avg
    sum / (1.0 * length)
  end
end
