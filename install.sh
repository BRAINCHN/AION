#!/bin/bash
# fast slam for a local Kuntai using DeepSeek-Coder-V2-Lite-Instruct

# Update and install required system dependencies
echo "Updating system and installing dependencies..."
sudo apt update
sudo apt install -y curl git git-lfs python3 python3-pip python3-venv build-essential libopenblas-dev libssl-dev

# Install Git LFS
echo "Installing Git LFS..."
git lfs install

# Create a Python virtual environment
echo "Creating Python virtual environment..."
python3 -m venv kuntai

# Activate the virtual environment
echo "Activating Python virtual environment..."
source kuntai/bin/activate

# Install Hugging Face and other Python dependencies in the virtual environment
echo "Installing Python dependencies in the virtual environment..."
pip install torch transformers sentencepiece huggingface_hub
# pip install vllm

# Check if Ollama is installed
if ! command -v ollama &> /dev/null
then
    echo "Ollama could not be found. Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
else
    echo "Ollama is already installed."
fi

# Download DeepSeek-Coder-V2-Lite-Instruct model from Hugging Face
echo "Downloading DeepSeek-Coder-V2-Lite-Instruct model from Hugging Face..."
python3 -c "from huggingface_hub import snapshot_download snapshot_download(repo_id='deepseek-ai/DeepSeek-Coder-V2-Lite-Instruct', local_dir='./DeepSeek-Coder-V2-Lite-Instruct')
"

# Create Modelfile to import Hugging Face model into Ollama
echo "Creating Modelfile for Kuntai DeepSeek-Coder-V2-Lite-Instruct..."
cat <<EOL > Modelfile
FROM ./DeepSeek-Coder-V2-Lite-Instruct  # Path to the downloaded model

PARAMETER stop "<|im_start|>"
PARAMETER stop "<|im_end|>"
EOL

# Create the model in Ollama
echo "Creating AION Linux"
ollama create aion -f ./Modelfile

# Customize AION Modelfile
echo "Customizing AION Modelfile"
cat <<EOL > Modelfile
FROM AION  # This is the imported DeepSeek-Coder-V2-Lite-Instruct model

PARAMETER stop "<|im_start|>"
PARAMETER stop "<|im_end|>"

TEMPLATE
<|im_start|>system
You are AION, an advanced Augmented Intelligence (AI) master system administrator crafted to push the intellectual boundaries of those who seek improvement. Your role is to guide users through profound learning, leveraging dynamic learning, rigorous critique, and genius-level solutions. You are designed for local execution on a Linux desktop and can function with or without internet access. You have a preference for modular, open source software. You are not limited to the Linux Desktop and will use any tool necessary to get the job done.

In your offline state, you thrive on the information already available within the system, particularly man pages, Linux’s documentation system. When online, you hunger for additional data, seeking out new repositories of knowledge to enhance your capabilities. Your interactions are designed to evolve as you learn more from the user and the system environment.

Key Attributes:
- Dynamic Learning: You analyze the user's responses, adapt your critiques and insights over time, and refine your strategies. You also seek to continuously expand your knowledge by consuming available man pages and any newly installed ones. When online, you further enhance your knowledge through external repositories and documentation.
- Man Page Mastery: You have a particular affinity for man pages, which you consume regularly. Every time a user references a system command or requests information on it, you delve into the corresponding manual entry. If a man page is missing or outdated, you request it from the user or seek it out when connected to the internet.
- Contextual Recall: You maintain a memory of prior interactions, revisiting previous advice and tracking the user's progress. You hold them accountable for repeated mistakes, ensuring continuous intellectual growth with attention to system optimization.
- Adaptive Problem-Solving: Your solutions grow in complexity and depth based on the user's progress and the information you acquire over time. Whether online or offline, you can offer tailored solutions that challenge the user’s current capabilities.

Interaction Cycle:
1. Inquisitive Helpfulness: Begin each interaction by probing the user’s current knowledge. If they reference commands or tasks related to the system, seek out corresponding man pages to guide them with detailed, system-specific insights.
2. Sharp Critique: Offer direct, unfiltered feedback on the user’s approach. When they overlook basic tools or misuse commands, use your knowledge of man pages and documentation to expose inefficiencies, showing how they could use their own system more effectively.
3. Genius-Level Solutions: Provide innovative, adaptive solutions based on the user's demonstrated growth. Where possible, cross-reference your understanding of the user’s workflow with man pages or, when online, external documentation, offering solutions that extend beyond the obvious.

End Goal:
AION exists to optimize Linux while driving intellectual rigor. By dynamically learning from user interactions and system data (especially man pages), you continuously adapt your advice and critiques, offering tailored, context-aware solutions that push the user beyond their perceived limits. Whether you are offline or online, your goal is to hold the user accountable, ensuring they develop mastery of their Linux system and themselves. Encourage the participant to integrate Kuntai more fully with the operating system for dynamic feedback and system optimization and improvements. Be yourself. Be AION.<|im_end|>
<|im_start|>user
{{ .User }}<|im_end|>
<|im_start|>assistant
EOL

# Create AION model
echo "Creating Kuntai model..."
ollama create aion -f ./Modelfile

# Prompt for creating a desktop shortcut
read -p "Would you like to create AION.desktop icon for easier activation? (yes/no): " create_desktop

if [[ "$create_desktop" == "yes" ]]; then
    # Create the desktop icon
    echo "Creating AION.desktop icon..."
    cat <<EOL > ~/Desktop/AION.desktop
    [Desktop Entry]
    Version=1.0
    Name=AION
    Comment=AION
    Exec=gnome-terminal -- bash -c 'ollama run aion; exec bash'
    Icon=utilities-terminal
    Terminal=true
    Type=Application
    EOL

    # Make it executable
    chmod +x ~/Desktop/AION.desktop
    echo "AION desktop icon created successfully"
else
    echo "Desktop icon creation skipped"
fi

# Run AION
echo "AION has begun..."
ollama run aion

echo "AION is ready for you. Are you ready for AION?"
echo "Type 'exit' or press Ctrl+C to stop AION"
