class ResumePdfRender
    include FileRenderer
    include Prawn
    OUTFILE = Rails.public_path.join('cameron-crockett-resume.pdf')
    SPACE_BETWEEN_RESUME_SECTIONS = 20
    SPACE_BETWEEN_SKILLS = 15

    BULLET_POINT_INDENTION = 30
    
    SKILLS_COLUMNS = 2
    EXP_TITLE = 'Professional Experience:'
    EDU_TITLE = 'Education:'
    FONT_SIZE = 12

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
        arial_font = setup_font()
        Prawn::Document.generate(path, :margin => 15) do |pdf|
            pdf.stroke_color 'cccccc'
            pdf.font_families.update('Arial' => arial_font)
            
            pdf.font 'Arial'
            
            print_heading(h_resume, pdf)

        # Summary
            pdf.move_down SPACE_BETWEEN_RESUME_SECTIONS
            pdf.formatted_text [ 
                { :text => h_resume['summary']['title'], :styles => [:bold]}
            ]
            pdf.stroke_horizontal_line(0, 585)
            pdf.move_down 10
            pdf.formatted_text [ 
                { :text => " #{h_resume['summary']['content']}", :size => FONT_SIZE-2 }
            ]
            pdf.move_down SPACE_BETWEEN_RESUME_SECTIONS
        # Skills Section
            pdf.formatted_text [{ :text => h_resume['skills']['title'], :styles => [:bold]}]
            pdf.stroke_horizontal_line(0, 585)
            pdf.move_down 10
            (0...h_resume['skills']['content'].length).step(SKILLS_COLUMNS).each do |index|
                pdf.text_box "#{h_resume['skills']['content'][index].join(' / ')}", :at => [10, pdf.cursor], :inline_format => true, :size => FONT_SIZE-2
                unless h_resume['skills']['content'][index+1].nil?
                    pdf.text_box "#{h_resume['skills']['content'][index+1].join(' / ')}", :at => [300*1, pdf.cursor], 
                        :inline_format => true, :size => FONT_SIZE-2
                end
                pdf.move_down SPACE_BETWEEN_SKILLS
            end
            pdf.move_down SPACE_BETWEEN_RESUME_SECTIONS

        # Professional Experience
            pdf.text EXP_TITLE, :style => :bold
            pdf.stroke_horizontal_line(0, 585)
            pdf.move_down 10
            prev_y = pdf.y
            h_resume['experience'].each do |entry|
                print_experience(entry, h_resume, pdf, prev_y)
            end
            pdf.move_down SPACE_BETWEEN_RESUME_SECTIONS
        
        # Education
            unless h_resume['education'].nil?
                pdf.text EDU_TITLE, :style => :bold
                
                pdf.stroke_horizontal_line(0, 585)
                pdf.move_down 10
                h_resume['education'].each do |edu|
                    pdf.indent BULLET_POINT_INDENTION do
                        pdf.formatted_text [{ :text => "#{edu['name']}", :styles => [:italic]} , {:text => " - #{edu['grad_date']}" }]
                        pdf.text "#{edu['degree']}"
                    end
                end
            end
            pdf.text ""
            pdf.text ""
        end
    end

    def print_heading(h_resume, o_pdf)
        ['name'].each do |entry|
            o_pdf.text "#{h_resume[entry]['desc']} #{h_resume[entry]['value']}", :align => :center, :style => :bold, :size => FONT_SIZE + 4, :leading => 5
        end
        ['address1', 'phone', 'email','website', 'gitlab', 'github'].each do |entry|
            unless h_resume[entry].nil?
                if h_resume[entry]['link'].nil?
                    o_pdf.text "#{h_resume[entry]['desc']} #{h_resume[entry]['value']}", :align => :center, :size => FONT_SIZE-2
                else
                    link = (entry == 'email') ? "mailto:#{h_resume[entry]['value']}" : h_resume[entry]['link']
                    o_pdf.text "#{h_resume[entry]['desc']} <link href='#{link}'>#{h_resume[entry]['value']}</link>", :inline_format => true, :align => :center, :size => FONT_SIZE-2
                end
            end
        end
    end

    def print_experience(entry, h_resume, o_pdf, prev_y)
        pdf_settings = entry['pdf_settings'] || []
        o_pdf.move_down 10
        o_pdf.text_box "<i>#{entry['dates']}</i>", :at => [10, o_pdf.cursor], :inline_format => true, :size => FONT_SIZE
        o_pdf.text_box "<i>#{entry['title']}</i>", :at => [125, o_pdf.cursor], :inline_format => true, :size => FONT_SIZE
        o_pdf.text_box "<i>#{entry['company']}, #{entry['location']} #{entry['extra']}</i>", :at => [275, o_pdf.cursor], 
            :inline_format => true, :leading => 2, :align => :right, :size => FONT_SIZE
        # o_pdf.move_down 15
        # o_pdf.stroke_horizontal_line(10, 585)
        
        # o_pdf.stroke_horizontal_line(10, 585)
        o_pdf.move_down 18
        
        unless pdf_settings.include? 'condense'
            unless entry['responsibilities'].nil?
                entry['responsibilities'].each do |response|
                    # determine if the text will flow over to a new page
                    # if so then manually create a new page so the bullet point 
                    # is on the same page
                    txt_height = o_pdf.height_of "#{response}", :leading => 2
                    if (txt_height > o_pdf.cursor)
                        o_pdf.start_new_page
                    end
                    # write a bullet point before the responsibility
                    
                    o_pdf.text_box "\u2022", :size => FONT_SIZE, :at => [(BULLET_POINT_INDENTION - 10), o_pdf.cursor]
                    o_pdf.indent BULLET_POINT_INDENTION do
                        o_pdf.text "#{response}", :size => FONT_SIZE-2, :leading => 3
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

    def setup_font
        if File.exists?'/usr/share/fonts/truetype/msttcorefonts/Arial.ttf'
            return {
                :normal => '/usr/share/fonts/truetype/msttcorefonts/Arial.ttf',
                :italic => '/usr/share/fonts/truetype/msttcorefonts/Arial_Italic.ttf',
                :bold => '/usr/share/fonts/truetype/msttcorefonts/Arial_Bold.ttf',
                :bold_italic => '/usr/share/fonts/truetype/msttcorefonts/Arial_Bold_Italic.ttf'
            }
        else
            return {
                :normal => '/Library/Fonts/Arial.ttf',
                :italic => '/Library/Fonts/Arial Italic.ttf',
                :bold => '/Library/Fonts/Arial Bold.ttf',
                :bold_italic => '/Library/Fonts/Arial Bold Italic.ttf'
            }
        end
    end
end