class Resume
	attr_accessor :data

  def initialize(parser)
    @data = parser.parse
  end

  def build(template)
    templ = template
    templ.result binding
  end
end
