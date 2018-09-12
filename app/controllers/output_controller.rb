require 'fileutils'
class OutputController < ApplicationController    
    def create(s_file_type = 'pdf')
        resume = Resume.new(JsonParser.new(Resume.json_file_location))
        file_render = FileRenderFactory.create(s_file_type)
        url_path = file_render.create(resume)
        # Rails.logger.info url_path
        redirect_to "/#{File.basename(url_path)}"
        # render status: 200, json: "path: #{url_path}"
    end
end
