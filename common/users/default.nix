{ config, pkgs, ... }:
{
  users.users.leo = {
    isNormalUser = true;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJddjClqftAtUXtUOlpW3SfRkNw0zynzrBqAgjoUPKN leomonad@protonmail.com"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = config.users.users.leo.openssh.authorizedKeys.keys;
}
