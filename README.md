# Creatr - AI-Powered Presentation Generator

Creatr is a full-stack application that generates complete, standalone HTML presentations using Anthropic's Claude AI. Simply enter a topic prompt, and get a professional presentation with smooth transitions, company branding, and responsive design.

## Features

- **AI-Generated Presentations**: Uses Claude 3.5 Sonnet to create 6-8 slide presentations
- **Company Branding**: Automatically incorporates logos and brand assets
- **Professional Design**: Follows a consistent design system with modern styling
- **Interactive Presentations**: Uses Reveal.js for smooth slide transitions
- **Standalone HTML**: Generated presentations work offline with embedded CSS/JS
- **Asset Management**: Organized folder structure for logos and images
- **Live Preview**: Preview presentations in the browser before downloading
- **Download Ready**: One-click download of complete HTML files

## Architecture

- **Frontend**: React application (port 3000) with clean, responsive UI
- **Backend**: Ruby on Rails API (port 3001) with Claude API integration  
- **AI Provider**: Anthropic Claude 3.5 Sonnet
- **Presentation Engine**: Reveal.js via CDN
- **Design System**: Professional color palette with CSS variables

## Setup Instructions

### Prerequisites

- Ruby 3.3.5+
- Rails 7.1+
- Node.js 16+
- npm or yarn
- Anthropic API key

### 1. Clone and Navigate

```bash
git clone <repository-url>
cd creatr
```

### 2. Environment Configuration

1. Copy the environment template:
```bash
cp .env.example creatr-backend/.env
```

2. Add your Anthropic API key to `creatr-backend/.env`:
```
ANTHROPIC_API_KEY=your_anthropic_api_key_here
```

> **Get your API key**: Visit [Anthropic Console](https://console.anthropic.com) to obtain your API key.

### 3. Backend Setup (Rails API)

```bash
cd creatr-backend
bundle install
rails s -p 3001
```

The Rails API will be available at `http://localhost:3001`

### 4. Frontend Setup (React)

Open a new terminal:

```bash
cd creatr-frontend
npm install
npm start
```

The React app will be available at `http://localhost:3000`

## Asset Management

### Adding Company Logos

Place your company logos in the `assets/logos/` directory:

```
assets/
├── logos/
│   ├── company-logo.png
│   ├── company-logo-white.png
│   └── brand-mark.svg
└── images/
    ├── hero-image.jpg
    ├── team-photo.jpg
    └── office-space.jpg
```

### Adding Images

Add presentation images to `assets/images/`:
- Use high-quality images (1920x1080 recommended)
- Support for JPG, PNG, SVG formats
- Business, technology, and professional themes work best

### Current Assets

The project includes sample assets:
- **Logos**: Barclays cyan and white logos
- **Images**: 27+ professional stock images covering:
  - Business meetings and collaboration
  - Technology and innovation
  - Office environments
  - Data visualization themes

## Usage

1. **Start both servers** (Rails on 3001, React on 3000)
2. **Enter a topic** in the prompt field, such as:
   - "Digital transformation in healthcare"
   - "AI in education: opportunities and challenges"
   - "Sustainable business practices for 2024"
   - "Cybersecurity best practices for remote teams"
3. **Click Generate** - Claude will create a custom presentation
4. **Preview** the presentation in the embedded iframe
5. **Download** the complete HTML file for offline use

## API Endpoints

### POST /generate

Generates a presentation based on a topic prompt.

**Request:**
```json
{
  "prompt": "Your presentation topic here"
}
```

**Response:**
```json
{
  "html": "<complete HTML presentation>"
}
```

**Error Response:**
```json
{
  "error": "Error message"
}
```

## Design System

Creatr uses a professional design system with:

### Color Palette
- **Primary**: `#2563eb` (Blue)
- **Accent**: `#3b82f6` (Light Blue)  
- **Success**: `#10b981` (Green)
- **Warning**: `#f59e0b` (Orange)
- **Text**: `#1f2937` (Dark Gray)

### Typography
- **Font Family**: Inter (Google Fonts)
- **Weights**: 300, 400, 500, 600, 700

### Components
- Responsive grid system
- Card-based layouts
- Smooth transitions
- Professional shadows and spacing

## Customization

### Modifying the Design System

Edit the CSS variables in:
- `components.css` (main design system)
- `creatr-frontend/src/index.css` (frontend styling)

### Adjusting AI Prompts

Customize the presentation generation by editing the system message in:
`creatr-backend/app/controllers/slides_controller.rb`

### Adding Slide Layouts

The AI can create various slide types:
- Title slides with hero images
- Bullet point lists
- Two-column layouts
- Quote slides with large text
- Data visualization slides
- Call-to-action slides

## Troubleshooting

### Common Issues

**CORS Errors**:
- Ensure both servers are running
- Check that React proxy is configured in `package.json`

**API Key Issues**:
- Verify your Anthropic API key is valid
- Check the `.env` file is in the `creatr-backend` directory
- Ensure the `dotenv-rails` gem is installed

**Generation Failures**:
- Check your Anthropic API quota
- Verify network connectivity
- Review Rails logs for detailed error messages

**Asset Loading Issues**:
- Ensure assets are in the correct `assets/` folder structure
- Use relative paths in generated presentations
- Check file permissions and naming conventions

### Checking Logs

**Rails Backend:**
```bash
cd creatr-backend
tail -f log/development.log
```

**React Frontend:**
Check browser console for any JavaScript errors.

## Production Deployment

### Backend (Rails)
- Set `RAILS_ENV=production`
- Configure production database
- Set up proper CORS origins
- Use a production-grade server (Puma, Unicorn)

### Frontend (React)
- Run `npm run build`
- Serve static files with Nginx or Apache
- Update API URLs for production environment

### Environment Variables
- Store API keys securely (not in code)
- Use environment-specific configurations
- Set up proper secrets management

## Development

### Adding Features

1. **New Slide Types**: Modify the AI system message
2. **Custom Styling**: Update the design system CSS
3. **Asset Types**: Extend the asset folder structure
4. **API Endpoints**: Add new routes in Rails

### Testing

```bash
# Backend tests
cd creatr-backend
rails test

# Frontend tests  
cd creatr-frontend
npm test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Check the troubleshooting section
- Review the logs for error details
- Ensure your API key has sufficient quota
- Verify all dependencies are properly installed

---

**Built with ❤️ using React, Rails, and Claude AI**