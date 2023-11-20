require 'csv'
module Dradis::Plugins::Vectr
  class Importer < Dradis::Plugins::Upload::Importer

    def self.templates
      { issue: 'warning' }
    end

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      file_content = File.read( params[:file] )

      # Parse the uploaded file into a Ruby Hash
      logger.info { "Parsing Vectr output from #{ params[:file] }..." }
      logger.info { 'Done.' }

      logger.info { "Parsing Vectr CSV output from #{params[:file]}..." }

      CSV.parse(file_content, headers: true, col_sep: ';') do |row|
        # Extracting all fields from the CSV row
        ref = row['Ref #']
        phase = row['Phase']
        category = row['Category']
        attack_variation = row['Attack Variation']
        outcome = row['Outcome']
        outcome_details = row['Outcome Details']
        outcome_notes = row['Outcome Notes']
        detection_prevention_tools = row['Detection / Prevention Tools']
        tags = row['Tags']
      
        # Constructing the issue text using all the fields
        issue_text = <<~TEXT
          #[Title]#
          #{attack_variation}
          
          #[Ref #]#
          #{ref}
      
          #[Phase]#
          #{phase}
      
          #[Category]#
          #{category}
      
          #[Attack Variation]#
          #{attack_variation}
      
          #[Outcome]#
          #{outcome}
      
          #[Outcome Details]#
          #{outcome_details}
      
          #[Outcome Notes]#
          #{outcome_notes}
      
          #[Detection / Prevention Tools]#
          #{detection_prevention_tools}
      
          #[Tags]#
          #{tags}
        TEXT
      
        # Create an issue for each row in the CSV
        content_service.create_issue(text: issue_text, id: attack_variation.hash.to_i(8))
      end
      

      logger.info { 'Done.' }
      true
    end
  end
end
