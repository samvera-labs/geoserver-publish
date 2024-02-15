# frozen_string_literal: true
module Geoserver
  module Publish
    def config
      @config ||= config_yaml
    end

    private

    # :nocov:
    def config_yaml
      file_path = File.join(Geoserver::Publish.root, "config", "config.yml")
      yaml_text = ERB.new(File.read(file_path)).result
      if Gem::Version.new(Psych::VERSION) >= Gem::Version.new("3.1.0.pre1")
        YAML.safe_load(yaml_text, aliases: true)
      else
        YAML.safe_load(yaml_text, [], [], true)
      end
    end
    # :nocov:

    module_function :config, :config_yaml
  end
end
