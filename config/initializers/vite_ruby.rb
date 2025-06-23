# frozen_string_literal: true

# Force ViteRuby to always reload manifest in production
Rails.application.config.after_initialize do
  if Rails.env.production?
    # Monkey patch ViteRuby::Manifest to disable caching
    ViteRuby::Manifest.class_eval do
      def lookup_entrypoint!(name, type: nil)
        # Force reload manifest every time
        @manifest_cache = nil
        load_manifest!
        find_manifest_entry!(with_file_extension(name, type))
      end
      
      private
      
      def load_manifest!
        @manifest_cache = JSON.parse(File.read(manifest_path))
      rescue JSON::ParserError => e
        raise ViteRuby::Manifest::MissingManifestError.new("#{manifest_path} is not a valid JSON file: #{e.message}")
      rescue StandardError => e
        raise ViteRuby::Manifest::MissingManifestError.new("Could not load manifest from #{manifest_path}: #{e.message}")
      end
    end
  end
end