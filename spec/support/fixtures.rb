# frozen_string_literal: true
class Fixtures
  def self.file_fixture(fixture_name)
    file_fixture_path = ROOT_PATH.join("spec", "fixtures", "files")
    path = Pathname.new(File.join(file_fixture_path, fixture_name))

    if path.exist?
      path
    else
      msg = "the directory '%s' does not contain a file named '%s'"
      raise ArgumentError, format(msg, file_fixture_path, fixture_name)
    end
  end
end
