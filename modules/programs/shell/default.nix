{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.shell;
in {
  options.dotfiles.shell = {
    du-dust.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable du-dust app";
    };
    exa.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable exa app";
    };
    starship.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable starship app";
    };
    tokei.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable tokei app";
    };
    procs.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable procs app";
    };
    gpg-agent.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable gpg-agent app";
    };
    fish.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable fish app";
    };
    imagemagick.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable imagemagick app";
    };
    ldns.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable ldns app";
    };
    lsof.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable lsof app";
    };
    mkpasswd.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable mkpasswd app";
    };
    mtr.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable mtr app";
    };
    nixfmt.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable nixfmt app";
    };
    ripgrep.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable ripgrep app";
    };
    whois.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable whois app";
    };
    bind.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable bind app";
    };
    tcpdump.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable tcpdump app";
    };
    bat.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable bat app";
    };
    fd.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable fd app";
    };
    fzf.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable fzf app";
    };
    zoxide.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable zoxide app";
    };
    tmux.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable tmux app";
    };
    onefetch.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable onefetch app";
    };
    bottom.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable bottom app";
    };
    nix-linter.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable nix-linter app";
    };
    shfmt.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable shfmt app";
    };
    shellcheck.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable shellcheck app";
    };
    lfs.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable lfs app";
    };
    broot.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable broot app";
    };
    jq.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable jq app";
    };
    rq.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable rq app";
    };

    httpie.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable httpie app";
    };
    tig.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable tig app";
    };
    nix-tree.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable nix-tree app";
    };
    pueue.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable pueue app";
    };
    keybase.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable keybase apps";
    };

  };

  imports = [
    ./du-dust
    ./exa
    ./starship
    ./tokei
    ./procs
    ./gpg-agent
    ./fish
    ./imagemagick
    ./ldns
    ./lsof
    ./mkpasswd
    ./mtr
    ./nixfmt
    ./ripgrep
    ./whois
    ./bind
    ./tcpdump
    ./bat
    ./fd
    ./fzf
    ./zoxide
    ./tmux
    ./onefetch
    ./bottom
    ./nix-linter
    ./shfmt
    ./shellcheck
    ./lfs
    ./broot
    ./jq
    ./rq
    ./httpie
    ./tig
    ./nix-tree
    ./pueue
    ./keybase
  ];

  config = mkIf (cfg.enable) {
    dotfiles.shell.du-dust.enable = true;
    dotfiles.shell.exa.enable = true;
    dotfiles.shell.starship.enable = true;
    dotfiles.shell.tokei.enable = true;
    dotfiles.shell.procs.enable = true;
    dotfiles.shell.fish.enable = true;
    dotfiles.shell.imagemagick.enable = true;
    dotfiles.shell.ldns.enable = true;
    dotfiles.shell.lsof.enable = true;
    dotfiles.shell.mkpasswd.enable = true;
    dotfiles.shell.mtr.enable = true;
    dotfiles.shell.nixfmt.enable = true;
    dotfiles.shell.ripgrep.enable = true;
    dotfiles.shell.whois.enable = true;
    dotfiles.shell.bind.enable = true;
    dotfiles.shell.tcpdump.enable = true;
    dotfiles.shell.bat.enable = true;
    dotfiles.shell.fd.enable = true;
    dotfiles.shell.fzf.enable = true;
    dotfiles.shell.zoxide.enable = true;
    dotfiles.shell.tmux.enable = true;
    dotfiles.shell.onefetch.enable = true;
    dotfiles.shell.bottom.enable = true;
    dotfiles.shell.nix-linter.enable = true;
    dotfiles.shell.shfmt.enable = true;
    dotfiles.shell.shellcheck.enable = true;
    dotfiles.shell.lfs.enable = true;
    dotfiles.shell.broot.enable = true;
    dotfiles.shell.jq.enable = true;
    dotfiles.shell.rq.enable = true;
    dotfiles.shell.httpie.enable = true;
    dotfiles.shell.tig.enable = true;
    dotfiles.shell.nix-tree.enable = true;
    dotfiles.shell.pueue.enable = true;
  };

}

