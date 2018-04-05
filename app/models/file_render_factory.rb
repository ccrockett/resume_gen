class FileRenderFactory
    def self.create(file_type)
        case file_type
            when 'pdf'
                return ResumePdfRender.new 
            else
                throw "#{file_type} is not a supported output type"
            end
    end
end