# Setting for backing up the important user directories, both remotely and locally.

{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      rsync
      rclone
      borgbackup
    ];
  };
}
