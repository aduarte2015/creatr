# Creatr AI - Intelligent Presentation Generator

Creatr AI is a modern, full-stack application that generates professional HTML presentations using Anthropic's Claude AI. Features a clean, two-stage interface: start with a simple prompt, then switch to split-screen view with chat history and live preview.

## ✨ Features

### 🎯 **Intuitive Two-Stage UI**
- **Initial Screen**: Clean, centered prompt interface
- **Split View**: Chat history (left) + presentation preview (right)
- **Real-time Progress**: Live generation logs with status updates
- **Instant Preview**: View presentations in embedded iframe

### 🤖 **AI-Powered Generation**
- **Claude 4 Integration**: Uses latest Claude Sonnet for intelligent content creation
- **Professional Quality**: 4-5 slide presentations with modern design
- **Auto-Download**: Presentations download automatically upon completion
- **Smart Prompts**: Suggested topics for quick generation

### 🎨 **Modern Design System**
- **Clean Interface**: Minimal, focused design with perfect center alignment
- **Responsive Layout**: Works seamlessly on desktop, tablet, and mobile
- **Smooth Transitions**: Animated UI state changes and loading indicators
- **Professional Styling**: Modern gradients, shadows, and typography

### 💾 **Standalone Output**
- **Complete HTML**: Self-contained presentations with embedded CSS/JS
- **Offline Ready**: Generated files work without internet connection
- **Easy Sharing**: One-click download for instant distribution
- **No Dependencies**: Presentations run in any modern browser

## 🏗️ Architecture

- **Frontend**: React + Vite (port 5173) - Fast, modern development experience
- **Backend**: Ruby on Rails API (port 3001) - Robust API with Claude integration
- **AI Provider**: Anthropic Claude 4 (claude-sonnet-4-20250514)
- **Design**: CSS Variables + Modern gradients
- **Chat System**: Persistent conversation history with message bubbles

## 🚀 Quick Start

### Prerequisites

