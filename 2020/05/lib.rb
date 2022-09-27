ROWS = 128
COLS = 8
SEG1_LEN = 7

def calc_row_col(bsp_seat)
  seg_rows = bsp_seat[0...SEG1_LEN]
  seg_cols = bsp_seat[SEG1_LEN...]

  row_lo = 0
  row_hi = ROWS - 1
  seg_rows.each_char do |half|
    mid = (row_lo + row_hi) / 2.0
    if half == 'F'
      row_hi = mid.floor
    else
      row_lo = mid.ceil
    end
  end

  col_lo = 0
  col_hi = COLS - 1
  seg_cols.each_char do |half|
    mid = (col_lo + col_hi) / 2.0
    if half == 'L'
      col_hi = mid.floor
    else
      col_lo = mid.ceil
    end
  end

  [row_lo, col_lo]
end

def seat_id(row, col)
  row * 8 + col
end
