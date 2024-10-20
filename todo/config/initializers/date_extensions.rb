# config/initializers/date_extensions.rb
class Date
    def all_day
      all_day = self.beginning_of_day..self.end_of_day
      all_day
    end
  end
  