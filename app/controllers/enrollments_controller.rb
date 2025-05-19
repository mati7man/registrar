class EnrollmentsController < ApplicationController
    require 'prawn'
    require 'prawn/table'

    def test_pdf
        respond_to do |format|
          format.pdf do
            begin
              render pdf: "test",
                     inline: "<h1>Test PDF</h1><p>This is a test PDF generation.</p>",
                     disposition: 'attachment',
                     debug: true
            rescue => e
              Rails.logger.error "PDF Generation Error: #{e.message}"
              Rails.logger.error e.backtrace.join("\n")
              redirect_to enrollments_batch_path, alert: "PDF generation failed: #{e.message}"
            end
          end
        end
    end

    def single 
        @enrollments = Enrollment.where(username: params[:username])
                                .where(year: params[:year])
                                .where(semester: params[:semester])
    end

    def batch
        @enrollments = Enrollment.where(year: params[:year])
                                .where(semester: params[:semester])
    end

    def print_pdf
        @enrollments = if params[:username].present?
                            Enrollment.where(username: params[:username])
                            .where(year: params[:year])
                            .where(semester: params[:semester])
                        else
                            Enrollment.where(year: params[:year])
                                    .where(semester: params[:semester])
                        end

        respond_to do |format|
          format.pdf do
            pdf = Prawn::Document.new(page_size: 'A4', margin: [50, 50, 50, 50])
            pdf.text "Enrollment Report", size: 20, style: :bold, align: :center
            pdf.move_down 20

            if params[:username].present?
              pdf.text "Student: #{params[:username]}", size: 14
            end

            pdf.text "Year: #{params[:year]}, Semester: #{params[:semester]}", size: 14
            pdf.move_down 20

            # Create table data
            table_data = [['Username', 'Year', 'Semester', 'Course', 'Status']]
            @enrollments.each do |enrollment|
              table_data << [
                enrollment.username,
                enrollment.year.to_s,
                enrollment.semester,
                enrollment.course,
                enrollment.status
              ]
            end

            # Calculate available width
            available_width = pdf.bounds.width

            # Create table with proportional column widths
            pdf.table(table_data, header: true, width: available_width) do
              row(0).style(background_color: 'CCCCCC', font_style: :bold)
              
              # Set proportional widths
              columns([0]).width = available_width * 0.25  # Username
              columns([1]).width = available_width * 0.15  # Year
              columns([2]).width = available_width * 0.15  # Semester
              columns([3]).width = available_width * 0.30  # Course
              columns([4]).width = available_width * 0.15  # Status
            end

            send_data pdf.render,
                      filename: "enrollments_#{Time.now.to_i}.pdf",
                      type: 'application/pdf',
                      disposition: 'attachment'
          end
        end
    end
end
