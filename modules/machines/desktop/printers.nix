{ lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.printers) {
    services.printing = { drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ]; };

    hardware.printers = {
      ensurePrinters = [{
        description = "Home - HP OfficeJet 3830";
        name = "officejet_3830";
        deviceUri = "ipp://10.255.100.2/ipp/print";
        ppdOptions = { PageSize = "A4"; };
        model = "drv:///hp/hpcups.drv/hp-officejet_3830_series.ppd";
      }];
      ensureDefaultPrinter = "officejet_3830";
    };
  };
}
