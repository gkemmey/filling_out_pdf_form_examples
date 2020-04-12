def text
  Prawn::Document.generate("out/text.pdf") do
    string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor " \
             "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud " \
             "exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."

    stroke_color "4299e1" # #4299e1

    [:truncate, :expand, :shrink_to_fit].each_with_index do |mode, i|
      text_box string, at: [i * 150, cursor],
                       width: 100,
                       height: 50,
                       overflow: mode
      stroke_rectangle([i * 150, cursor], 100, 50)
    end
  end
end
