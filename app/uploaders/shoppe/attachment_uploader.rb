# encoding: utf-8

class Shoppe::AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  # Where should files be stored?
  def store_dir
    "attachment/#{model.id}"
  end

  # Returns true if the file is an image
  def image?(_new_file)
    file.content_type.include? 'image'
  end

  # Returns true if the file is not an image
  def not_image?(_new_file)
    !file.content_type.include? 'image'
  end

  # Create different versions of your uploaded files:
  version :thumb, if: :image? do
    process resize_and_pad: [300, 300]
  end
  version :v_thumb, if: :image? do
    process resize_and_pad: [300, 450]
  end
  version :standard, if: :image? do
    process resize_and_pad: [900, 900]
  end
  version :v_standard, if: :image? do
    process resize_and_pad: [600, 900]
  end

  version :large, if: :image? do
    process resize_and_pad: [1800, 1800]
  end
  version :v_large, if: :image? do
    process resize_and_pad: [1200, 1800]
  end
end
