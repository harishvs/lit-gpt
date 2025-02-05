#!/bin/bash -l

# SLURM SUBMIT SCRIPT
#SBATCH --nodes=2               # This needs to match Fabric(num_nodes=...)
#SBATCH --ntasks-per-node=4     # This needs to match Fabric(devices=...)
#SBATCH --gres=gpu:4            # Request N GPUs per machine
#SBATCH --mem=0
#SBATCH --time=0-02:00:00


# Debugging flags (optional)
export NCCL_DEBUG=INFO
export PYTHONFAULTHANDLER=1

git clone https://github.com/harishvs/lit-gpt.git
cd lit-gpt

pip install lightning @ git+https://github.com/Lightning-AI/lightning@6dfa5cca9de5c28548eef5582a53c483b0eda66a
mkdir -p /data/fsx/out/redpajama-sample


# Run your training script
srun python pretrain/redpajama.py --devices 4 --train_data_dir /data/fsx/lit-redpajama-sample