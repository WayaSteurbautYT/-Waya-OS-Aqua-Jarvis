# Aqua Jarvis Launcher - Main Application
# Interactive dashboard for Waya-OS: Aqua Jarvis Edition

import json
import os
import sys
import subprocess
import threading
import psutil
from pathlib import Path

# Try to import GUI libraries
try:
    import tkinter as tk
    from tkinter import ttk
    import tkinter.font as tkFont
except ImportError:
    print("ERROR: tkinter not found. Install Python with tkinter support.")
    sys.exit(1)

class AquaJarvisLauncher:
    def __init__(self, root):
        self.root = root
        self.root.title("Aqua Jarvis - Waya-OS Launcher")
        self.root.geometry("1200x800")
        
        # Load configuration
        self.config = self.load_config()
        self.setup_colors()
        self.setup_ui()
        self.start_monitoring()
        
    def load_config(self):
        """Load launcher configuration from config.json"""
        try:
            with open('launcher/config.json', 'r') as f:
                return json.load(f)
        except Exception as e:
            print(f"WARNING: Could not load config.json: {e}")
            return {}
    
    def setup_colors(self):
        """Set up theme colors from configuration"""
        colors = self.config.get('theme', {}).get('colors', {})
        self.primary = colors.get('primary', '#7FFFD4')      # Aquamarine
        self.secondary = colors.get('secondary', '#3A0CA3')  # Dark Purple
        self.accent_gold = colors.get('accent_gold', '#FFD700')
        self.bg_black = colors.get('accent_black', '#000000')
        
        # Apply theme to root window
        self.root.configure(bg=self.secondary)
        style = ttk.Style()
        style.theme_use('clam')
        
    def setup_ui(self):
        """Create launcher interface"""
        # Header
        header = tk.Frame(self.root, bg=self.primary, height=100)
        header.pack(fill=tk.X, padx=0, pady=0)
        
        title = tk.Label(
            header,
            text="Aqua Jarvis - AI Coding Workspace",
            font=("Segoe UI", 24, "bold"),
            bg=self.primary,
            fg=self.secondary
        )
        title.pack(pady=20)
        
        subtitle = tk.Label(
            header,
            text="Sweet Apocalypse Edition | NVIDIA GPU Optimized",
            font=("Segoe UI", 10),
            bg=self.primary,
            fg=self.secondary
        )
        subtitle.pack()
        
        # Main content area
        content = tk.Frame(self.root, bg=self.secondary)
        content.pack(fill=tk.BOTH, expand=True, padx=20, pady=20)
        
        # Quick Launch Section
        self.create_quick_launch(content)
        
        # System Monitor Section
        self.create_system_monitor(content)
        
        # Footer with status
        footer = tk.Frame(self.root, bg=self.bg_black, height=50)
        footer.pack(fill=tk.X, side=tk.BOTTOM)
        
        self.status_label = tk.Label(
            footer,
            text="Ready",
            font=("Segoe UI", 10),
            bg=self.bg_black,
            fg=self.primary
        )
        self.status_label.pack(pady=15)
        
    def create_quick_launch(self, parent):
        """Create quick launch buttons"""
        section = tk.LabelFrame(
            parent,
            text="Quick Launch",
            font=("Segoe UI", 12, "bold"),
            bg=self.secondary,
            fg=self.primary,
            relief=tk.FLAT
        )
        section.pack(fill=tk.X, pady=(0, 20))
        
        button_frame = tk.Frame(section, bg=self.secondary)
        button_frame.pack(padx=10, pady=10)
        
        # Quick launch apps from config
        apps = self.config.get('quick_launch', {}).get('apps', [])
        for i, app in enumerate(apps[:6]):  # Display first 6 apps
            btn = tk.Button(
                button_frame,
                text=app.get('name', 'App'),
                command=lambda cmd=app.get('command', ''): self.launch_app(cmd),
                bg=self.primary,
                fg=self.secondary,
                padx=15,
                pady=10,
                font=("Segoe UI", 10, "bold"),
                relief=tk.RAISED
            )
            btn.grid(row=i//3, column=i%3, padx=10, pady=10)
        
    def create_system_monitor(self, parent):
        """Create system monitoring panel"""
        section = tk.LabelFrame(
            parent,
            text="System Status",
            font=("Segoe UI", 12, "bold"),
            bg=self.secondary,
            fg=self.primary,
            relief=tk.FLAT
        )
        section.pack(fill=tk.BOTH, expand=True)
        
        # Create labels for monitoring
        self.cpu_label = tk.Label(section, text="CPU: 0%", font=("Segoe UI", 11), bg=self.secondary, fg=self.accent_gold)
        self.cpu_label.pack(anchor=tk.W, padx=20, pady=5)
        
        self.mem_label = tk.Label(section, text="RAM: 0%", font=("Segoe UI", 11), bg=self.secondary, fg=self.accent_gold)
        self.mem_label.pack(anchor=tk.W, padx=20, pady=5)
        
        self.gpu_label = tk.Label(section, text="GPU: 0% | VRAM: 0 MB", font=("Segoe UI", 11), bg=self.secondary, fg=self.accent_gold)
        self.gpu_label.pack(anchor=tk.W, padx=20, pady=5)
        
        # AI Context info
        ai_frame = tk.Frame(section, bg=self.secondary)
        ai_frame.pack(fill=tk.X, padx=20, pady=20)
        
        ai_label = tk.Label(ai_frame, text="AI Context Loaded", font=("Segoe UI", 10), bg=self.secondary, fg=self.primary)
        ai_label.pack(anchor=tk.W)
        
        ai_btn = tk.Button(
            ai_frame,
            text="Launch VS Code with AI Session",
            command=self.launch_ai_session,
            bg=self.primary,
            fg=self.secondary,
            padx=20,
            pady=10,
            font=("Segoe UI", 10, "bold")
        )
        ai_btn.pack(pady=10)
    
    def launch_app(self, command):
        """Launch an application"""
        try:
            if command.startswith('http'):
                subprocess.Popen(f'explorer "{command}"')
            else:
                subprocess.Popen(command)
            self.status_label.config(text=f"Launched: {command}")
        except Exception as e:
            self.status_label.config(text=f"Error: {e}")
    
    def launch_ai_session(self):
        """Launch VS Code with AI context loaded"""
        try:
            # Generate AI prompt from chat history
            subprocess.Popen(['python', 'ai_context/prompt_engine.py', '--launch-vscode'])
            self.status_label.config(text="Launching VS Code with AI context...")
        except Exception as e:
            self.status_label.config(text=f"Error launching AI session: {e}")
    
    def start_monitoring(self):
        """Start system monitoring thread"""
        def monitor():
            while True:
                try:
                    # CPU usage
                    cpu = psutil.cpu_percent(interval=1)
                    
                    # Memory usage
                    mem = psutil.virtual_memory().percent
                    
                    # Update labels
                    self.root.after(0, lambda: self.cpu_label.config(text=f"CPU: {cpu}%"))
                    self.root.after(0, lambda: self.mem_label.config(text=f"RAM: {mem}%"))
                    
                    # Try to get GPU info (if nvidia-smi available)
                    try:
                        import subprocess
                        result = subprocess.run(['nvidia-smi', '--query-gpu=memory.used,memory.total', '--format=csv,nounits,noheader'], 
                                              capture_output=True, text=True, timeout=2)
                        if result.returncode == 0:
                            used, total = map(float, result.stdout.strip().split(','))
                            gpu_percent = (used / total) * 100
                            self.root.after(0, lambda: self.gpu_label.config(text=f"GPU: {gpu_percent:.1f}% | VRAM: {used:.0f} MB / {total:.0f} MB"))
                    except:
                        pass
                    
                except Exception as e:
                    print(f"Monitoring error: {e}")
                    break
        
        thread = threading.Thread(target=monitor, daemon=True)
        thread.start()

if __name__ == "__main__":
    root = tk.Tk()
    app = AquaJarvisLauncher(root)
    root.mainloop()
