#!/bin/bash
echo "--- NVIDIA Quadro M1200 Maintenance Tool ---"
# 1. Clear Shader Caches (The main cause of stutters)
echo "[1/3] Clearing old Shader Caches..."
# Standard location
rm -rf ~/.nv/GLCache/*
rm -rf ~/.nv/ComputeCache/*
# Steam Flatpak location
rm -rf ~/.var/app/com.valvesoftware.Steam/.nv/GLCache/*
echo "Done."

# 2. Reset GPU Hardware State
echo "[2/3] Resetting GPU to Factory Defaults..."
# This clears any stuck power states or clock offsets
sudo nvidia-smi --gpu-reset
echo "Done."

# 3. Re-apply Performance Optimizations
echo "[3/3] Re-applying High Performance Mode..."
# Enable Persistence Mode (Keeps driver in memory)
sudo nvidia-smi -pm 1
# Force Maximum Performance state
nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=1"
# Disable V-Sync at driver level for low latency
nvidia-settings -a "[gpu:0]/SyncToVBlank=0"
echo "Done."

echo "--------------------------------------------"
echo "System Cleaned! Your next game launch will rebuild"
echo "fresh shaders for maximum performance."

