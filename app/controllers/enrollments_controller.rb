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
            pdf = Prawn::Document.new(page_size: 'A4', margin: [30, 30, 30, 30])
            pdf.text "Enrollment Report", size: 20, style: :bold, align: :center
            pdf.move_down 20

            # Group enrollments by username
            enrollments_by_username = @enrollments.group_by(&:username)

            # Create a separate table for each username
            enrollments_by_username.each do |username, user_enrollments|
              # Add student header
              pdf.text "Student: #{username}", size: 14, style: :bold
              pdf.text "Year: #{params[:year]}, Semester: #{params[:semester]}", size: 12
              pdf.move_down 10

              # Create table data for this student
              table_data = [['Course', 'Status']]
              user_enrollments.each do |enrollment|
                table_data << [
                  enrollment.course,
                  enrollment.status
                ]
              end

              # Calculate available width
              available_width = pdf.bounds.width

              # Create table with adjusted column widths
              pdf.table(table_data, header: true, width: available_width) do |table|
                table.row(0).style(background_color: 'CCCCCC', font_style: :bold)
                
                # Set adjusted proportional widths
                table.columns([0]).width = available_width * 0.70  # Course
                table.columns([1]).width = available_width * 0.30  # Status

                # Add cell padding and text wrapping
                table.cells.padding = [5, 5, 5, 5]
                table.cells.size = 10
                table.cells.style do |cell|
                  cell.text_color = '000000'
                  cell.overflow = :shrink_to_fit
                  cell.min_font_size = 8
                end
              end

              # Add space between tables
              pdf.move_down 20
            end

            send_data pdf.render,
                      filename: "enrollments_#{Time.now.to_i}.pdf",
                      type: 'application/pdf',
                      disposition: 'attachment'
          end
        end
    end
end
