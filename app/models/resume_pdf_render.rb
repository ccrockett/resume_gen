class ResumePdfRender
    include FileRenderer
    include Prawn
    OUTFILE = Rails.public_path.join("cameron-crockett-resume.pdf")
    SPACE_BETWEEN_RESUME_SECTIONS = 20
    BULLET_POINT_INDENTION = 20

    def create(o_resume)
        if (!File.exists?(OUTFILE) || File.mtime(Resume.json_file_location) > File.mtime(OUTFILE) || File.mtime(__FILE__) > File.mtime(OUTFILE))
            create_pdf(o_resume)
        end
        return OUTFILE
    end

    def create_pdf(o_resume)
        path = OUTFILE
        h_resume = o_resume.data
        # .each {|var| hash[var.to_s.delete("@")] = o_resume.instance_variable_get(var) }
        # p hash
        # Another way of doing it
        Prawn::Document.generate(path, :margin => 15) do |pdf|
            pdf.font_families.update("Arial" => {
                :normal => "/Library/Fonts/Arial.ttf",
                :italic => "/Library/Fonts/Arial Italic.ttf",
                :bold => "/Library/Fonts/Arial Bold.ttf",
                :bold_italic => "/Library/Fonts/Arial Bold Italic.ttf"
            })

            pdf.font "Arial"
            
            print_heading(h_resume, pdf)
            pdf.move_down SPACE_BETWEEN_RESUME_SECTIONS
            pdf.formatted_text [ 
                { :text => h_resume['summary']['title'], :styles => [:bold]}, 
                { :text => " #{h_resume['summary']['content']}" }
            ]
            pdf.move_down 10
            pdf.formatted_text [ 
                { :text => h_resume['skills']['title'], :styles => [:bold]}, 
                { :text => " #{h_resume['skills']['content']}" }
            ]
            pdf.move_down SPACE_BETWEEN_RESUME_SECTIONS
            pdf.text "Professional Experience", :style => :bold
            pdf.move_down 10
            prev_y = pdf.y
            h_resume['experience'].each do |entry|
                print_experience(entry, h_resume, pdf, prev_y)
            end
            pdf.move_down SPACE_BETWEEN_RESUME_SECTIONS
            unless h_resume['education'].nil?
                pdf.text "Education", :style => :bold
                h_resume['education'].each do |edu|
                    pdf.indent BULLET_POINT_INDENTION do
                        pdf.formatted_text [{ :text => "#{edu['name']}", :styles => [:italic]} , {:text => " - #{edu['grad_date']}" }]
                        pdf.text "#{edu['degree']}"
                    end
                end
            end
            pdf.move_down SPACE_BETWEEN_RESUME_SECTIONS
            pdf.text "References", :style => :bold
            pdf.indent BULLET_POINT_INDENTION do
                pdf.formatted_text [{ :text => "References provided upon request", :styles => [:italic]} ]
            end
            pdf.text ""
            pdf.text ""
        end
    end

    def print_heading(h_resume, o_pdf)
        ['name'].each do |entry|
            o_pdf.text "#{h_resume[entry]['desc']} #{h_resume[entry]['value']}", :align => :center, :style => :bold, :size => 18, :leading => 5
        end
        ['address1', 'phone', 'email','website'].each do |entry|
            unless h_resume[entry].nil?
                if h_resume[entry]['link'].nil?
                    o_pdf.text "#{h_resume[entry]['desc']} #{h_resume[entry]['value']}", :align => :center
                else
                    o_pdf.text "#{h_resume[entry]['desc']} <link href='#{h_resume[entry]['link']}'>#{h_resume[entry]['value']}</link>", :inline_format => true, :align => :center
                end
            end
        end
    end

    def print_experience(entry, h_resume, o_pdf, prev_y)
        pdf_settings = entry["pdf_settings"] || []
        o_pdf.move_down 10
        o_pdf.text_box "<b>#{entry['dates']}</b>", :at => [0, o_pdf.cursor], :inline_format => true
        o_pdf.text_box "<b><i>#{entry['title']}</i></b>", :at => [90, o_pdf.cursor], :inline_format => true
        o_pdf.text_box "<b>#{entry['company']}, #{entry['location']} #{entry['extra']}</b>", :at => [275, o_pdf.cursor], :inline_format => true, :leading => 2, :align => :right
        o_pdf.move_down 15
        o_pdf.stroke_horizontal_rule
        o_pdf.move_down 5
        
        unless pdf_settings.include? "condense"
            unless entry['responsibilities'].nil?
                entry['responsibilities'].each do |response|
                    # determine if the text will flow over to a new page
                    # if so then manually create a new page so the bullet point 
                    # is on the same page
                    txt_height = o_pdf.height_of "#{response}", :leading => 2
                    if (txt_height > o_pdf.cursor)
                        o_pdf.start_new_page
                    end
                    #write a bullet point before the responsibility
                    o_pdf.text_box "\u2022", :size => 16, :at => [10, o_pdf.cursor]
                    
                    o_pdf.indent BULLET_POINT_INDENTION do
                        o_pdf.text "#{response}", :leading => 2
                    end
                    
                end
            else
                o_pdf.text ""
            end
        else
            o_pdf.indent BULLET_POINT_INDENTION do
                o_pdf.text "<link href='#{h_resume['link_to_condensed']}'><i>Condensed for length. See website for responsibilities</i></link>", :inline_format => true, :size => 9
            end
        end
    end
end