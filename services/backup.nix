# services/backup.nix
# Automated backup system with BorgBackup
{ pkgs, ... }:

{
  # ===== BORGBACKUP CONFIGURATION =====
  services.borgbackup = {
    jobs = {
      # Daily system backup
      "system-backup" = {
        paths = [
          "/home/togo-gt/Documents"
          "/home/togo-gt/Downloads"
          "/home/togo-gt/Pictures"
          "/home/togo-gt/Videos"
          "/home/togo-gt/Sync"
        ];

        exclude = [
          # Exclude cache and temporary files
          "*/Cache/*"
          "*/cache/*"
          "*/tmp/*"
          "*/temp/*"
          "*.tmp"
          "*.temp"

          # Exclude virtual environments
          "*/venv/*"
          "*/virtualenv/*"
          "*/node_modules/*"

          # Exclude large build directories
          "*/target/*"  # Rust
          "*/build/*"   # General build
          "*/dist/*"    # Python distributions
        ];

        # Backup repository location (change to your external drive/remote)
        repo = "/backup/borg-repo";

        # Encryption (set your own password)
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /home/togo-gt/.backup-password";
        };

        # Compression and retention
        compression = "auto,zstd";
        prune.keep = {
          daily = 7;
          weekly = 4;
          monthly = 6;
        };

        # Schedule - run daily at 2 AM
        startAt = "daily";

        # Pre/post backup commands
        preHook = ''
          echo "Starting backup at $(date)"
          ${pkgs.notify-send}/bin/notify-send "Backup Started" "System backup is starting..."
        '';

        postHook = ''
          echo "Backup completed at $(date)"
          ${pkgs.notify-send}/bin/notify-send "Backup Complete" "System backup finished successfully"
        '';
      };
    };
  };

  # ===== ADDITIONAL BACKUP TOOLS =====
  environment.systemPackages = with pkgs; [
    # Backup verification tools
    borgbackup  # Already in your packages, but explicitly listed
    restic      # Alternative backup solution
    duplicity   # Encrypted backup
  ];

  # ===== BACKUP SCRIPT FOR MANUAL USE =====
  environment.etc."backup-scripts/system-backup.sh" = {
    text = ''
      #!/bin/bash
      # Manual backup script
      echo "🚀 Starting manual system backup..."

      # Create backup with timestamp
      BACKUP_NAME="manual-$(date +%Y%m%d-%H%M%S)"

      # Run borg backup
      borg create --stats --progress \
        /backup/borg-repo::"$BACKUP_NAME" \
        /home/togo-gt/Documents \
        /home/togo-gt/Pictures \
        /home/togo-gt/Sync

      echo "✅ Backup completed: $BACKUP_NAME"
    '';
    mode = "0755";
  };
}
