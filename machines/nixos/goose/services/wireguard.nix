{
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/private";

      peers = [
        {
          publicKey = "mZHS9vjE3fKHMN+a2wTx4Zo0NQsWMqcUGQAaH2qQdAY=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          publicKey = "LsjFCqeOnJvjM2Xo2jUKbnHjii6Mjm5UP9qEPCVLVFg=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
        {
          publicKey = "hyZuVr+T+FD0uVYtMvTr+XMkIrcdRPhjKC+Y9zbFPFs=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
        {
          publicKey = "AzcORdSkMEKnh5dVRdsXm0UNBF6/99GkiFwQER88f2I=";
          allowedIPs = [ "10.100.0.5/32" ];
        }
        {
          publicKey = "/S12fraeoJml9vnDOtyE5DXui00pdiD7Obr36s+pLhk=";
          allowedIPs = [ "10.100.0.6/32" ];
        }
      ];
    };
  };
}
