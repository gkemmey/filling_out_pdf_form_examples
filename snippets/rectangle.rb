# draw with bottom left hand corder at 0, 0
def rectangle
  Prawn::Document.generate("out/rectangle.pdf") do
    stroke_axis
    stroke_circle [0, 0], 10

    bounding_box([100, 300], width: 300, height: 200) do
     stroke_bounds
     stroke_circle [0, 0], 10
    end
  end
end
