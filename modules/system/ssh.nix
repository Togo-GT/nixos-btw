{ ... }:

let
  # Secure algorithm lists
  secureCiphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
  secureKex = "curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256";
  secureMACs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512";
  secureHostKeyAlgorithms = "ssh-ed25519,rsa-sha2-512,rsa-sha2-256";
in
{
  services.openssh = {
    enable = true;
    openFirewall = false;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "togo-gt" ];

      MaxAuthTries = 3;
      LoginGraceTime = "30s";
      MaxSessions = 3;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 0;
    };

    # Hardened extraConfig
    extraConfig = ''
      HostKeyAlgorithms ${secureHostKeyAlgorithms}
      Ciphers ${secureCiphers}
      KexAlgorithms ${secureKex}
      MACs ${secureMACs}

      AllowTcpForwarding no
      X11Forwarding no
      PermitEmptyPasswords no
      AllowAgentForwarding no
      StreamLocalBindUnlink yes

      LogLevel VERBOSE
      Banner none
      UseDNS no
      TCPKeepAlive yes
    '';

    # Structured host keys
    hostKeys = [
      { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
      { path = "/etc/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
    ];
  };

  # Automatically create missing host keys with correct permissions
  systemd.tmpfiles.rules = [
    "f /etc/ssh/ssh_host_ed25519_key 0600 root root -"
    "f /etc/ssh/ssh_host_rsa_key 0600 root root -"
  ];

  # Ensure keys exist at first boot
  systemd.services."ssh-keygen-once" = {
    description = "Generate SSH host keys if missing";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = ''
      [ ! -f /etc/ssh/ssh_host_ed25519_key ] && ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
      [ ! -f /etc/ssh/ssh_host_rsa_key ] && ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    '';
  };
}
