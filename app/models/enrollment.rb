class Enrollment < ApplicationRecord
    validates :username, presence: true
    validates :year, presence: true
    validates :semester, presence: true
    validates :course, presence: true
    validates :status, presence: true
  end