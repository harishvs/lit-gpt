cat >lit-redpajama-sample <<EOD
#!/bin/bash
# SLURM SUBMIT SCRIPT
#SBATCH --nodes=2               # This needs to match Fabric(num_nodes=...)
#SBATCH --ntasks-per-node=4     # This needs to match Fabric(devices=...)
#SBATCH --gres=gpu:4            # Request N GPUs per machine
#SBATCH --mem=0
#SBATCH --time=0-02:00:00
#SBATCH --output=/data/fsx/slurm-%j.out # Set the output file name
#SBATCH --error=/data/fsx/slurm-%j.err   # Set the error file ame


export NCCL_DEBUG=INFO
export PYTHONFAULTHANDLER=1

# Force IPv4
export NCCL_SOCKET_FAMILY=AF_INET


PATH=/home/.openmpi/bin:/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LD_LIBRARY_PATH=/home/.openmpi/lib:/lib/x86_64-linux-gnu:/opt/conda/lib:/usr/local/lib:/usr/local/lib:

# srun python -c "import torch; print('CUDA available:', torch.cuda.is_available())"
# srun whoami

source /opt/conda/etc/profile.d/conda.sh
conda activate lit-redpajama-sample


rm -rf lit-gpt || true
git clone https://github.com/harishvs/lit-gpt.git
cd lit-gpt
srun python /tmp/lit-gpt/pretrain/redpajama.py --devices 4 --train_data_dir /data/fsx/lit-redpajama-sample
EOD

chmod +x lit-redpajama-sample
sbatch lit-redpajama-sample