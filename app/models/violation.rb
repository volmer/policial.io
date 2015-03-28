class Violation < ActiveRecord::Base
  belongs_to :build

  validates :filename, presence: true
  validates :line_number, presence: true
  validates :message, presence: true
  validates :build_id, presence: true

  # Public: Initialize violations for each message from Policial..
  #
  # policial_violation - The Policial::Violation containing messages.
  #
  # Returns an Array of Violation objects, one for each message.
  def self.from_policial(policial_violation)
    policial_violation.messages.map do |message|
      new(
        filename: policial_violation.filename,
        line_number: policial_violation.line_number,
        message: message
      )
    end
  end
end
