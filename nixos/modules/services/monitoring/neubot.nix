{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.neubot;
in {
  options = {
    services.neubot= {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Enable neubot network neutrality measurements.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.neubot;
        defaultText = "pkgs.neubot";
        example = literalExample "pkgs.neubot";
        description = ''
          The package to use for the neubot binaries.
        '';
      };

      stateDirectory = mkOption {
        type = types.str;
        default = "${stateDir}/neubot";
        example = "${stateDir}/neubot";
        description = ''
          Where measurements are stored.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.neubot = {
      description = "Network neutrality measurements";
      wantedBy = [ "default.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/neubot";
        Restart = "always";
      };
    };
  };

  meta.maintainers = [ maintainers.leenaars ];
}
