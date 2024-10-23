module Utils
    class DateService
        
        def self.today
            Date.current
        end

        def self.days_from_now(days)
            Date.current + days.days
        end

        def self.beginning_of_day(date)
            date.beginning_of_day
        end

        def self.end_of_day(date)
            date.end_of_day
        end

    end
end
  