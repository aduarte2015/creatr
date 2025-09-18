class SlidesController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  require 'httparty'

  def generate
    begin
      prompt = params[:prompt]
      
      if prompt.blank?
        render json: { error: 'Prompt is required' }, status: :bad_request
        return
      end

      # Call Anthropic Claude API
      html_content = generate_presentation(prompt)
      
      render json: { html: html_content }, status: :ok
    rescue => e
      Rails.logger.error "Error generating presentation: #{e.message}"
      render json: { error: 'Failed to generate presentation' }, status: :internal_server_error
    end
  end


  private

  def generate_presentation(prompt)
    # Check if API key is present
    api_key = ENV['ANTHROPIC_API_KEY']
    if api_key.blank?
      raise "ANTHROPIC_API_KEY environment variable not set"
    end

    uri = URI('https://api.anthropic.com/v1/messages')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    # Increase timeout settings for longer content generation
    http.read_timeout = 300  # 5 minutes
    http.open_timeout = 30   # 30 seconds to connect

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request['x-api-key'] = api_key
    request['anthropic-version'] = '2023-06-01'

    # Simplified system message for faster generation
    system_message = <<~SYSTEM
      Create a standalone HTML presentation with inline CSS and JavaScript. 
      
      Requirements:
      - Complete HTML document with embedded styles and scripts
      - 5-6 slides with navigation (arrow keys, buttons)
      - Modern design with gradients and animations
      - Responsive layout
      - No external dependencies
      
      Return only raw HTML code without markdown formatting.
    SYSTEM

    # Prepare the request body
    request_body = {
      model: 'claude-sonnet-4-20250514',
      max_tokens: 3000,
      temperature: 0.7,
      system: system_message,
      messages: [
        {
          role: 'user',
          content: "Create a standalone HTML presentation about: #{prompt}. Make it 4-5 slides with navigation, modern styling, and smooth transitions. Return only HTML code."
        }
      ]
    }

    request.body = request_body.to_json

    Rails.logger.info "Making request to Anthropic API..."
    Rails.logger.info "Request size: #{request.body.length} bytes"
    
    begin
      response = http.request(request)
      Rails.logger.info "Received response with status: #{response.code}"
      
      if response.code == '200'
        result = JSON.parse(response.body)
        html_content = result['content'][0]['text']
        
        # Clean up any potential markdown formatting artifacts
        html_content = html_content.gsub(/^```html\n?/, '').gsub(/\n?```$/, '')
        html_content = html_content.strip
        
        Rails.logger.info "Successfully generated HTML content (#{html_content.length} characters)"
        return html_content
      else
        Rails.logger.error "Anthropic API error: #{response.code} - #{response.body}"
        raise "API request failed with status #{response.code}: #{response.body}"
      end
    rescue Net::TimeoutError => e
      Rails.logger.error "Timeout error: #{e.message}"
      raise "API request timed out. The content generation is taking longer than expected."
    rescue => e
      Rails.logger.error "Unexpected error: #{e.class} - #{e.message}"
      raise e
    end
  end


end