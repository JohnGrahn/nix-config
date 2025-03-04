# Brave browser configuration module
{ config, lib, pkgs, ... }:

{
  imports = [ ./extensions.nix ./settings.nix ./flags.nix ./theme.nix ];
}
