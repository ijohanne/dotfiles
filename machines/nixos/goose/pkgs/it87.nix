{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "ti87-${version}-${kernel.version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "frankcrawford";
    repo = "it87";
    sha256 = "137njmla1v7kdymg9yr2c0mbs7dsa2yk2qwnn0i2c8vf8b6jrmhp";
    rev = "4daf769cff599578c9c3994ea47999ab5af2af29";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon"
  ];

  meta = with lib; {
    description = "A kernel module for ti87";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
