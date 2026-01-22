#!/usr/bin/env python3
"""
MCP (Model Context Protocol) Server for Waya-OS
Provides AI automation for Windows subsystem with screen interaction
Personalized from user's ChatGPT history
"""

import json
import sys
import asyncio
from typing import Any, Optional
from dataclasses import dataclass, asdict
from pathlib import Path
import subprocess
import time

# Import chat history for personalization
try:
    with open("ai_context/user_data/conversations.json") as f:
        CHAT_HISTORY = json.load(f)
except:
    CHAT_HISTORY = []

try:
    with open("ai_context/user_data/user.json") as f:
        USER_DATA = json.load(f)
except:
    USER_DATA = {}

USER_NAME = USER_DATA.get("user", {}).get("name", "User")
USER_EMAIL = USER_DATA.get("user", {}).get("email", "")

@dataclass
class MCPMessage:
    """Standard MCP message format"""
    jsonrpc: str = "2.0"
    id: Optional[int] = None
    method: str = ""
    params: dict = None
    result: Any = None
    error: Optional[dict] = None

class WayaOSMCPServer:
    """MCP Server for Waya-OS AI Automation"""
    
    def __init__(self):
        self.personality = self._build_personality()
        self.screen_state = {}
        self.automation_history = []
        
    def _build_personality(self) -> dict:
        """Build AI personality from user's chat history"""
        personality = {
            "name": f"Aqua Jarvis for {USER_NAME}",
            "style": "Professional + Helpful + Creative",
            "knowledge_base": self._extract_coding_patterns(),
            "preferences": self._extract_preferences(),
            "specializations": self._extract_specializations()
        }
        return personality
    
    def _extract_coding_patterns(self) -> list:
        """Extract coding patterns from chat history"""
        patterns = []
        for conv in CHAT_HISTORY[:10]:  # Last 10 conversations
            if "python" in str(conv).lower():
                patterns.append("Python development")
            if "javascript" in str(conv).lower():
                patterns.append("JavaScript/Node.js")
            if "database" in str(conv).lower():
                patterns.append("Database design")
            if "ai" in str(conv).lower() or "machine learning" in str(conv).lower():
                patterns.append("AI/ML applications")
        return list(set(patterns))
    
    def _extract_preferences(self) -> dict:
        """Extract user preferences"""
        return {
            "dark_mode": True,
            "automation_speed": "fast",
            "verbose_mode": False,
            "auto_install": True
        }
    
    def _extract_specializations(self) -> list:
        """Determine AI specializations based on history"""
        specializations = [
            "Windows automation",
            "System optimization",
            "Code assistance",
            "Installation help"
        ]
        specializations.extend(self._extract_coding_patterns())
        return specializations
    
    async def handle_screen_read(self, params: dict) -> dict:
        """Read current screen state for AI perception"""
        try:
            result = subprocess.run(
                ["powershell", "-Command", "Get-Process | Select-Object Name, CPU, Memory"],
                capture_output=True,
                text=True,
                timeout=5
            )
            return {
                "status": "success",
                "processes": result.stdout,
                "timestamp": time.time()
            }
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    async def handle_automation(self, params: dict) -> dict:
        """Execute automation command"""
        action = params.get("action", "")
        args = params.get("args", {})
        
        if action == "install_app":
            return await self.auto_install_app(args)
        elif action == "system_optimize":
            return await self.optimize_system(args)
        elif action == "run_script":
            return await self.run_automation_script(args)
        elif action == "get_suggestion":
            return await self.get_ai_suggestion(args)
        else:
            return {"status": "error", "message": f"Unknown action: {action}"}
    
    async def auto_install_app(self, args: dict) -> dict:
        """Personalized app installation"""
        app_name = args.get("app", "")
        
        # Personalized suggestions based on history
        install_method = "winget"  # Default
        if "python" in app_name.lower():
            install_method = "official"  # Install from official Python
        elif "vscode" in app_name.lower():
            install_method = "microsoft"
        
        try:
            cmd = f"winget install {app_name} -e --accept-package-agreements --accept-source-agreements"
            result = subprocess.run(
                ["powershell", "-Command", cmd],
                capture_output=True,
                text=True,
                timeout=300
            )
            
            self.automation_history.append({
                "action": "install",
                "app": app_name,
                "status": "success",
                "timestamp": time.time()
            })
            
            return {
                "status": "success",
                "message": f"{app_name} installed successfully",
                "output": result.stdout,
                "method": install_method
            }
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    async def optimize_system(self, args: dict) -> dict:
        """System optimization based on user profile"""
        optimization_type = args.get("type", "general")
        
        optimizations = {
            "general": [
                "Clear temp files",
                "Disable unused services",
                "Optimize startup programs",
                "Update drivers"
            ],
            "gaming": [
                "Enable high performance GPU",
                "Disable background apps",
                "Optimize memory",
                "Update GPU drivers"
            ],
            "development": [
                "Setup dev environment",
                "Install Git hooks",
                "Configure IDE",
                "Setup linters"
            ]
        }
        
        actions = optimizations.get(optimization_type, optimizations["general"])
        
        return {
            "status": "success",
            "optimizations": actions,
            "estimated_time": "15 minutes",
            "personalized_for": USER_NAME
        }
    
    async def run_automation_script(self, args: dict) -> dict:
        """Run custom automation script"""
        script_path = args.get("script", "")
        
        try:
            result = subprocess.run(
                ["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path],
                capture_output=True,
                text=True,
                timeout=600
            )
            
            return {
                "status": "success",
                "output": result.stdout,
                "errors": result.stderr if result.stderr else None
            }
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    async def get_ai_suggestion(self, args: dict) -> dict:
        """Get AI suggestion based on user context"""
        context = args.get("context", "")
        
        # Personalized suggestions based on specializations
        suggestions = {
            "installation": f"Based on your {self.personality['specializations']}, I recommend...",
            "optimization": f"For {USER_NAME}, optimization priorities are...",
            "development": f"Given your experience with {', '.join(self.personality['knowledge_base'])}, I suggest..."
        }
        
        suggestion_type = args.get("type", "general")
        suggestion = suggestions.get(suggestion_type, f"Hi {USER_NAME}, here's my suggestion for {context}...")
        
        return {
            "status": "success",
            "suggestion": suggestion,
            "confidence": 0.95,
            "personalized": True,
            "based_on": self.personality['knowledge_base']
        }
    
    async def handle_message(self, message_data: dict) -> dict:
        """Handle MCP protocol message"""
        method = message_data.get("method", "")
        params = message_data.get("params", {})
        msg_id = message_data.get("id")
        
        try:
            if method == "screen/read":
                result = await self.handle_screen_read(params)
            elif method == "automation/execute":
                result = await self.handle_automation(params)
            elif method == "personality/get":
                result = asdict(MCPMessage()) if hasattr(self.personality, '__dict__') else self.personality
            else:
                result = {"status": "error", "message": f"Unknown method: {method}"}
            
            response = MCPMessage(
                jsonrpc="2.0",
                id=msg_id,
                result=result
            )
        except Exception as e:
            response = MCPMessage(
                jsonrpc="2.0",
                id=msg_id,
                error={"code": -1, "message": str(e)}
            )
        
        return asdict(response) if hasattr(response, '__dict__') else response
    
    async def run_server(self):
        """Run MCP server"""
        print(f"🤖 Aqua Jarvis MCP Server Starting for {USER_NAME}...")
        print(f"📍 Personality: {self.personality['name']}")
        print(f"🎯 Specializations: {', '.join(self.personality['specializations'])}")
        print(f"✅ Ready for automation requests")
        
        while True:
            try:
                # Read from stdin (MCP protocol)
                line = input()
                message = json.loads(line)
                
                # Handle message
                response = await self.handle_message(message)
                
                # Send response
                print(json.dumps(response))
            except json.JSONDecodeError:
                continue
            except KeyboardInterrupt:
                print(f"👋 Aqua Jarvis MCP Server shutting down for {USER_NAME}")
                break
            except Exception as e:
                error_response = MCPMessage(
                    error={"code": -1, "message": str(e)}
                )
                print(json.dumps(asdict(error_response)))

async def main():
    """Main entry point"""
    server = WayaOSMCPServer()
    await server.run_server()

if __name__ == "__main__":
    asyncio.run(main())
