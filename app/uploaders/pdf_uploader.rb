# encoding: utf-8

class PdfUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  storage :file

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def extension_white_list
    %w(pdf)
  end

  def filename
    "presentation.pdf"
  end

end
