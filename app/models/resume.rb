class Resume
  def self.json_file_location
    return Rails.root.join("resume.json")
  end
  
	attr_accessor :data

  def initialize(parser)
    @data = parser.parse
  end

  def build(template)
    templ = template
    templ.result binding
  end
end
