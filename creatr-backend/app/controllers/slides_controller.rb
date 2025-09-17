class SlidesController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  require 'zip'
  require 'fileutils'

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

  def download
    begin
      html_content = params[:html]
      
      if html_content.blank?
        render json: { error: 'HTML content is required' }, status: :bad_request
        return
      end

      # Create zip file with all dependencies
      zip_data = create_presentation_zip(html_content)
      
      send_data zip_data, 
                filename: "presentation_#{Time.current.strftime('%Y%m%d_%H%M%S')}.zip",
                type: 'application/zip'
    rescue => e
      Rails.logger.error "Error creating presentation zip: #{e.message}"
      render json: { error: 'Failed to create presentation package' }, status: :internal_server_error
    end
  end

  private

  def generate_presentation(prompt)
    uri = URI('https://api.anthropic.com/v1/messages')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request['x-api-key'] = ENV['ANTHROPIC_API_KEY']
    request['anthropic-version'] = '2023-06-01'

    # System message with design requirements and asset information
    system_message = <<~SYSTEM
      You are a professional presentation designer creating interactive HTML presentations using a specific design system.

      CRITICAL: Return ONLY raw HTML code without any markdown formatting, code blocks, or backticks. Do not wrap the HTML in ```html``` or any other markdown syntax.

      DESIGN SYSTEM COLORS (use these CSS variables):
      - Primary: #2563eb (--primary-color)
      - Accent: #3b82f6 (--accent-color) 
      - Success: #10b981 (--success-color)
      - Warning: #f59e0b (--warning-color)
      - Text Primary: #1f2937 (--text-primary)
      - Text Secondary: #6b7280 (--text-secondary)
      - Background: #ffffff (--bg-primary)
      - Card Background: #ffffff (--bg-card)

      AVAILABLE ASSETS:
      - Company logos: assets/logos/barclays-cyan.png, assets/logos/barclays-white.png
      - Stock images available in assets/images/:
        * aerps-com-dg6brj2PnOg-unsplash.jpg (office/workspace)
        * brooke-cagle-g1Kr4Ozfoac-unsplash.jpg (team meeting)
        * business-growth-2.jpg (business growth chart)
        * business-professional-1.jpg (professional portrait)
        * charles-etoroma-95UF6LXe-Lo-unsplash.jpg (technology/data)
        * christina-wocintechchat-com-glRqyWJgUeY-unsplash.jpg (tech meeting)
        * christin-hume-Hcfwew744z4-unsplash.jpg (laptop work)
        * data-analytics-2.jpg (data visualization)
        * eduardo-soares-7I5A7630GpY-unsplash.jpg (coding/development)
        * growtika-nGoCBxiaRO0-unsplash.jpg (business meeting)
        * jacek-dylag-PMxT0XtQ--A-unsplash.jpg (office space)
        * jan-antonin-kolar-vLxXvapupqI-unsplash.jpg (data analysis)
        * jonathan-kemper-hpz88a0NUS8-unsplash.jpg (creative work)
        * matthew-lejune-vQq-NTV-f4k-unsplash.jpg (presentation)
        * maxim-hopman-IayKLkmz6g0-unsplash.jpg (stock market/finance)
        * nasa-Q1p7bh3SHj8-unsplash.jpg (technology/innovation)
        * ryoji-iwata-n31JPLu8_Pw-unsplash.jpg (architecture/structure)
        * team-meeting-5.jpg (team collaboration)
        * thisisengineering-w_zE6qlkQKA-unsplash.jpg (engineering/tech)
        * thisisengineering-ZPeXrWxOjRQ-unsplash.jpg (STEM/innovation)
        * toa-heftiba-O3ymvT7Wf9U-unsplash.jpg (workspace/productivity)

      REQUIREMENTS:
      1. Create 6-8 slides with varied layouts (title slides, bullet points, two-columns, quotes)
      2. Use LOCAL Reveal.js files: 
         - CSS: <link rel="stylesheet" href="reveal.js/dist/reveal.css">
         - Theme: <link rel="stylesheet" href="reveal.js/theme/white.css">
         - JavaScript: <script src="reveal.js/dist/reveal.js"></script>
      3. Include Inter font from Google Fonts
      4. IMPORTANT: Link to external stylesheet: <link rel="stylesheet" href="components.css">
      5. DO NOT include any inline CSS - use only external components.css file
      6. Use specific CSS classes from components.css for slide styling:
         - Title slides: .slide-title h1, .slide-subtitle, .slide-author
         - Content slides: .slide-content h2, .slide-list, .slide-list li
         - Images: .slide-image, .slide-image img
         - Quotes: .slide-quote blockquote, .slide-quote cite
         - Charts: .slide-chart-container
         - Buttons: .btn, .btn-primary, .btn-secondary
         - Cards: .card, .card-elevated
         - Text: .text-large, .text-regular, .text-small, .text-muted
         - Animations: .fade-in, .fade-in-up, .slide-in-up, .scale-in
      7. Reference assets using relative paths like "assets/images/filename.jpg"
      8. CRITICAL: Structure slides using Reveal.js format with <div class="reveal"><div class="slides"> wrapper
      9. Each slide must be wrapped in <section> tags: <section>slide content</section>
      10. IMPORTANT: Configure for full-screen slides with proper sizing:
         - Add viewport meta tag: <meta name="viewport" content="width=device-width, initial-scale=1.0">
         - Initialize with: Reveal.initialize({hash: true, controls: true, progress: true, center: true, transition: 'slide', width: 1280, height: 720});
      11. Ensure each slide uses full viewport height and is properly centered
      12. Use components.css classes for all presentation formatting - NO inline styles
      13. Ensure the HTML is complete with proper closing tags and </html> at the end
      14. Generate ALL slides completely - do not truncate or abbreviate
      15. Reference all files locally for offline functionality

      CRITICAL REVEAL.JS STRUCTURE:
      ```
      <div class="reveal">
        <div class="slides">
          <section>First slide</section>
          <section>Second slide</section>
          <section>Third slide</section>
        </div>
      </div>
      ```

      The HTML should reference local files and work as part of a bundled package.
      Use modern, clean design with appropriate spacing, shadows, and typography from components.css.
      
      IMPORTANT: Output raw HTML only - no markdown code blocks or formatting.
    SYSTEM

    # Prepare the request body
    request_body = {
      model: 'claude-sonnet-4-20250514',
      max_tokens: 8000,
      temperature: 0.9,
      system: system_message,
      messages: [
        {
          role: 'user',
          content: "Create a complete HTML presentation about: #{prompt}. Make it professional, engaging, and use the design system styling. Include company branding where appropriate. CRITICAL: Structure as proper Reveal.js slides with <div class=\"reveal\"><div class=\"slides\"> wrapper and each slide in <section> tags. Configure for full-screen presentation with proper viewport settings and 1280x720 dimensions. Use ONLY external CSS files (components.css, reveal.js files) - NO inline CSS or <style> tags. Use these specific CSS classes from components.css: .slide-title h1, .slide-subtitle, .slide-author for title slides; .slide-content h2, .slide-list for content; .slide-image for images; .slide-quote for quotes; .btn, .btn-primary for buttons; .card for card layouts; .text-large, .text-regular for text sizing. Include navigation controls and proper initialization. IMPORTANT: Return only raw HTML code - no markdown formatting or code blocks. The HTML should start with <!DOCTYPE html> and end with </html>. Reference external CSS files (components.css, reveal.js files) and include the complete Reveal.js JavaScript initialization script before the closing </body> tag."
        }
      ]
    }

    request.body = request_body.to_json

    response = http.request(request)
    
    if response.code == '200'
      result = JSON.parse(response.body)
      html_content = result['content'][0]['text']
      
      # Clean up any potential markdown formatting artifacts
      html_content = html_content.gsub(/^```html\n?/, '').gsub(/\n?```$/, '')
      html_content = html_content.strip
      
      return html_content
    else
      Rails.logger.error "Anthropic API error: #{response.code} - #{response.body}"
      raise "API request failed with status #{response.code}"
    end
  end

  def create_presentation_zip(html_content)
    zip_buffer = Zip::OutputStream.write_buffer do |stream|
      # Add the main presentation HTML file
      stream.put_next_entry('presentation.html')
      stream.write(html_content)
      
      # Add components.css
      if File.exist?(Rails.root.join('public', 'components.css'))
        stream.put_next_entry('components.css')
        stream.write(File.read(Rails.root.join('public', 'components.css')))
      end
      
      # Add components.js
      if File.exist?(Rails.root.join('public', 'components.js'))
        stream.put_next_entry('components.js')
        stream.write(File.read(Rails.root.join('public', 'components.js')))
      end
      
      # Add Reveal.js files
      reveal_files = [
        ['reveal.js/dist/reveal.css', Rails.root.join('public', 'reveal.js', 'dist', 'reveal.css')],
        ['reveal.js/theme/white.css', Rails.root.join('public', 'reveal.js', 'theme', 'white.css')],
        ['reveal.js/dist/reveal.js', Rails.root.join('public', 'reveal.js', 'dist', 'reveal.js')]
      ]
      
      reveal_files.each do |zip_path, file_path|
        if File.exist?(file_path)
          stream.put_next_entry(zip_path)
          stream.write(File.read(file_path))
        end
      end
      
      # Add assets (logos and images)
      assets_path = Rails.root.join('public', 'assets')
      if Dir.exist?(assets_path)
        Dir.glob("#{assets_path}/**/*").each do |file_path|
          next if File.directory?(file_path)
          
          relative_path = Pathname.new(file_path).relative_path_from(Rails.root.join('public')).to_s
          stream.put_next_entry(relative_path)
          stream.write(File.read(file_path))
        end
      end
    end
    
    zip_buffer.string
  end
end