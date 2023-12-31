class VectrTasks < Thor
  include Rails.application.config.dradis.thor_helper_module

  namespace "dradis:plugins:vectr"

  desc      "upload FILE", "upload Vectr results in CSV format"
  long_desc "This plugin expect a CSV file generated by Vectr using: -f "\
            "jason -o results.json"
  def upload(file_path)
    require 'config/environment'

    unless File.exists?(file_path)
      $stderr.puts "** the file [#{file_path}] does not exist"
      exit(-1)
    end

    detect_and_set_project_scope

    importer = Dradis::Plugins::Vectr::Importer.new(task_options)
    importer.import(file: file_path)
  end

end
