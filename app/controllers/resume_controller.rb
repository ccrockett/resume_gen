class ResumeController < ApplicationController
	TEMPLFILE = Rails.root.join("app","views","resume","resume.erb.rb")
	OUTFILE = Rails.public_path.join("resume.html")

	def index
		@title = "- R&eacute;sum&eacute;"
# setup template data
		if !File.exists?(OUTFILE) || File.mtime(Resume.json_file_location) > File.mtime(OUTFILE) || 
				File.mtime(TEMPLFILE) > File.mtime(OUTFILE)
			resume = Resume.new(JsonParser.new(Resume.json_file_location))
			File.open(OUTFILE, "w") do |file|
				file.write(resume.build(ERB.new(File.read(TEMPLFILE), nil, '-')))
			end
		end
		render file: OUTFILE, layout: true
	end
end
