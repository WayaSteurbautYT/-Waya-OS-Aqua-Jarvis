import React from 'react';

// Shadcn UI-style button components
const Button = ({ children, className, ...props }) => (
  <button
    className={`px-6 py-3 rounded-lg font-semibold transition ${className}`}
    {...props}
  >
    {children}
  </button>
);

const Card = ({ children, className }) => (
  <div className={`bg-[#3A0CA3] rounded-lg p-6 border border-[#7FFFD4] ${className}`}>
    {children}
  </div>
);

export default function Home() {
  return (
    <div className="min-h-screen bg-[#1a1a2e] text-white overflow-hidden">
      {/* Navigation */}
      <nav className="border-b border-[#7FFFD4]/30 bg-[#0f0f1e]/80 backdrop-blur">
        <div className="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
          <div className="text-2xl font-bold flex items-center gap-2">
            <span className="text-[#7FFFD4]">🌈</span>
            Waya-OS
          </div>
          <div className="flex gap-6">
            <a href="#features" className="hover:text-[#7FFFD4] transition">Features</a>
            <a href="#download" className="hover:text-[#7FFFD4] transition">Download</a>
            <a href="https://github.com/WayaSteurbautYT/-Waya-OS-Aqua-Jarvis" className="text-[#7FFFD4]">GitHub</a>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative py-20 px-6">
        <div className="max-w-4xl mx-auto text-center">
          {/* Animated gradient background */}
          <div className="absolute inset-0 bg-gradient-to-b from-[#7FFFD4]/10 to-transparent blur-3xl"></div>
          
          <div className="relative">
            <h1 className="text-6xl font-black mb-6 bg-gradient-to-r from-[#7FFFD4] to-[#FFD700] bg-clip-text text-transparent">
              Waya-OS: Aqua Jarvis Edition
            </h1>
            <p className="text-xl text-gray-300 mb-8">
              AI-Powered Windows Subsystem with Sweet Apocalypse Theme
            </p>
            <p className="text-gray-400 mb-12 max-w-2xl mx-auto">
              Experience a complete Windows customization system powered by your ChatGPT history.
              Personalized AI automation, GPU optimization, and a beautiful dark theme—all in one.
            </p>
            
            <div className="flex gap-4 justify-center mb-16">
              <Button className="bg-[#7FFFD4] text-[#1a1a2e] hover:bg-[#5FDFB4]">
                🚀 Download ISO
              </Button>
              <Button className="bg-[#3A0CA3] text-white border border-[#7FFFD4] hover:bg-[#4A1CB3]">
                📖 Documentation
              </Button>
            </div>

            {/* Feature highlights */}
            <div className="grid grid-cols-3 gap-4 max-w-2xl mx-auto">
              <div className="text-sm">
                <div className="text-2xl mb-2">🎨</div>
                <div className="text-[#7FFFD4]">Beautiful Theme</div>
              </div>
              <div className="text-sm">
                <div className="text-2xl mb-2">🤖</div>
                <div className="text-[#7FFFD4]">AI Assistant</div>
              </div>
              <div className="text-sm">
                <div className="text-2xl mb-2">⚡</div>
                <div className="text-[#7FFFD4]">GPU Optimized</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 px-6 bg-[#0f0f1e]">
        <div className="max-w-5xl mx-auto">
          <h2 className="text-4xl font-bold mb-12 text-center">Why Waya-OS?</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Card>
              <h3 className="text-xl font-bold text-[#7FFFD4] mb-3">🎯 Personalized AI</h3>
              <p className="text-gray-400">
                Your Aqua Jarvis learns from your ChatGPT history, understanding your coding style and preferences.
              </p>
            </Card>

            <Card>
              <h3 className="text-xl font-bold text-[#FFD700] mb-3">🚀 GPU Optimized</h3>
              <p className="text-gray-400">
                NVIDIA CUDA support with real-time GPU monitoring and TensorFlow/PyTorch integration.
              </p>
            </Card>

            <Card>
              <h3 className="text-xl font-bold text-[#7FFFD4] mb-3">🛡️ Completely Safe</h3>
              <p className="text-gray-400">
                Full system backup and complete rollback capability. Zero data loss guarantee.
              </p>
            </Card>

            <Card>
              <h3 className="text-xl font-bold text-[#FFD700] mb-3">🎨 Beautiful Design</h3>
              <p className="text-gray-400">
                Sweet Apocalypse aesthetic with aquamarine accents, gold highlights, and dark mode.
              </p>
            </Card>

            <Card>
              <h3 className="text-xl font-bold text-[#7FFFD4] mb-3">⚙️ MCP Automation</h3>
              <p className="text-gray-400">
                Model Context Protocol integration for intelligent Windows system automation and screen interaction.
              </p>
            </Card>

            <Card>
              <h3 className="text-xl font-bold text-[#FFD700] mb-3">📦 One-Click Install</h3>
              <p className="text-gray-400">
                Simple, guided installation with optional features. Works on Windows 10/11/12.
              </p>
            </Card>
          </div>
        </div>
      </section>

      {/* Download Section */}
      <section id="download" className="py-20 px-6">
        <div className="max-w-3xl mx-auto text-center">
          <h2 className="text-4xl font-bold mb-12">Get Started Now</h2>
          
          <Card className="mb-8">
            <h3 className="text-2xl font-bold text-[#7FFFD4] mb-4">Installation Methods</h3>
            
            <div className="grid gap-4 text-left">
              <div className="bg-[#0f0f1e] p-4 rounded border border-[#7FFFD4]/20">
                <h4 className="font-bold text-[#FFD700] mb-2">💾 USB Installation (Recommended)</h4>
                <ol className="text-sm text-gray-400 list-decimal list-inside">
                  <li>Download ISO from GitHub</li>
                  <li>Download Rufus (rufus.ie)</li>
                  <li>Create bootable USB</li>
                  <li>Boot and install</li>
                </ol>
              </div>

              <div className="bg-[#0f0f1e] p-4 rounded border border-[#7FFFD4]/20">
                <h4 className="font-bold text-[#FFD700] mb-2">🖥️ Direct Installation</h4>
                <ol className="text-sm text-gray-400 list-decimal list-inside">
                  <li>Extract ISO on Windows</li>
                  <li>Run install_enhanced.bat</li>
                  <li>Follow the wizard</li>
                  <li>Restart and enjoy!</li>
                </ol>
              </div>
            </div>
          </Card>

          <div className="flex gap-4 justify-center">
            <Button className="bg-[#7FFFD4] text-[#1a1a2e] hover:bg-[#5FDFB4]">
              📥 Download Latest ISO
            </Button>
            <Button className="bg-[#3A0CA3] text-white border border-[#7FFFD4] hover:bg-[#4A1CB3]">
              📚 Full Guide
            </Button>
          </div>
        </div>
      </section>

      {/* Technical Stack */}
      <section className="py-20 px-6 bg-[#0f0f1e]">
        <div className="max-w-4xl mx-auto">
          <h2 className="text-3xl font-bold mb-12 text-center">Built With</h2>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-[#3A0CA3] rounded p-4 text-center border border-[#7FFFD4]/30">
              <div className="text-sm font-bold text-[#7FFFD4]">Python 3.10+</div>
            </div>
            <div className="bg-[#3A0CA3] rounded p-4 text-center border border-[#7FFFD4]/30">
              <div className="text-sm font-bold text-[#7FFFD4]">PowerShell 5.0+</div>
            </div>
            <div className="bg-[#3A0CA3] rounded p-4 text-center border border-[#7FFFD4]/30">
              <div className="text-sm font-bold text-[#7FFFD4]">NVIDIA CUDA</div>
            </div>
            <div className="bg-[#3A0CA3] rounded p-4 text-center border border-[#7FFFD4]/30">
              <div className="text-sm font-bold text-[#7FFFD4]">Next.js & Tailwind</div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-[#7FFFD4]/30 bg-[#0f0f1e] py-12 px-6">
        <div className="max-w-5xl mx-auto">
          <div className="grid grid-cols-3 gap-8 mb-8">
            <div>
              <h4 className="font-bold text-[#7FFFD4] mb-4">Product</h4>
              <ul className="text-sm text-gray-400 space-y-2">
                <li><a href="#" className="hover:text-[#7FFFD4]">Features</a></li>
                <li><a href="#" className="hover:text-[#7FFFD4]">Download</a></li>
                <li><a href="#" className="hover:text-[#7FFFD4]">Documentation</a></li>
              </ul>
            </div>
            <div>
              <h4 className="font-bold text-[#7FFFD4] mb-4">Community</h4>
              <ul className="text-sm text-gray-400 space-y-2">
                <li><a href="#" className="hover:text-[#7FFFD4]">GitHub</a></li>
                <li><a href="#" className="hover:text-[#7FFFD4]">Issues</a></li>
                <li><a href="#" className="hover:text-[#7FFFD4]">Discussions</a></li>
              </ul>
            </div>
            <div>
              <h4 className="font-bold text-[#7FFFD4] mb-4">Resources</h4>
              <ul className="text-sm text-gray-400 space-y-2">
                <li><a href="#" className="hover:text-[#7FFFD4]">Quick Start</a></li>
                <li><a href="#" className="hover:text-[#7FFFD4]">FAQ</a></li>
                <li><a href="#" className="hover:text-[#7FFFD4]">Support</a></li>
              </ul>
            </div>
          </div>
          
          <div className="border-t border-[#7FFFD4]/30 pt-8 text-center text-sm text-gray-500">
            <p>Created by WayaSteurbautYT | © 2026 Waya-OS. MIT License.</p>
            <p className="mt-2">🌈 Built with Tailwind CSS & Shadcn UI</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
