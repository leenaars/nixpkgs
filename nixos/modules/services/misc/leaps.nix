{ config, pkgs, lib, ... } @ args:

with lib;

let
  cfg = config.services.leaps;
  stateDir = "/var/lib/leaps/";
in
{
  options = {
    services.leaps = {
      enable = mkEnableOption "leaps";
      port = mkOption {
        type = types.int;
        default = 8080;
        description = "A port where leaps listens for incoming http requests";
      };
      address = mkOption {
        default = "";
        type = types.str;
        example = "127.0.0.1";
        description = "Hostname or IP-address to listen to. By default it will listen on all interfaces.";
      };
      path = mkOption {
        default = "/";
        type = types.path;
        description = "Subdirectory used for reverse proxy setups";
      };
      safe = mkOption {
        default = true;
        type = types.bool;
        description = "Do not write changes directly to local files. Instead, store them in a temporary file that can be committed afterwards with the --commit flag";
      };
      commands = mkOption {
        default = [];
        type = types.listOf types.str;
        example = [ "make build" "make test" ];
        description = "Set commands that can be executed from the web UI";
      };
    };
  };

  config = mkIf cfg.enable {
    users = {
      users.leaps = {
        uid             = config.ids.uids.leaps;
        description     = "Leaps server user";
        group           = "leaps";
        home            = stateDir;
        createHome      = true;
      };

      groups.leaps = {
        gid = config.ids.gids.leaps;
      };
    };

    systemd.services.leaps = {
      description   = "leaps service";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig = {
        User = "leaps";
        Group = "leaps";
        Restart = "on-failure";
        WorkingDirectory = stateDir;
        PrivateTmp = true;
        ExecStart = ''${pkgs.leaps.bin}/bin/leaps -path ${toString cfg.path} -address ${cfg.address}:${toString cfg.port} ${optionalString cfg.safe "-safe"} ${optionalString (cfg.commands != []) "concatStringsSep '-cmd ' cfg.commands" } '';
      };
    };
  };
}
