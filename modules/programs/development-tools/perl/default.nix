{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.perl;
  DevelCheckCompiler = pkgs.perlPackages.buildPerlModule {
    pname = "Devel-CheckCompiler";
    version = "0.07";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYOHEX/Devel-CheckCompiler-0.07.tar.gz";
      sha256 = "768b7697b4b8d4d372c7507b65e9dd26aa4223f7100183bbb4d3af46d43869b5";
    };
    buildInputs = with pkgs.perlPackages; [ ModuleBuildTiny ];
    meta = {
      homepage = "https://github.com/tokuhirom/Devel-CheckCompiler";
      description = "Check the compiler's availability";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  ModuleBuildXSUtil = pkgs.perlPackages.buildPerlModule {
    pname = "Module-Build-XSUtil";
    version = "0.19";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HIDEAKIO/Module-Build-XSUtil-0.19.tar.gz";
      sha256 = "9063b3c346edeb422807ffe49ffb23038c4f900d4a77b845ce4b53d97bf29400";
    };
    buildInputs = with pkgs.perlPackages; [ CaptureTiny CwdGuard FileCopyRecursiveReduced ];
    propagatedBuildInputs = [ DevelCheckCompiler ];
    meta = {
      homepage = "https://github.com/hideo55/Module-Build-XSUtil";
      description = "A Module::Build class for building XS modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  CompilerLexer = pkgs.perlPackages.buildPerlModule {
    pname = "Compiler-Lexer";
    version = "0.23";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/G/GO/GOCCY/Compiler-Lexer-0.23.tar.gz";
      sha256 = "6031ce4afebbfa4f492a274949be7b8232314e91023828c438e47981ff0a99db";
    };
    buildInputs = [ ModuleBuildXSUtil ];
    perlPreHook = "export LD=$CC";
    meta = {
      homepage = "https://github.com/goccy/p5-Compiler-Lexer";
      description = "Lexical Analyzer for Perl5";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  DevelOverrideGlobalRequire = pkgs.perlPackages.buildPerlPackage {
    pname = "Devel-OverrideGlobalRequire";
    version = "0.001";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Devel-OverrideGlobalRequire-0.001.tar.gz";
      sha256 = "0791892de3ae292af4a94e382f21db1ee88210875031851e6ea82c3410785ef9";
    };
    meta = {
      homepage = "https://metacpan.org/release/Devel-OverrideGlobalRequire";
      description = "Override CORE::GLOBAL::require safely";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  ClassRefresh = pkgs.perlPackages.buildPerlPackage {
    pname = "Class-Refresh";
    version = "0.07";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/Class-Refresh-0.07.tar.gz";
      sha256 = "e3b0035355cbb35a2aee3f223688d578946a7a7c570acd398b28cddb1fd4beb3";
    };
    buildInputs = with pkgs.perlPackages; [ TestFatal TestRequires ];
    propagatedBuildInputs = with pkgs.perlPackages; [ ClassLoad ClassUnload DevelOverrideGlobalRequire TryTiny ];
    meta = {
      homepage = "http://metacpan.org/release/Class-Refresh";
      description = "Refresh your classes during runtime";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  PerlLanguageServer = pkgs.perlPackages.buildPerlPackage {
    pname = "Perl-LanguageServer";
    version = "2.2.0";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRICHTER/Perl-LanguageServer-2.2.0.tar.gz";
      sha256 = "43a4185e3747d8d15907cdf95c5886688a3592c8fdff258e88bedfca78e9112e";
    };
    propagatedBuildInputs = with pkgs.perlPackages; [ AnyEvent AnyEventAIO ClassRefresh CompilerLexer Coro DataDump IOAIO JSON Moose PadWalker ];
    meta = {
      description = "Language Server and Debug Protocol Adapter for Perl";
      license = lib.licenses.artistic2;
    };
  };
  perlls = pkgs.perl.withPackages (p: with p; [ PerlLanguageServer ]);
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ perl ];
    }
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['perlls'].setup {
            on_attach = on_attach,
            cmd = {
              '${perlls}/bin/perl',
              '-MPerl::LanguageServer',
              '-e',
              'Perl::LanguageServer::run',
              '--',
              '--port 13603',
              '--nostdio 0',
              '--version 2.2.0',
            }
          }
        '';
      };
    })
  ]);
}
