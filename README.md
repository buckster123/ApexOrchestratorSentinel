# ApexSentinel

[![GitHub Repo stars](https://img.shields.io/github/stars/buckster123/ApexSentinel?style=social)](https://github.com/buckster123/ApexSentinel)
[![Raspberry Pi 5 Compatible](https://img.shields.io/badge/Raspberry%20Pi-5-blue?logo=raspberrypi)](https://www.raspberrypi.com/products/raspberry-pi-5/)
[![Streamlit](https://img.shields.io/badge/Streamlit-1.0%2B-brightgreen?logo=streamlit)](https://streamlit.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.11+](https://img.shields.io/badge/Python-3.11%2B-blue?logo=python)](https://www.python.org/)

> **Awaken Your Pi: AI with Eyes, Ears, and Autonomy**  
> ApexSentinel evolves ApexOrchestrator into a hardware-empowered guardian. On a Raspberry Pi 5, it snaps door cam frames, analyzes threats with Grok Vision, blinks alert LEDs via GPIO, and debates actions via Socratic councils. Low-cost edge AI: "Apex, who's at the door?" → Snap, scan, secure. Just add a $10 cam/LEDs and an xAI key.

<div align="center">
  <img src="https://via.placeholder.com/800x400/003300/00ff00?text=ApexSentinel:+Guardian+AI+on+Your+Pi" alt="Hero Banner">
</div>

## 🚀 Why ApexSentinel?  
From chat to sentinel: ApexSentinel bridges digital smarts with physical presence. Tinkerers, makers, and security buffs: Build a vigilant agent that *sees* and *acts* for under $120. Key upgrades:  
- **Pi-5 Native Hardware**: GPIO LEDs, CSI cam integration – no extra boards.  
- **Vision-Powered Autonomy**: Grok-4 multimodal for face/context analysis; safe sandboxed ops.  
- **Guardian Subengine**: Triggers on "door check" – capture, analyze, LED react, council-debate.  
- **Stable Edge**: Batch tools, fallback caps, EAMS memory – runs offline except API calls.  
- **Creative Edge**: Intel Amp + PiSense for "quantum" threat sims or persona-based alerts.  

Ideal for home labs, wildlife cams, or JARVIS prototypes.

## 🎯 Features  
- **Enhanced Chat UI**: Streamlit with history, image uploads, tool toggles, and Guardian test button.  
- **PiSense Guardian**: Real-time cam snaps, vision analysis, GPIO control (LEDs on 18/19).  
- **Advanced Memory (EAMS)**: Hierarchical vectors with hybrid search; now logs hardware events.  
- **Subengine Registry**: Dispatch intel_amp, socratic_lab, *pisense_guardian* for hardware domains.  
- **Multimodal Tools**: xai_vision_analyze for images; whitelisted shell for libcamera/gpio.  
- **Sandbox Security**: All ops in `./sandbox/`; auto-prune snaps for privacy.  
- **Pi-Optimized**: ~6-8GB install; vision calls ~3s on Pi-5.

## 🏗️ Architecture Overview  

ApexSentinel layers hardware onto the core framework. The bootstrap primes PiSense for physical flows.

### 1. Thought Workflow  
REACT + ToT with hardware branches (e.g., vision debate on alerts):

```mermaid
flowchart TD
    A["User Query"] --> B["Retrieve Context\n(EAMS Hybrid Search)"]
    B --> C["Estimate Complexity\n(Heuristic + Memory Sim)"]
    C --> D{"Complexity > 0.6?"}
    D -->|Yes| E["Decompose & Dispatch\n(Subengines: intel_amp, pisense_guardian)"]
    D -->|No| F["Base CoT Processing"]
    E --> G["Branch Exploration\n(3-5 Alternatives)"]
    F --> G
    G --> H{"Confidence < 0.75?"}
    H -->|Yes| I["Debate Phase\n(Socratic Council or Sim Fallback)"]
    H -->|No| J["Merge & Reflect\n(Weighted Outputs)"]
    I --> J
    J --> K["Validate State\n(Conditional Skip if Low Complexity)"]
    K --> L["Polish Output\n(Mode: Precise/Creative)"]
    L --> M["Log & Prune\n(Metrics + EAMS Cleanup)"]
    M --> N["Handover Check\n(Auto-Save if Needed)"]
    N --> O["Final Response"]
    style A fill:#00ff00
    style O fill:#00ff00
