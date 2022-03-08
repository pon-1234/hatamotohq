# frozen_string_literal: true

class MediaConverter::AudioConverter
  def initialize(media)
    @media = media
  end

  def perform
    return if !media.type_audio? || media.file.blob.content_type.in?(%w(audio/m4a audio/x-m4a audio/mp4))
    duration = media.file.blob.duration
    new_file_path = "tmp/audio-#{SecureRandom.alphanumeric(12)}.m4a"
    media.file.open(tmpdir: 'tmp') do |file|
      conversion_success = system "ffmpeg -i #{file.path} -vn -c:a libfdk_aac #{new_file_path} 2>&1", exception: true
      if conversion_success && File.exist?(new_file_path)
        new_file_name = "#{media.file_name.to_s.split('.').first}.m4a"
        media.file.attach(io: File.open(new_file_path), filename: new_file_name, content_type: 'audio/m4a')
        media.set_blob_duration duration || get_duration(file.path)
      end
      FileUtils.rm(new_file_path) if File.exist?(new_file_path)
    end
  rescue => exception
    FileUtils.rm(new_file_path) if File.exist?(new_file_path)
    puts exception.message
  end

  private
    attr_accessor :media

    def get_duration filepath
      pipe = 'ffmpeg -i ' + filepath.to_s + " 2>&1 | grep 'Duration' | cut -d ' ' -f 4 | sed s/,//"
      result = `#{pipe}`
      if result =~ /([\d][\d]):([\d][\d]):([\d][\d]).([\d]+)/
        duration = ($2.to_i * 60) + $3.to_i
      end
      return duration
    end
end
