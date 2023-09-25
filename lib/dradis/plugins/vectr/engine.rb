module Dradis::Plugins::Vectr
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Vectr

    include ::Dradis::Plugins::Base
    description 'Processes Vectr csv output, use: export vectr to Word, copy those tables to Excell and save it as a csv file'
    provides :upload
  end
end
