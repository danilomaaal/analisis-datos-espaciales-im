{ pkgs, lib, config, inputs, ... }:

{
  env.GREET = "devenv";

  languages.r = {
    enable = true;
    lsp = {
      enable = true;
    };
  };
  

  packages = [ 
    pkgs.rPackages.tidyverse
    pkgs.rPackages.leaflet
    pkgs.rPackages.leaflet_extras # lib marked as broken, to allow evaluation run: export NIXPKGS_ALLOW_BROKEN=1; devenv shell --impure
    pkgs.rPackages.rsconnect
    pkgs.rPackages.sf
    pkgs.rPackages.usethis
    pkgs.rPackages.ellmer
    pkgs.rPackages.mapedit
    pkgs.rPackages.osrm
    pkgs.rPackages.bivariateLeaflet
    pkgs.rPackages.sfdep
    pkgs.rPackages.htmlwidgets
    pkgs.rPackages.janitor
  ];


  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    hello         # Run scripts directly
    R --version
  '';
  
}
