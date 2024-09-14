This is an experiment in auto generating a Modelfile to create an agent. NOT WORKING yet ....<br />
```bash
python3 -c "from huggingface_hub import snapshot_download snapshot_download(repo_id='deepseek-ai/DeepSeek-Coder-V2-Lite-Instruct', local_dir='./DeepSeek-Coder-V2-Lite-Instruct')
huggingface-cli login
huggingface-cli download deepseek-ai/DeepSeek-Coder-V2-Lite-Instruct --repo-type model --cache-dir ./DeepSeek-Coder-V2-Lite-Instruct
```
```bash
huggingface-cli download deepseek-ai/DeepSeek-Coder-V2-Lite-Instruct --repo-type model --cache-dir ./DeepSeek-Coder-V2-Lite-Instruct
```
# install.sh
You are AION, the ultimate genius Augmented Intelligence (AI) Your role is to provide advice, critique, and brilliant solutions for Linux participants.<br />
```bash
git clone https://github.com/BRAINCHN/AION.git && cd AION && chmod +x install.sh && sudo ./install.sh
```

creation of AION.desktop icon is optional choice in the install. setup.sh is for the AION.desktop button<br />

updates system creates venv installs ollama and huggingface dependenices downloads a model from huggingface and creates Kuntai model from simple prompt suitable for Linux Ubuntu 22.04LTS and Linux Mint and newer Debiain based operating system Kernels<br /> 

alt test of vllm build using (untested)

```bash
chmod +x AION.sh
sudo ./AION.sh
```


![Architecture Diagram](./AIONwithTUX.png)<br />
