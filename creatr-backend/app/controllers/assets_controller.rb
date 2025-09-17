class AssetsController < ApplicationController
  def show
    file_path = params[:path]
    
    # Construct the full path to the asset
    full_path = Rails.root.join('..', 'assets', file_path)
    
    # Check if file exists and is within the assets directory
    if File.exist?(full_path) && full_path.to_s.include?('/assets/')
      send_file full_path, disposition: 'inline'
    else
      head :not_found
    end
  rescue => e
    Rails.logger.error "Error serving asset #{file_path}: #{e.message}"
    head :not_found
  end
end