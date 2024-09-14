#!/bin/bash

# AION.sh - Installs dependencies, sets up vLLM, configures Python venv, creates the AION_vllm.py script, and launches AION.

# Step 1: Install system dependencies
echo "Updating system and installing required packages..."
sudo apt update
sudo apt install -y curl python3 python3-pip python3-venv build-essential libopenblas-dev libssl-dev

# Step 2: Create a Python virtual environment for vLLM
echo "Creating Python virtual environment for AION..."
python3 -m venv aion_env

# Step 3: Activate the virtual environment
source aion_env/bin/activate

# Step 4: Install Python dependencies in the virtual environment
echo "Installing Python dependencies (vLLM, transformers, torch, and huggingface_hub)..."
pip install vllm transformers torch huggingface_hub

# Step 5: Download the DeepSeek-Coder-V2-Lite-Instruct model from Hugging Face
echo "Downloading AION model (DeepSeek-Coder-V2-Lite-Instruct) from Hugging Face..."
python3 -c "
from huggingface_hub import snapshot_download

# Download the model from Hugging Face to the local directory
snapshot_download(repo_id='deepseek-ai/DeepSeek-Coder-V2-Lite-Instruct', local_dir='./DeepSeek-Coder-V2-Lite-Instruct')
"

# Step 6: Create the AION_vllm.py launcher script
echo "Creating Python launcher script for AION (AION_vllm.py)..."
cat <<EOL > AION_vllm.py
from transformers import AutoTokenizer
from vllm import LLM, SamplingParams

# Load the tokenizer and model from the local directory
model_name = './DeepSeek-Coder-V2-Lite-Instruct'
tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
llm = LLM(model=model_name, tensor_parallel_size=1, max_model_len=8192, trust_remote_code=True)

# Prepare the input prompt
messages = [{"role": "user", "content": "Who are you, AION?"}]

# Tokenize the input prompt
prompt_token_ids = tokenizer.apply_chat_template(messages, add_generation_prompt=True)

# Set sampling parameters for generation
sampling_params = SamplingParams(temperature=0.7, max_tokens=256)

# Generate the response using vLLM
output = llm.generate(prompt_token_ids=[prompt_token_ids], sampling_params=sampling_params)

# Print the generated response from AION
for result in output:
    print(result.outputs[0].text)
EOL

# Step 7: Make the Python launcher script executable
chmod +x AION_vllm.py

# Step 8: Run the AION Python script
echo "Launching AION with vLLM..."
python3 AION_vllm.py

# Step 9: Deactivate the Python virtual environment after execution
deactivate

echo "AION has finished. To relaunch, execute './AION.sh'."
