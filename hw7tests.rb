class Intersect
  attr_reader :e1, :e2
end
class Let
  attr_reader :s, :e1, :e2
end
class Var
  attr_reader :s
end
class Shift
  attr_reader :dx, :dy, :e
end
def equal(e1, e2)
  if e1.class.name != e2.class.name
    return false
  end

  if e1.is_a? NoPoints
    true
  elsif e1.is_a? Point
    # == should be real_close instead.
    e1.x == e2.x and e1.y == e2.y
  elsif e1.is_a? Line
    # == should be real_close instead.
    e1.m == e2.m and e1.b == e2.b
  elsif e1.is_a? VerticalLine
    # == should be real_close instead.
    e1.x == e2.x
  elsif e1.is_a? LineSegment
    # == should be real_close instead.
    e1.x1 == e2.x1 and e1.y1 == e2.y1 and e1.x2 == e2.x2 and e1.y2 == e2.y2
  elsif e1.is_a? Intersect
    equal(e1.e1, e2.e1) and equal(e1.e2, e2.e2)
  elsif e1.is_a? Let
    e1.s == e2.s and equal(e1.e1, e2.e1) and equal(e1.e2, e2.e2)
  elsif e1.is_a? Var
    e1.s == e2.s
  elsif e1.is_a? Shift
    # == should be real_close instead.
    e1.dx == e2.dx and e1.dy == e2.dy and equal(e1.e, e2.e)
  else
    false
  end
end

tests = []
tests[0] = equal(NoPoints.new.preprocess_prog, NoPoints.new)
tests[1] = equal(Point.new(1.0, 1.0).preprocess_prog, Point.new(1.0, 1.0))
tests[2] = equal(Line.new(1.0, 2.0).preprocess_prog, Line.new(1.0, 2.0))
tests[3] = equal(VerticalLine.new(2.0).preprocess_prog, VerticalLine.new(2.0))
tests[4] = equal(LineSegment.new(1.0, 1.0, 1.0, 1.0).preprocess_prog, Point.new(1.0, 1.0))
tests[5] = equal(LineSegment.new(1.0, 1.0, 1.0, 2.0).preprocess_prog, LineSegment.new(1.0, 1.0, 1.0, 2.0))
tests[6] = equal(LineSegment.new(1.0, 1.0, 1.0, 0.0).preprocess_prog, LineSegment.new(1.0, 0.0, 1.0, 1.0))
tests[7] = equal(LineSegment.new(1.0, 1.0, 2.0, 1.0).preprocess_prog, LineSegment.new(1.0, 1.0, 2.0, 1.0))
tests[8] = equal(LineSegment.new(1.0, 0.0, 2.0, 1.0).preprocess_prog, LineSegment.new(1.0, 0.0, 2.0, 1.0))
tests[9] = equal(LineSegment.new(1.0, 1.0, 2.0, 0.0).preprocess_prog, LineSegment.new(1.0, 1.0, 2.0, 0.0))
tests[10] = equal(LineSegment.new(2.0, 1.0, 1.0, 1.0).preprocess_prog, LineSegment.new(1.0, 1.0, 2.0, 1.0))
tests[11] = equal(LineSegment.new(2.0, 0.0, 1.0, 1.0).preprocess_prog, LineSegment.new(1.0, 1.0, 2.0, 0.0))
tests[12] = equal(LineSegment.new(2.0, 1.0, 1.0, 0.0).preprocess_prog, LineSegment.new(1.0, 0.0, 2.0, 1.0))

tests[13] = equal(LineSegment.new(1.00000999, 1.0, 1.0, 2.0).preprocess_prog, LineSegment.new(1.00000999, 1.0, 1.0, 2.0)) 

tests[14] = equal(Let.new("x", LineSegment.new(1.0, 1.0, 1.0, 1.0), Var.new("x")).preprocess_prog, Let.new("x", Point.new(1.0, 1.0), Var.new("x")))
tests[15] = equal(Shift.new(1.0, 1.0, LineSegment.new(1.0, 1.0, 1.0, 1.0)).preprocess_prog, Shift.new(1.0, 1.0, Point.new(1.0, 1.0)))
tests[16] = equal(Intersect.new(LineSegment.new(1.0, 1.0, 1.0, 1.0), LineSegment.new(2.0, 1.0, 1.0, 0.0)).preprocess_prog, Intersect.new(Point.new(1.0, 1.0), LineSegment.new(1.0, 0.0, 2.0, 1.0)))
tests[17] = equal(Shift.new(1.0, 1.0, Intersect.new(LineSegment.new(1.0, 1.0, 1.0, 1.0), LineSegment.new(2.0, 1.0, 1.0, 0.0))).preprocess_prog, Shift.new(1.0, 1.0, Intersect.new(Point.new(1.0, 1.0), LineSegment.new(1.0, 0.0, 2.0, 1.0))))

