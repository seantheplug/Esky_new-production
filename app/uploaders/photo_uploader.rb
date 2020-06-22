class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process eager: true    # forces version generation at upload time
  # process convert: jpg

end
