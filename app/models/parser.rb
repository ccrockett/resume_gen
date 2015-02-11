class Parser
	@filename = nil

	def initialize(filename)
		@filename = filename
	end

	def parse
		throw('Base parse function should be overridden')
	end
end
