Examples of filling out PDF forms using [`prawn`](https://github.com/prawnpdf/prawn) and [`combine_pdf`](https://github.com/boazsegev/combine_pd). I wrote more about the approach here: http://blog.graykemmey.com/2020/07/18/a-great-way-to-generate-pdfs-with-some-questionable-ruby/.

### Setup

```
$ bundle install
```

### Running

#### Snippets

```
$ ruby run_snippet (hello_world | rectangle | text | grid)
$ open out/(assignment | explicit | grid_sheet | implicit | text).pdf
```

#### OSHA Form 300

```
$ bunde exec ruby fill_out_form_300.rb
$ open out/osha_form_300.pdf
```

### Credits

- [u/hcollider](https://www.reddit.com/r/rails/comments/8ohntl/generating_pdf_form_with_prawn/e03k552/)
- [`prawn`](https://github.com/prawnpdf/prawn)
- [`combine_pdf`](https://github.com/boazsegev/combine_pd)
- Any [OSHA Forms](https://www.osha.gov/recordkeeping/new-osha300form1-1-04-FormsOnly.pdf) are obviously [theirs](https://www.osha.gov/)
