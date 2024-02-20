class Course < ApplicationRecord
  has_and_belongs_to_many :students
  after_create :say_hello


  private

  def say_hello
    puts 'created'
  end
end
