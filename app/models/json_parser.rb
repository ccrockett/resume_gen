class JsonParser < Parser
	attr_accessor :data

	def parse
		JSON.parse(File.read(@filename))
	end
end
