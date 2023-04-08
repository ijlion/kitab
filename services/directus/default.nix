{ config, pkgs, ... }:

{
  # Service user used to store cms uploads.
  users.users.directus = {
    isNormalUser = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE directus WITH LOGIN PASSWORD 'secret' CREATEDB;
      CREATE DATABASE directus;
      GRANT ALL PRIVILEGES ON DATABASE directus TO directus;
    '';
  };

  services.redis.servers.directus = {
    enable = true;
    port = 6379;
    requirePass = "secret";
  };

  services.meilisearch = {
    enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };

    oci-containers = {
      backend = "podman";

      containers.directus = {
        image = "directus/directus:9.23.1";
        autoStart = true;
        ports = [ "8055:8055" ];
        volumes = [ "/home/directus/uploads:/directus/uploads" ];
        extraOptions = [ "--network=host" ];
      };
    };
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];

  services.nginx = {
    enable = true;
    virtualHosts."directus" = {
      serverName = "cms.leomonad.com";
      locations."/".proxyPass = "http://localhost:8055";
    };
  };
}
