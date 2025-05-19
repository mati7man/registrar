Rails.application.routes.draw do
  root "enrollments#batch"
  get "enrollments/single", to: "enrollments#single"
  get "enrollments/batch", to: "enrollments#batch"
  get "enrollments/print_pdf", to: "enrollments#print_pdf", as: :print_pdf_enrollments
  get "enrollments/test_pdf", to: "enrollments#test_pdf"
end