- **Ruby** 3.3.5+
- **Rails** 7.1+
- **Node.js** 20.17+ (Vite compatible)
- **npm** or yarn
- **Anthropic API Key** ([Get yours here](https://console.anthropic.com))

### 1. Clone Repository

```bash
git clone <repository-url>
cd Creatr
```

### 2. Environment Setup

Copy the environment template and add your API key:

```bash
cp .env.example creatr-backend/.env
```

Edit `creatr-backend/.env`:
```env
ANTHROPIC_API_KEY=your_anthropic_api_key_here
```

### 3. Backend Setup (Rails API)

```bash
cd creatr-backend
bundle install
bundle exec rails server -p 3001
```

✅ Rails API running at `http://localhost:3001`

### 4. Frontend Setup (Vite + React)

Open a new terminal:

```bash
cd creatr-frontend-vite
npm install
npm run dev
```

✅ Frontend running at `http://localhost:5173`

## 🎮 Usage

### **Stage 1: Initial Prompt**
1. Navigate to `http://localhost:5173`
2. Enter your presentation topic in the centered prompt box
3. Choose from suggested prompts or write your own
4. Click "Generate Presentation" or press Ctrl+Enter

### **Stage 2: Split-Screen View**
1. **Left Panel**: Chat interface showing conversation history
2. **Right Panel**: Real-time generation progress, then live preview
3. **Download**: Automatic download + manual download buttons
4. **Continue**: Generate additional presentations in the same session

### Example Prompts
- "Digital transformation strategies for small businesses"
- "The future of renewable energy technology"
- "Effective remote team management practices"
- "AI ethics and responsible development"

## 🛠️ API Reference

### POST `/generate`

Generate a presentation from a topic prompt.

**Request:**
```json
{
  "prompt": "Your presentation topic here"
}
```

**Response:**
```json
{
  "html": "<complete standalone HTML presentation>"
}
```

**Features:**
- 3000 token limit for comprehensive presentations
- Temperature 0.7 for balanced creativity and accuracy
- Built-in error handling and timeout management
- Progress logging for user feedback

## 🎨 Design System

### Color Palette
```css
--primary-pink: #EC4899      /* Brand accent */
--primary-blue: #00A3FF      /* Primary actions */
--bg-primary: #FFFFFF        /* Clean backgrounds */
--bg-secondary: #F9FAFB      /* Subtle contrasts */
--text-primary: #111827      /* Dark, readable text */
--text-secondary: #4B5563    /* Muted text */
```

### Layout Principles
- **Center-first design**: Perfect alignment for initial screen
- **Space efficiency**: Full viewport usage in split view
- **Progressive disclosure**: Simple → complex as needed
- **Responsive breakpoints**: Mobile-first approach

### Component System
- **Message bubbles**: AI vs user differentiation
- **Progress indicators**: Real-time feedback
- **Action buttons**: Consistent interaction patterns
- **Input fields**: Focused, accessible design

## 📱 Responsive Design

### Desktop (1024px+)
- Split view: 420px chat panel + remaining space for preview
- Full-height layout with proper scroll handling

### Tablet (768px - 1024px)
- Vertical stack: 45vh chat + 55vh preview
- Optimized touch interactions

### Mobile (< 768px)
- Vertical stack: 40vh chat + 60vh preview
- Compact navigation and controls

## 🔧 Customization

### Modifying Prompts

Edit the system message in `creatr-backend/app/controllers/slides_controller.rb`:

```ruby
system_message = <<~SYSTEM
  Create a standalone HTML presentation with inline CSS and JavaScript.

  Requirements:
  - Complete HTML document with embedded styles and scripts
  - 4-5 slides with navigation (arrow keys, buttons)
  - Modern design with gradients and animations
  - Responsive layout
  - No external dependencies

  Return only raw HTML code without markdown formatting.
SYSTEM
```

### Styling Updates

Main styles are in `creatr-frontend-vite/src/App.css` with CSS variables for easy theming.

### Adding Features

1. **New API endpoints**: Add routes in `creatr-backend/config/routes.rb`
2. **UI components**: Extend React components in `src/`
3. **Styling**: Update CSS variables for consistent theming

## 🐛 Troubleshooting

### Common Issues

**CORS Errors:**
- Ensure both servers are running on correct ports
- Check CORS configuration in `creatr-backend/config/initializers/cors.rb`

**Generation Failures:**
- Verify Anthropic API key is valid and has quota
- Check Rails logs: `tail -f creatr-backend/log/development.log`
- Ensure network connectivity

**UI Layout Issues:**
- Clear browser cache and hard refresh
- Check browser console for JavaScript errors
- Verify both servers are responding

### Server Status Check

```bash
# Test backend
curl http://localhost:3001/up

# Test frontend
curl http://localhost:5173
```

## 🚢 Production Deployment

### Backend
- Set `RAILS_ENV=production`
- Configure production database
- Use production-grade server (Puma)
- Set up proper logging and monitoring

### Frontend
```bash
npm run build
# Serve dist/ folder with Nginx or Apache
```

### Environment Variables
- Store API keys securely (never in code)
- Use environment-specific configurations
- Set up proper secrets management

## 🧪 Development

### Running Tests
```bash
# Backend tests
cd creatr-backend
rails test

# Frontend tests
cd creatr-frontend-vite
npm test
```

### Development Workflow
1. Start both servers in development mode
2. Frontend auto-reloads on file changes
3. Backend requires restart for major changes
4. Check logs in both terminals for debugging

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For issues and questions:

1. **Check logs**: Rails logs for backend issues, browser console for frontend
2. **Verify setup**: Ensure all dependencies are installed correctly
3. **API quota**: Check your Anthropic API usage and limits
4. **Network**: Verify both servers are accessible and responding

---

**🚀 Built with React, Rails, and Claude AI | ✨ Powered by modern web technologies**# creatr
