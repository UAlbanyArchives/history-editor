# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Subject.create(name: "Academic Programs")
Subject.create(name: "Academic Colleges, Schools & Departments")
Subject.create(name: "Administration")
Subject.create(name: "Alumni")
Subject.create(name: "Centers & Institutes")
Subject.create(name: "General")
Subject.create(name: "Gifts")
Subject.create(name: "Grants")
Subject.create(name: "Service Units")
Subject.create(name: "Student Life")
Subject.create(name: "Students")

require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'chrono.csv'))
csv = CSV.parse(csv_text, :headers => false, :encoding => 'UTF-8')

csv.each do |row|
	e = Event.new
	if row[0].length == 4
		e.date = Date.parse row[0] + "-01-01"
		if row[1].nil?
			e.display_date = row[0]
		else
			e.display_date = row[0] + " " + row[1]
		end
	else
		e.date = Date.parse "1858-01-01"
		e.display_date = row[0]
	end
	unless row[2].nil?
		subj = Subject.find(row[2])
		e.subjects << subj
	end
	e.description = row[3]
	e.save
	puts "Saved #{e.display_date}"
end