# eval_prog
# Shift
tests[20] = equal(Shift.new(1.0, 1.0, Point.new(2.0, 3.0)).eval_prog([]), Point.new(3.0, 4.0))
tests[21] = equal(Shift.new(2.0, 10.3, Line.new(3.0, 5.0)).eval_prog([]), Line.new(3.0, 9.3))
tests[22] = equal(Shift.new(1.0, 2.0, VerticalLine.new(5.0)).eval_prog([]), VerticalLine.new(6.0))
tests[23] = equal(Shift.new(2.0, 2.0, LineSegment.new(1.0, 1.0, 1.0, 1.0)).preprocess_prog.eval_prog([]), Point.new(3.0, 3.0))
tests[24] = equal(Shift.new(1.0, 2.0, LineSegment.new(1.0, 1.0, 3.0, 3.0)).preprocess_prog.eval_prog([]), LineSegment.new(2.0, 3.0, 4.0, 5.0)) 
tests[25] = equal(Shift.new(1.0, 1.0, Shift.new(1.0, 1.0, Shift.new(1.0, 1.0, Point.new(1.0, 1.0)))).preprocess_prog.eval_prog([]), Point.new(4.0, 4.0))

# Let
tests[31] = equal(Let.new("x", Point.new(2.0, 3.0), Var.new("x")).preprocess_prog.eval_prog([]), Point.new(2.0, 3.0)) 
tests[32] = equal(Let.new("x", Line.new(3.0, 5.0), Var.new("x")).preprocess_prog.eval_prog([]), Line.new(3.0, 5.0))
tests[33] = equal(Let.new("x", VerticalLine.new(1.0), Var.new("x")).preprocess_prog.eval_prog([]), VerticalLine.new(1.0))
tests[34] = equal(Let.new("x", LineSegment.new(2.0, 2.0, 1.0, 1.0), Var.new("x")).preprocess_prog.eval_prog([]), LineSegment.new(1.0, 1.0, 2.0, 2.0))
tests[35] = equal(Let.new("x", Point.new(1.0, 1.0), Let.new("x", Point.new(2.0, 2.0), Var.new("x"))).preprocess_prog.eval_prog([]), Point.new(2.0, 2.0))

# Let + Shift
tests[40] = equal(Let.new("x", LineSegment.new(1.0, 1.0, 1.0, 1.0), Shift.new(1.0, 1.0, Var.new("x"))).preprocess_prog.eval_prog([]), Point.new(2.0, 2.0))
tests[41] = equal(Shift.new(1.0, 1.0, Let.new("x", VerticalLine.new(2.0), Var.new("x"))).preprocess_prog.eval_prog([]), VerticalLine.new(3.0))

