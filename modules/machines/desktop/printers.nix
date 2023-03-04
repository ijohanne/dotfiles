{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.printers) {
    services.printing = { drivers = with pkgs; [ cnijfilter2 cups-filters ]; };
    hardware.printers = {
      ensurePrinters = [{
        description = "Home - Brother MFC-L3770CDW";
        location = "Home";
        name = "Brother_Home";
        deviceUri = "ipp://brother-hallway.est.unixpimps.net/ipp";
        ppdOptions = { PageSize = "A4"; Media = "A4"; };
        #model = "everywhere";
        model = "drv:///cupsfilters.drv/pwgrast.ppd";
      }
    {
        description = "Home - Canon PIXMA G600";
        location = "Home";
        name = "Canon_Home";
        deviceUri = "ipp://canon-hallway.est.unixpimps.net/ipp";
        ppdOptions = { PageSize = "A4"; Media = "A4"; };
        model = "canong600.ppd";
      }];
      ensureDefaultPrinter = "Brother_Home";
    };
  };
}
