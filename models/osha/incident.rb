module Osha
  class Incident
    attr_accessor :case_number,
                  :classification,
                  :date_of_incident,
                  :days_away_from_work,
                  :days_on_transfer_or_restriction,
                  :description_of_injury_or_illness,
                  :employee_job_title,
                  :employee_name,
                  :injury_type_or_illness,
                  :where_the_event_occurred

    def initialize(attributes = {})
      attributes.each { |name, value| send("#{name}=", value) }
    end

    def classified_as_death?
      classification.to_s == "death"
    end

    def classified_as_days_away_from_work?
      classification.to_s == "days_away_from_work"
    end

    def classified_as_job_transfer_or_restriction?
      classification.to_s == "job_transfer_or_restriction"
    end

    def classified_as_other_recordable_case?
      classification.to_s == "other_recordable_case"
    end

    def resulted_in_injury?
      injury_type_or_illness.to_s == "injury"
    end

    def resulted_in_skin_disorder?
      injury_type_or_illness.to_s == "skin_disorder"
    end

    def resulted_in_respiratory_condition?
      injury_type_or_illness.to_s == "respiratory_condition"
    end

    def resulted_in_poisoning?
      injury_type_or_illness.to_s == "poisoning"
    end

    def resulted_in_hearing_loss?
      injury_type_or_illness.to_s == "hearing_loss"
    end

    def resulted_in_all_other_illness?
      injury_type_or_illness.to_s == "all_other_illness"
    end
  end
end
