import React, { useState } from 'react';
import './App.css';

function App() {
  const [prompt, setPrompt] = useState('');
  const [generatedHtml, setGeneratedHtml] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  const handleGenerate = async () => {
    if (!prompt.trim()) {
      setError('Please enter a topic prompt');
      return;
    }

    setIsLoading(true);
    setError('');
    
    try {
      const response = await fetch('/generate', {
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
    } catch (err) {
      setError('Failed to generate presentation. Please try again.');
      console.error('Error:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleDownload = async () => {
    if (!generatedHtml) return;
    
    console.log('Starting ZIP download...');
    try {
      const response = await fetch('/download', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ html: generatedHtml }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const blob = await response.blob();
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `presentation_${new Date().toISOString().slice(0, 19).replace(/[:-]/g, '')}.zip`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    } catch (err) {
      setError('Failed to download presentation package. Please try again.');
      console.error('Download error:', err);
    }
  };

  return (
    <div className="app">
      <header className="header">
        <div className="container">
          <h1 className="logo">Creatr</h1>
          <p className="tagline">AI-Powered Presentation Generator</p>
        </div>
      </header>

      <main className="main">
        <div className="container">
          <div className="generator-section">
            <div className="input-group">
              <label htmlFor="prompt" className="label">
                Enter your presentation topic:
              </label>
              <textarea
                id="prompt"
                value={prompt}
                onChange={(e) => setPrompt(e.target.value)}
                placeholder="E.g., Digital transformation in healthcare, AI in education, sustainable business practices..."
                className="textarea"
                rows="4"
              />
            </div>

            {error && <div className="error-message">{error}</div>}

            <div className="button-group">
              <button
                onClick={handleGenerate}
                disabled={isLoading}
                className="btn btn-primary"
              >
                {isLoading ? 'Generating...' : 'Generate Presentation'}
              </button>

              {generatedHtml && (
                <button
                  onClick={handleDownload}
                  className="btn btn-secondary"
                >
                  Download Presentation Package
                </button>
              )}
            </div>
          </div>

        </div>
      </main>

      <footer className="footer">
        <div className="container">
          <p>&copy; 2024 Creatr. Powered by Claude AI.</p>
          <div className="asset-info">
            <small>
              <strong>Download includes:</strong> Complete presentation with CSS, JavaScript, images, and all dependencies bundled together
            </small>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default App;