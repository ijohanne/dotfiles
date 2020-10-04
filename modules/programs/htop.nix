{ pkgs, ... }:

{
  programs.htop = {
    enable = true;
    treeView = true;
    showThreadNames = true;
    detailedCpuTime = true;
    cpuCountFromZero = true;
  };
}