# Intersect
# NoPoints
tests[42] = equal(Intersect.new(NoPoints.new, NoPoints.new).preprocess_prog.eval_prog([]), NoPoints.new)
tests[46] = equal(Intersect.new(NoPoints.new, Point.new(1.0, 2.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[47] = equal(Intersect.new(NoPoints.new, Line.new(1.0, 1.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[48] = equal(Intersect.new(NoPoints.new, VerticalLine.new(1.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[49] = equal(Intersect.new(NoPoints.new, LineSegment.new(1.0, 1.0, 3.0, 3.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[50] = equal(Intersect.new(Point.new(1.0, 1.0), Point.new(1.00000999, 1.0)).preprocess_prog.eval_prog([]), Point.new(1.00000999, 1.0))
tests[51] = equal(Intersect.new(Point.new(1.0, 1.0), Point.new(1.0999, 1.0)).preprocess_prog.eval_prog([]), NoPoints.new)
# Point
tests[52] = equal(Intersect.new(Point.new(1.0, 4.0), Line.new(1.0, 3.0)).preprocess_prog.eval_prog([]), Point.new(1.0, 4.0))
tests[53] = equal(Intersect.new(Point.new(2.0, 4.0), Line.new(1.0, 3.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[54] = equal(Intersect.new(Point.new(2.0, 4.0), VerticalLine.new(2.0)).preprocess_prog.eval_prog([]), Point.new(2.0, 4.0))
tests[55] = equal(Intersect.new(Point.new(4.0, 4.0), VerticalLine.new(2.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[56] = equal(Intersect.new(Point.new(2.0, 2.0), LineSegment.new(0.0, 0.0, 3.0, 3.0)).preprocess_prog.eval_prog([]), Point.new(2.0, 2.0))
tests[57] = equal(Intersect.new(Point.new(4.0, 4.0), LineSegment.new(0.0, 0.0, 3.0, 3.0)).preprocess_prog.eval_prog([]), NoPoints.new)
# Line
tests[58] = equal(Intersect.new(Line.new(1.0, 2.0), Line.new(2.0, 0.0)).preprocess_prog.eval_prog([]), Point.new(2.0, 4.0))
tests[59] = equal(Intersect.new(Line.new(1.0, 2.0), Line.new(1.0, 3.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[60] = equal(Intersect.new(Line.new(1.0, 2.0), VerticalLine.new(2.0)).preprocess_prog.eval_prog([]), Point.new(2.0, 4.0))
tests[61] = equal(Intersect.new(Line.new(1.0, 0.0), LineSegment.new(0.0, 0.0, 4.0, 4.0)).preprocess_prog.eval_prog([]), LineSegment.new(0.0, 0.0, 4.0, 4.0))
tests[62] = equal(Intersect.new(Line.new(2.0, 0.0), LineSegment.new(0.0, 0.0, 4.0, 4.0)).preprocess_prog.eval_prog([]), Point.new(0.0, 0.0))
tests[63] = equal(Intersect.new(Line.new(2.0, 0.0), LineSegment.new(1.0, 1.0, 4.0, 4.0)).preprocess_prog.eval_prog([]), NoPoints.new)

# VerticalLine
tests[64] = equal(Intersect.new(VerticalLine.new(1.0), VerticalLine.new(2.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[65] = equal(Intersect.new(VerticalLine.new(1.0), LineSegment.new(1.0, 0.0, 1.0, 4.0)).preprocess_prog.eval_prog([]), LineSegment.new(1.0, 0.0, 1.0, 4.0))
tests[66] = equal(Intersect.new(VerticalLine.new(1.0), LineSegment.new(0.0, 1.0, 3.0, 1.0)).preprocess_prog.eval_prog([]), Point.new(1.0, 1.0))
tests[67] = equal(Intersect.new(VerticalLine.new(1.0), LineSegment.new(2.0, 2.0, 4.0, 4.0)).preprocess_prog.eval_prog([]), NoPoints.new)

# LineSegment
tests[70] = equal(Intersect.new(LineSegment.new(0.0, 0.0, 0.0, 4.0), LineSegment.new(1.0, 0.0, 1.0, 4.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[71] = equal(Intersect.new(LineSegment.new(0.0, 0.0, 4.0, 0.0), LineSegment.new(0.0, 1.0, 4.0, 1.0)).preprocess_prog.eval_prog([]), NoPoints.new)
tests[72] = equal(Intersect.new(LineSegment.new(2.0, 0.0, 2.0, 4.0), LineSegment.new(0.0, 2.0, 4.0, 2.0)).preprocess_prog.eval_prog([]), Point.new(2.0, 2.0))
tests[73] = equal(Intersect.new(LineSegment.new(0.0, 0.0, 0.0, 4.0), LineSegment.new(0.0, 1.0, 0.0, 3.0)).preprocess_prog.eval_prog([]), LineSegment.new(0.0, 1.0, 0.0, 3.0))
tests[74] = equal(Intersect.new(LineSegment.new(0.0, 1.0, 0.0, 3.0), LineSegment.new(0.0, 0.0, 0.0, 4.0)).preprocess_prog.eval_prog([]), LineSegment.new(0.0, 1.0, 0.0, 3.0))
tests[75] = equal(Intersect.new(LineSegment.new(0.0, 1.0, 0.0, 3.0), LineSegment.new(0.0, 1.0, 0.0, 3.0)).preprocess_prog.eval_prog([]), LineSegment.new(0.0, 1.0, 0.0, 3.0))
tests[76] = equal(Intersect.new(LineSegment.new(0.0, 0.0, 0.0, 3.0), LineSegment.new(0.0, 1.0, 0.0, 4.0)).preprocess_prog.eval_prog([]), LineSegment.new(0.0, 1.0, 0.0, 3.0))


tests.each_with_index {|v,i| puts "#{i}: #{v}"}