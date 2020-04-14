module PDF
  class Form300
    include PDF::Layout

    Y_OF_TOP_LEFT_CORNER_FOR_PAGE_TOTAL_CELLS = 142
    Y_OF_TOP_LEFT_CORNER_OF_FIRST_INCIDENT_CELL = 360
    SPACE_IN_BETWEEN_INCIDENT_ROWS = 16.5
    INCIDENT_ROWS_PER_SHEET = 13

    default_cell_height 14
    default_cell_font_size ->(options) { options[:height] }
    default_cell_valign :bottom
    default_cell_overflow :shrink_to_fit

    cell_type :field,      font_size: 7
    cell_type :page_total, y: Y_OF_TOP_LEFT_CORNER_FOR_PAGE_TOTAL_CELLS, width: 15,
                                                                         height: 10,
                                                                         align: :right
    cell_type :check_box, width: 6, height: 6, style: :bold, align: :center, valign: :center

    field :establishment_name, x: 658, y: 465, width: 110, height: 12
    field :city,               x: 622, y: 452, width: 80,  height: 12
    field :state,              x: 718, y: 452, width: 50,  height: 12
    field :year,               x: 709, y: 514, width: 25,  height: 14, font_size: 14, align: :center

    field :current_page,       x: 618, y: 110, width: 10, align: :right
    field :total_pages,        x: 635, y: 110, width: 10, align: :right

    page_total :classified_as_death_page_total,                       x: 476
    page_total :classified_as_days_away_from_work_page_total,         x: 506
    page_total :classified_as_job_transfer_or_restriction_page_total, x: 538
    page_total :classified_as_other_recordable_case_page_total,       x: 572.5

    page_total :days_away_from_work_page_total,                       x: 611
    page_total :days_on_transfer_or_restriction_page_total,           x: 641

    page_total :resulted_in_injury_page_total,                        x: 680, width: 10
    page_total :resulted_in_skin_disorder_page_total,                 x: 696, width: 10
    page_total :resulted_in_respiratory_condition_page_total,         x: 711, width: 10
    page_total :resulted_in_poisoning_page_total,                     x: 726, width: 10
    page_total :resulted_in_hearing_loss_page_total,                  x: 742, width: 10
    page_total :resulted_in_all_other_illness_page_total,             x: 757, width: 10

    table y:      Y_OF_TOP_LEFT_CORNER_OF_FIRST_INCIDENT_CELL,
          offset: SPACE_IN_BETWEEN_INCIDENT_ROWS do |t|

      field :case_number,                      x: 29,  width: 18
      field :employee_name,                    x: 53,  width: 82
      field :employee_title,                   x: 148, width: 40
      field :date_of_incident_month,           x: 198, width: 10, align: :right
      field :date_of_incident_day,             x: 210, width: 10, align: :right
      field :where_the_event_occurred,         x: 242, width: 62
      field :description_of_injury_or_illness, x: 320, width: 150

      check_box :classified_as_death,                       x: 480,   y: 353,   offset: (t.offset + 0.1)
      check_box :classified_as_days_away_from_work,         x: 508,   y: 353,   offset: (t.offset + 0.1)
      check_box :classified_as_job_transfer_or_restriction, x: 541,   y: 353.5, offset: (t.offset + 0.1)
      check_box :classified_as_other_recordable_case,       x: 576.5, y: 353.5, offset: (t.offset + 0.1)

      field :days_away_from_work,             x: 610, y: (t.y - 4), width: 15, height: 10, align: :right
      field :days_on_transfer_or_restriction, x: 640, y: (t.y - 4), width: 15, height: 10, align: :right

      check_box :resulted_in_injury,                x: 683, y: 351, offset: (t.offset - 0.05), width: 5, height: 5.5
      check_box :resulted_in_skin_disorder,         x: 698, y: 351, offset: (t.offset - 0.05), width: 5, height: 5.5
      check_box :resulted_in_respiratory_condition, x: 713, y: 351, offset: (t.offset - 0.05), width: 5, height: 5.5
      check_box :resulted_in_poisoning,             x: 728, y: 351, offset: (t.offset - 0.05), width: 5, height: 5.5
      check_box :resulted_in_hearing_loss,          x: 743, y: 351, offset: (t.offset - 0.05), width: 5, height: 5.5
      check_box :resulted_in_all_other_illness,     x: 758, y: 351, offset: (t.offset - 0.05), width: 5, height: 5.5
    end

    # -------- end layout stuffs --------

    def self.generate(incidents, attributes = {})
      new(incidents, attributes).generate
    end

    attr_accessor :incidents, :year, :location

    def initialize(incidents, attributes = {})
      @incidents = incidents
      attributes.each { |name, value| send("#{name}=", value) }
    end

    def pdf
      @pdf ||= Prawn::Document.new(page_layout: :landscape, page_size: "LETTER", margin: 0)
    end

    def total_pages
      @total_pages ||= (incidents.count / INCIDENT_ROWS_PER_SHEET.to_f).ceil
    end

    def generate
      incidents.each_slice(INCIDENT_ROWS_PER_SHEET).each_with_index do |incidents_group, page|
        pdf.start_new_page unless page.zero?

        fill_in_year(year.to_s.last(2))
        fill_in_establishment_name(location.name)
        fill_in_city(location.city)
        fill_in_state(location.state)

        fill_in_current_page(page + 1)
        fill_in_total_pages(total_pages)

        fill_in_classified_as_death_page_total                       incidents_group.count(&:classified_as_death?)
        fill_in_classified_as_days_away_from_work_page_total         incidents_group.count(&:classified_as_days_away_from_work?)
        fill_in_classified_as_job_transfer_or_restriction_page_total incidents_group.count(&:classified_as_job_transfer_or_restriction?)
        fill_in_classified_as_other_recordable_case_page_total       incidents_group.count(&:classified_as_other_recordable_case?)

        fill_in_days_away_from_work_page_total                       incidents_group.collect(&:days_away_from_work).compact.sum
        fill_in_days_on_transfer_or_restriction_page_total           incidents_group.collect(&:days_on_transfer_or_restriction).compact.sum

        fill_in_resulted_in_injury_page_total                        incidents_group.count(&:resulted_in_injury?)
        fill_in_resulted_in_skin_disorder_page_total                 incidents_group.count(&:resulted_in_skin_disorder?)
        fill_in_resulted_in_respiratory_condition_page_total         incidents_group.count(&:resulted_in_respiratory_condition?)
        fill_in_resulted_in_poisoning_page_total                     incidents_group.count(&:resulted_in_poisoning?)
        fill_in_resulted_in_hearing_loss_page_total                  incidents_group.count(&:resulted_in_hearing_loss?)
        fill_in_resulted_in_all_other_illness_page_total             incidents_group.count(&:resulted_in_all_other_illness?)

        incidents_group.each_with_index do |incident, row|
          fill_in_case_number                               incident.case_number,                                            row: row
          fill_in_employee_name                             incident.employee_name,                                          row: row
          fill_in_employee_title                            incident.employee_title,                                         row: row

          fill_in_date_of_incident_month                    incident.date_of_incident.split("/").first,                      row: row
          fill_in_date_of_incident_day                      incident.date_of_incident.split("/").second,                     row: row

          fill_in_where_the_event_occurred                  incident.where_the_event_occurred,                               row: row
          fill_in_description_of_injury_or_illness          incident.description_of_injury_or_illness,                       row: row

          fill_in_classified_as_death                       check_mark(incident.classified_as_death?),                       row: row
          fill_in_classified_as_days_away_from_work         check_mark(incident.classified_as_days_away_from_work?),         row: row
          fill_in_classified_as_job_transfer_or_restriction check_mark(incident.classified_as_job_transfer_or_restriction?), row: row
          fill_in_classified_as_other_recordable_case       check_mark(incident.classified_as_other_recordable_case?),       row: row

          fill_in_days_away_from_work                       incident.days_away_from_work,                                    row: row
          fill_in_days_on_transfer_or_restriction           incident.days_on_transfer_or_restriction,                        row: row

          fill_in_resulted_in_injury                        check_mark(incident.resulted_in_injury?),                        row: row
          fill_in_resulted_in_skin_disorder                 check_mark(incident.resulted_in_skin_disorder?),                 row: row
          fill_in_resulted_in_respiratory_condition         check_mark(incident.resulted_in_respiratory_condition?),         row: row
          fill_in_resulted_in_poisoning                     check_mark(incident.resulted_in_poisoning?),                     row: row
          fill_in_resulted_in_hearing_loss                  check_mark(incident.resulted_in_hearing_loss?),                  row: row
          fill_in_resulted_in_all_other_illness             check_mark(incident.resulted_in_all_other_illness?),             row: row
        end
      end

      combine_answers_with_form_template
    end

    private

      def check_mark(boolean)
        boolean ? "X" : ""
      end

      def combine_answers_with_form_template
        form = CombinePDF.load(File.join(App.root, "templates/osha_form_300.pdf")).pages[0]
        answers = CombinePDF.parse(pdf.render)
        out = CombinePDF.new

        answers.pages.each do |answer_page|
          out << form.clone
          out.pages.last << answer_page.tap(&:rotate_right)
        end

        # out.to_pdf
        out.save(File.join(App.root, "out/osha_form_300.pdf"))
      end
  end
end
