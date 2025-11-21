# services/backup.nix
# Automated backup system with BorgBackup
{ ... }:

{
  # ===== BORGBACKUP CONFIGURATION =====
  services.borgbackup.jobs = {
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
    };
  };
}
