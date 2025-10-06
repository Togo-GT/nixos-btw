{ ... }:

{
  services.journald.extraConfig = ''
    SystemMaxUse=1G
    SystemMaxFileSize=100M
    MaxRetentionSec=1week
    ForwardToSyslog=no
    Compress=yes
  '';
}
