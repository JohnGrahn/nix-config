# Brave browser flags configuration
{ config, lib, pkgs, ... }:

{
  # Add configuration for Brave flags (still needed since these are Brave-specific)
  xdg.configFile."brave-flags.conf" = {
    text = ''
      # Brave browser flags configuration
      # Add these flags manually in brave://flags
      
      # Enable Wayland support
      --ozone-platform-hint=auto
      --enable-features=UseOzonePlatform
      
      # Hardware acceleration
      --enable-accelerated-video-decode
      --enable-gpu-rasterization
      --enable-zero-copy
      
      # Smooth scrolling
      --enable-smooth-scrolling
      
      # Privacy features
      --fingerprinting-canvas-image-data-noise
      --reduce-user-agent
      
      # Additional performance improvements
      --ignore-gpu-blocklist
      --enable-quic
      --enable-parallel-downloading
      --enable-webrtc-pipewire-capturer
    '';
  };
} 