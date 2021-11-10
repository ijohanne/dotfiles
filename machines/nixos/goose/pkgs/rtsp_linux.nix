{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "rtsp-linux-${version}-${kernel.version}";
  version = "5.3";

  src = fetchFromGitHub {
    owner = "maru-sama";
    repo = "rtsp-linux";
    sha256 = "0p3c7nssl6323d50c3gqj97s8v4r4hlppsdj3lw3b0v7gidailf1";
    rev = "475af0aa62dc30f1b823126eceed4eb32de52e5b";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
  '';

  patches = [ ./rtsp_linux.patch ];

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/net/ipv4/netfilter"
  ];

  meta = with lib; {
    description = "A kernel module for rtsp conn tracking";
    platforms = platforms.linux;
  };
}
