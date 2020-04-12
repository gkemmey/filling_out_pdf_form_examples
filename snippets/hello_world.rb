def hello_world
  # assignment
  pdf = Prawn::Document.new
  pdf.text "Hello World"
  pdf.render_file "out/assignment.pdf"

  # implicit Block
  Prawn::Document.generate("out/implicit.pdf") do
   text "Hello World"
  end

  # explicit Block
  Prawn::Document.generate("out/explicit.pdf") do |pdf|
    pdf.text "Hello World"
  end
end
