class ResumeController < ApplicationController
	JSONFILE = Rails.public_path.join("resume.json")
	TEMPLFILE = Rails.root.join("app","views","resume","resume.erb.rb")
	OUTFILE = Rails.public_path.join("resume.html")

	def index
		@title = "- Resume"
# setup template data
		if !File.exists?(OUTFILE) || File.mtime(JSONFILE) > File.mtime(OUTFILE) || 
				File.mtime(TEMPLFILE) > File.mtime(OUTFILE)
			resume = Resume.new(JsonParser.new(JSONFILE))
			File.open(OUTFILE, "w") do |file|
				file.write(resume.build(ERB.new(File.read(TEMPLFILE), nil, '-')))
			end
		end
		render file: OUTFILE, layout: true
	end
end
