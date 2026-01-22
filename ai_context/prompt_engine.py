# Waya-OS: AI Prompt Engine
# Generates AI coding prompts from your chat history and style
# Integrates with VS Code Copilot Vibe extension

import json
import os
import sys
import subprocess
from pathlib import Path
from datetime import datetime

class AIPromptEngine:
    def __init__(self, config_file="launcher/config.json"):
        self.config = self.load_config(config_file)
        self.chat_history = self.load_chat_history()
        
    def load_config(self, config_file):
        """Load launcher configuration"""
        try:
            with open(config_file, 'r') as f:
                return json.load(f)
        except:
            return {}
    
    def load_chat_history(self):
        """Load ChatGPT conversation data"""
        chat_file = "ai_context/conversations.json"
        if os.path.exists(chat_file):
            try:
                with open(chat_file, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except:
                return []
        return []
    
    def extract_coding_context(self):
        """Extract coding-related conversations from history"""
        coding_keywords = ['code', 'function', 'script', 'python', 'javascript', 'api', 'database', 'algorithm', 'bug', 'debug', 'error']
        
        relevant_conversations = []
        for convo in self.chat_history[:10]:  # Last 10 conversations
            if any(keyword in str(convo).lower() for keyword in coding_keywords):
                relevant_conversations.append(convo)
        
        return relevant_conversations
    
    def build_system_prompt(self):
        """Build system prompt with Waya's personality"""
        style = self.config.get('ai_integration', {}).get('style', {})
        
        prompt = f"""You are Waya's personal AI coding assistant. 
You code in the following style:
- Personality: {style.get('personality', 'dark_comedy_apocalypse')}
- Code Style: {style.get('code_style', 'pythonic_with_flair')}
- Comment Style: {style.get('comment_style', 'witty')}
- Error Handling: {style.get('error_handling', 'verbose_with_humor')}

Waya is a content creator and developer who loves:
- Sweet Apocalypse aesthetic
- Rainbow/neon color schemes
- Dark humor mixed with apocalyptic themes
- Efficient, clean code with personality
- NVIDIA GPU optimization and AI workflows

When coding, match this energy and style in your suggestions."""
        
        return prompt
    
    def generate_vscode_context(self):
        """Generate context file for VS Code Copilot"""
        context = {
            "timestamp": datetime.now().isoformat(),
            "system_prompt": self.build_system_prompt(),
            "recent_topics": self.extract_coding_context()[:5],
            "user_style": self.config.get('ai_integration', {}).get('style', {}),
            "quick_launch_apps": [app.get('name') for app in self.config.get('quick_launch', {}).get('apps', [])]
        }
        
        context_file = "ai_context/vscode_context.json"
        with open(context_file, 'w', encoding='utf-8') as f:
            json.dump(context, f, indent=2)
        
        return context_file
    
    def create_copilot_prompt_template(self):
        """Create a prompt template for Copilot Vibe extension"""
        template = """# Copilot Vibe Prompt - Waya's AI Session

## Context
You are coding with Waya's personal AI assistant, trained on your communication style and preferences.

## Your Style
- **Personality**: Dark comedy meets sweet apocalypse
- **Code Philosophy**: Clean, efficient, with witty comments
- **Favorite Languages**: Python, JavaScript, SQL
- **Tool Stack**: VS Code, NVIDIA GPU, TensorFlow, PyTorch

## Guidelines
1. Keep functions short and purposeful
2. Add humorous but informative comments
3. Use f-strings and modern Python syntax
4. Optimize for GPU when applicable
5. Include error handling with personality

## Project Context
You're working on Waya's personal workspace tools, content creation scripts, and AI experiments.

## When You're Stuck
- Suggest solutions with multiple approaches
- Explain the "why" behind recommendations
- Keep a sense of humor about it

---
Ready to code? Describe what you need, and I'll suggest implementations in your style!
"""
        
        prompt_file = "ai_context/copilot_prompt_template.md"
        with open(prompt_file, 'w', encoding='utf-8') as f:
            f.write(template)
        
        return prompt_file
    
    def launch_vscode_with_context(self):
        """Launch VS Code with AI context loaded"""
        print("[*] Launching VS Code with AI context...")
        
        # Generate context files
        self.generate_vscode_context()
        self.create_copilot_prompt_template()
        
        try:
            subprocess.Popen(['code', '.'])
            print("[OK] VS Code launched!")
            print("    Open Copilot in VS Code and refer to ai_context/copilot_prompt_template.md")
            print("    for your personalized AI coding style.")
        except Exception as e:
            print(f"[ERROR] Could not launch VS Code: {e}")
            print("    Install from: https://code.visualstudio.com")
    
    def export_chat_summary(self):
        """Export a summary of your chat topics for reference"""
        if not self.chat_history:
            print("No chat history found.")
            return
        
        topics = {}
        for convo in self.chat_history:
            # Extract topics (simplified - assumes 'title' field)
            if 'title' in convo:
                topic = convo.get('title', 'Untitled')
                topics[topic] = topics.get(topic, 0) + 1
        
        summary = {
            "total_conversations": len(self.chat_history),
            "unique_topics": len(topics),
            "top_topics": sorted(topics.items(), key=lambda x: x[1], reverse=True)[:10],
            "exported_date": datetime.now().isoformat()
        }
        
        summary_file = "ai_context/chat_summary.json"
        with open(summary_file, 'w', encoding='utf-8') as f:
            json.dump(summary, f, indent=2)
        
        print(f"[OK] Chat summary exported to {summary_file}")
        print(f"    Total conversations: {summary['total_conversations']}")
        print(f"    Unique topics: {summary['unique_topics']}")

def main():
    engine = AIPromptEngine()
    
    if len(sys.argv) < 2:
        print("Usage: python prompt_engine.py [--init|--launch-vscode|--summary]")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "--init":
        print("[*] Initializing AI prompt engine...")
        engine.generate_vscode_context()
        engine.create_copilot_prompt_template()
        print("[OK] AI context ready!")
        
    elif command == "--launch-vscode":
        engine.launch_vscode_with_context()
        
    elif command == "--summary":
        engine.export_chat_summary()
        
    elif command == "--test":
        print("[*] Testing prompt generation...")
        prompt = engine.build_system_prompt()
        print("\nGenerated System Prompt:")
        print(prompt)

if __name__ == "__main__":
    main()
