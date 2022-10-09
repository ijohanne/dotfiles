{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.printers) {
    services.printing = { drivers = with pkgs; [ cnijfilter2 cups-filters ]; };
    hardware.printers = {
      ensurePrinters = [{
        description = "Home - Brother MFC-L3770CDW";
        location = "Home";
        name = "Brother_Home";
        deviceUri = "ipp://10.255.100.230/ipp";
        ppdOptions = { PageSize = "A4"; Media = "A4"; };
        #model = "everywhere";
        model = "drv:///cupsfilters.drv/pwgrast.ppd";
      }];
      ensureDefaultPrinter = "Brother_Home";
    };
  };
}
