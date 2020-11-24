class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def format_errors
    error_message = ""
    errors.each do |attribute, message|
      error_message += "#{attribute.capitalize.to_s.gsub("_id", "")} #{message}, "
    end
    return error_message.delete_suffix(", ")
  end
end
