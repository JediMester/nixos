{ config, pkgs, lib, ... }:

let
  cfg = config.customFirewall;
in {
  options.customFirewall = {
    enable = lib.mkEnableOption "Enable custom nftables firewall";

    allowedTCPPorts = lib.mkOption {
      type = with lib.types; listOf int;
      default = [];
      description = "List of allowed TCP ports.";
    };

    allowedUDPPorts = lib.mkOption {
      type = with lib.types; listOf int;
      default = [];
      description = "List of allowed UDP ports.";
    };

    portRangesUDP = lib.mkOption {
      type = with lib.types; listOf (attrsOf int);
      default = [];
      description = "UDP port ranges. Example: [ { from = 4000; to = 4010; } ]";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.nftables.enable = true;
    networking.nftables.ruleset = ''
      table inet filter {
        chain input {
          type filter hook input priority 0;
          
          # Allow loopback
          iifname "lo" accept
          
          # Allow established/related connections
          ct state established,related accept

          # Allow configured TCP ports
          ${lib.concatStringsSep "\n" (map (port: "tcp dport ${toString port} accept") cfg.allowedTCPPorts)}

          # Allow configured UDP ports
          ${lib.concatStringsSep "\n" (map (port: "udp dport ${toString port} accept") cfg.allowedUDPPorts)}

          # Allow configured UDP port ranges
          ${lib.concatStringsSep "\n" (map (range: "udp dport ${toString range.from}-${toString range.to} accept") cfg.portRangesUDP)}

          # Drop everything else
          counter drop
        }
      }
    '';
  };
}
