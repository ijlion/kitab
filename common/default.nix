{ ... }:

{
  imports = [
    ./users
  ];

  # To delete all files in /tmp during boot.
  boot.cleanTmpDir = true;

  # To detect files in the store that have identical contents,
  # and replaces them with hard links to a single copy.
  nix.settings.auto-optimise-store = true;

  # To limit the systemd journal to 100 MB of disk or the
  # last 7 days of logs, whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';
}
