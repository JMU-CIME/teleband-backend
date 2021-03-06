class Student < ApplicationRecord
    require 'securerandom'
    belongs_to :teacher
    has_many :student_assignments, :dependent => :delete_all
    has_many :assignments, through: :student_assignments

    def assignmentsList
        assignments = []
        self.student_assignments.each do |student_assignment|
            payload = {
                "title": student_assignment.assignment.title,
                "category": student_assignment.assignment.category,
                "id": student_assignment.assignment.id,
                "student_assignment": student_assignment
            }
            assignments.push(payload)
        end
        return assignments
    end

    def getRandomId
        return SecureRandom.uuid.split("").slice(0,8).join
    end

end
