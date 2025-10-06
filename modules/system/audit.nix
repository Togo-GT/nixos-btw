{ ... }:

{
  # =====================================
  # AUDITD CONFIGURATION (PRODUCTION-READY)
  # =====================================
  security.audit = {
    enable = true;                 # Enable auditd
    backlogLimit = 8192;           # Kernel audit backlog queue size
    failureMode = "printk";        # Valid: "silent", "printk", "panic"

    rules = [

      # ============================
      # Identity files
      # ============================
      "-w /etc/passwd -p wa -k identity"
      "-w /etc/group -p wa -k identity"
      "-w /etc/shadow -p wa -k identity"
      "-w /etc/gshadow -p wa -k identity"

      # ============================
      # System configuration
      # ============================
      "-w /etc -p wa -k etc-config"
      "-w /boot -p wa -k boot"
      "-w /etc/systemd -p wa -k systemd"

      # ============================
      # Privileged commands
      # ============================
      "-w /bin/su -p x -k privileged"
      "-w /usr/bin/sudo -p x -k privileged"
      "-w /etc/sudoers -p rw -k privileged"

      # ============================
      # Network configuration
      # ============================
      "-w /etc/hosts -p wa -k network-config"
      "-w /etc/resolv.conf -p wa -k network-config"
      "-w /etc/ssh/sshd_config -p wa -k ssh-config"

      # ============================
      # Logging and temp files (optimized)
      # ============================
      "-w /var/log -p wa -k log-files"
      "-w /var/log/journal -p wa -F auid>=1000 -F auid!=unset -k ignore"
      "-w /tmp -p wa -F auid>=1000 -F auid!=unset -k temp-files"

      # ============================
      # SSL/TLS certificates
      # ============================
      "-w /etc/ssl -p wa -k ssl-cert"

      # ============================
      # PAM configuration
      # ============================
      "-w /etc/pam.d -p wa -k pam-config"

      # ============================
      # Login/logout tracking
      # ============================
      "-w /var/run/utmp -p wa -k logins"
      "-w /var/log/wtmp -p wa -k logins"
      "-w /var/log/btmp -p wa -k failed-logins"
    ];
  };
}
