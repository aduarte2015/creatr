import React, { useState, useRef, useEffect } from 'react';
import './App.css';

function App() {
  const [prompt, setPrompt] = useState('');
  const [generatedHtml, setGeneratedHtml] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [showViewer, setShowViewer] = useState(false);
  const [activeNav, setActiveNav] = useState('generate');
  const [success, setSuccess] = useState('');
  const [isGenerated, setIsGenerated] = useState(false);
  const [chatHistory, setChatHistory] = useState([]);
  const [progressLogs, setProgressLogs] = useState([]);
  const [currentStep, setCurrentStep] = useState('');
  const chatEndRef = useRef(null);
  const logsEndRef = useRef(null);

  useEffect(() => {
    if (chatEndRef.current) {
      chatEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [chatHistory]);

  useEffect(() => {
    if (logsEndRef.current) {
      logsEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [progressLogs]);

  const addProgressLog = (message, type = 'info') => {
    const timestamp = new Date().toLocaleTimeString();
    setProgressLogs(prev => [...prev, { message, type, timestamp }]);
  };

  const simulateProgressSteps = () => {
    const steps = [
      { message: '🚀 Initializing AI presentation generator...', delay: 100 },
      { message: '🧠 Analyzing your topic and requirements...', delay: 800 },
      { message: '📝 Generating presentation outline...', delay: 1500 },
      { message: '🎨 Creating slide content and structure...', delay: 2200 },
      { message: '✨ Applying modern styling and animations...', delay: 3000 },
      { message: '🔄 Optimizing for responsiveness...', delay: 3500 },
      { message: '📱 Adding navigation and interactions...', delay: 4000 },
      { message: '🎯 Finalizing presentation...', delay: 4500 }
    ];

    steps.forEach(({ message, delay }) => {
      setTimeout(() => addProgressLog(message), delay);
    });
  };

  const handleGenerate = async () => {
    if (!prompt.trim()) {
      setError('Please enter a topic prompt');
      return;
    }

    // Transform UI to split-screen layout
    setIsGenerated(true);
    setIsLoading(true);
    setError('');
    setSuccess('');
    setProgressLogs([]);
    setShowViewer(false);

    // Add user message to chat history
    const userMessage = {
      id: Date.now(),
      type: 'user',
      content: prompt,
      timestamp: new Date().toLocaleTimeString()
    };
    setChatHistory(prev => [...prev, userMessage]);

    // Start progress simulation
    simulateProgressSteps();
    addProgressLog('🎯 Starting presentation generation...');

    try {
      const response = await fetch('http://localhost:3001/generate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ prompt }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      setGeneratedHtml(data.html);

      // Add AI response to chat history
      const aiMessage = {
        id: Date.now() + 1,
        type: 'ai',
        content: `✅ Successfully generated presentation about "${prompt}"`,
        timestamp: new Date().toLocaleTimeString(),
        hasDownload: true
      };
      setChatHistory(prev => [...prev, aiMessage]);

      addProgressLog('✅ Presentation generated successfully!', 'success');
      addProgressLog('💾 Ready for download and preview', 'success');

      // Auto-download the presentation
      setTimeout(() => {
        const blob = new Blob([data.html], { type: 'text/html' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `creatr-presentation-${Date.now()}.html`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        addProgressLog('📥 Presentation downloaded automatically', 'success');
      }, 1000);

    } catch (err) {
      setError('Failed to generate presentation. Please try again.');
      addProgressLog('❌ Generation failed. Please try again.', 'error');
      console.error('Error:', err);
    } finally {
      setIsLoading(false);
    }

    // Clear the input for next generation
    setPrompt('');
  };

  const handleNewGeneration = () => {
    setPrompt('');
    setError('');
    setSuccess('');
  };

  const downloadPresentation = () => {
    if (!generatedHtml) return;

    const blob = new Blob([generatedHtml], { type: 'text/html' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `creatr-presentation-${Date.now()}.html`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  if (!isGenerated) {
    // Initial minimal screen - just prompt and generate button
    return (
      <div className="app initial-screen">
        <div className="initial-container">
          <div className="logo-section">
            <div className="logo-container">
              <div className="logo-icon">✦</div>
              <div className="logo-text">Creatr AI</div>
            </div>
            <p className="tagline">AI-Powered Presentations</p>
          </div>

          <div className="prompt-section">
            <h1 className="main-title">What would you like to create a presentation about?</h1>

            <div className="input-group">
              <textarea
                value={prompt}
                onChange={(e) => setPrompt(e.target.value)}
                placeholder="Describe your presentation topic..."
                className="prompt-input"
                rows="4"
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && e.ctrlKey) {
                    handleGenerate();
                  }
                }}
              />
            </div>

            {/* Suggested Prompts */}
            <div className="suggested-prompts">
              <div className="prompt-chip" onClick={() => setPrompt('How to build a successful startup')}>
                How to build a successful startup
              </div>
              <div className="prompt-chip" onClick={() => setPrompt('The future of artificial intelligence')}>
                The future of artificial intelligence
              </div>
              <div className="prompt-chip" onClick={() => setPrompt('Sustainable business practices')}>
                Sustainable business practices
              </div>
            </div>

            {error && <div className="error-message">{error}</div>}

            <div className="generate-section">
              <button
                onClick={handleGenerate}
                disabled={isLoading || !prompt.trim()}
                className="generate-btn large"
              >
                <span className="btn-icon">✦</span>
                {isLoading ? 'Generating...' : 'Generate Presentation'}
              </button>
            </div>

            <p className="hint-text">Press Ctrl + Enter to generate</p>
          </div>
        </div>
      </div>
    );
  }

  // Split-screen layout after generation starts
  return (
    <div className="app split-view">
      {/* Left Side - Chat */}
      <div className="chat-panel">
        <div className="chat-header">
          <div className="logo-container small">
            <div className="logo-icon small">✦</div>
            <div className="logo-text">Creatr AI</div>
          </div>
          <button
            onClick={() => {
              setIsGenerated(false);
              setChatHistory([]);
              setGeneratedHtml('');
              setPrompt('');
            }}
            className="new-chat-btn"
          >
            + New Chat
          </button>
        </div>

        <div className="chat-messages">
          {chatHistory.map((message) => (
            <div key={message.id} className={`message-group ${message.type}`}>
              <div className="message-avatar">
                {message.type === 'ai' ? '✦' : '👤'}
              </div>
              <div className="message-content">
                <div className={`message-bubble ${message.type}`}>
                  {message.content}
                </div>
                {message.hasDownload && (
                  <div className="message-actions">
                    <button onClick={() => setShowViewer(!showViewer)} className="action-btn">
                      👁️ {showViewer ? 'Hide Preview' : 'Show Preview'}
                    </button>
                    <button onClick={downloadPresentation} className="action-btn">
                      💾 Download
                    </button>
                  </div>
                )}
              </div>
            </div>
          ))}

          {isLoading && (
            <div className="message-group ai">
              <div className="message-avatar">✦</div>
              <div className="message-content">
                <div className="message-bubble ai loading">
                  <div className="typing-indicator">
                    <span></span>
                    <span></span>
                    <span></span>
                  </div>
                  Generating your presentation...
                </div>
              </div>
            </div>
          )}

          <div ref={chatEndRef} />
        </div>

        <div className="chat-input-section">
          <div className="input-container">
            <input
              type="text"
              value={prompt}
              onChange={(e) => setPrompt(e.target.value)}
              placeholder="Generate another presentation..."
              className="chat-input"
              onKeyDown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault();
                  handleGenerate();
                }
              }}
            />
            <button
              onClick={handleGenerate}
              disabled={isLoading || !prompt.trim()}
              className="send-btn"
            >
              →
            </button>
          </div>
        </div>
      </div>

      {/* Right Side - Presentation Preview */}
      <div className="preview-panel">
        {isLoading ? (
          <div className="loading-container">
            <div className="loading-content">
              <div className="loading-spinner"></div>
              <h3>Generating Presentation...</h3>
              <div className="progress-logs">
                {progressLogs.map((log, index) => (
                  <div key={index} className={`progress-log ${log.type}`}>
                    <span className="log-time">{log.timestamp}</span>
                    <span className="log-message">{log.message}</span>
                  </div>
                ))}
                <div ref={logsEndRef} />
              </div>
            </div>
          </div>
        ) : generatedHtml ? (
          <div className="presentation-container">
            <div className="presentation-header">
              <h3>Presentation Preview</h3>
              <div className="header-actions">
                <button onClick={downloadPresentation} className="action-btn">
                  💾 Download
                </button>
              </div>
            </div>
            <iframe
              srcDoc={generatedHtml}
              title="Generated Presentation"
              className="presentation-frame"
            />
          </div>
        ) : (
          <div className="preview-placeholder">
            <div className="placeholder-content">
              <div className="placeholder-icon">🎯</div>
              <h3>Presentation Preview</h3>
              <p>Your generated presentation will appear here</p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
