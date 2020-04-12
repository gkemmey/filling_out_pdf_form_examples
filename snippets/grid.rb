def grid
  # make a grid sheet
  Prawn::Document.generate("out/grid_sheet.pdf", page_layout: :landscape,
                                                 margin: 0,
                                                 page_size: "LETTER") do # 8.5.in x 11.in

    height = 612
    width = 792

    (0..height).step(10).each do |y_pos|
      horizontal_line 12, width, at: y_pos
      stroke_color "e2e8f0" and stroke #e2e8f0

      fill_color "4a5568" #4a5568
      text_box("#{y_pos}", at: [0, y_pos + 3], width: 12, height: 6, size: 6, align: :right)

      (0..width).step(10).each do |x_pos|
        vertical_line 10, height, at: x_pos
        stroke_color "e2e8f0" and stroke #e2e8f0

        fill_color "4a5568" #4a5568
        text_box("#{x_pos}", at: [x_pos - 2, 0], width: 12, height: 6, size: 6, align: :right, rotate: 90)
      end
    end
  end

  # put it on our unfilled form
  form = CombinePDF.load("templates/osha_form_300.pdf")
  grid = CombinePDF.load("out/grid_sheet.pdf").pages[0]
  grid.rotate_right

  form.pages[0] << grid

  form.save("out/osha_form_300_with_grid.pdf")
end
