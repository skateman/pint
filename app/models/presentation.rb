class Presentation < ActiveRecord::Base
  belongs_to :user
  has_many :sessions
  has_many :questions
  mount_uploader :pdf, PdfUploader

  before_save do |record|
    record.slides = PDF::Reader.new(record.pdf.path).page_count
  end

  def convert
    origin = self.pdf
    slides = origin.path.sub("presentation.pdf", "slide.jpg")
    system("convert #{origin.path} #{slides}")
  end
end
