{ pkgs, ... }: {

  systemd.user.services."onedrive" = {
    Unit = {
      Description = "Rclone OneDrive Client";
      After = [ "lockOnAutoLogin.service" ];
    };
    Install = { WantedBy = [ "hyprland-session.target" ]; };
    Service = let
      dir = "/persist/home/michel/storages/onedrive";
      rclone = "${pkgs.rclone}/bin/rclone";
      fusermount = "${pkgs.fuse}/bin/fusermount";
      sh = "${pkgs.bash}/bin/bash";
    in {
      Type = "notify";
      NotifyAccess = "exec";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      ExecStart = ''
        ${rclone} mount onedrive: ${dir} --vfs-cache-mode full --dir-cache-time 48h \
        --vfs-cache-max-age 48h --vfs-read-chunk-size 10M --vfs-read-chunk-size-limit 512M \
        --buffer-size 512M
      '';
      ExecStop = "${fusermount} -u ${dir}";
      ExecStopPost = ''
        /usr/bin/env ${sh} -c "if [ ''${SERVICE_RESULT} != success ]; then notify-send OneDrive 'Daemon failed'; fi"
      '';
      WatchdogSec = "30";
    };
  };
}
