{ pkgs, lib, config, inputs, ... }:

{
  env.GREET = "devenv";

  languages.r = {
    enable = true;
    lsp = {
      enable = true;
    };
  };
  

  packages = with pkgs; [
    rPackages.tidyverse
    rPackages.leaflet
    rPackages.leaflet_extras # lib marked as broken, to allow evaluation run: export NIXPKGS_ALLOW_BROKEN=1; devenv shell --impure
    rPackages.rsconnect
    rPackages.sf
    rPackages.usethis
    rPackages.ellmer
    rPackages.mapedit
    rPackages.osrm
    rPackages.bivariateLeaflet
    rPackages.sfdep
    rPackages.htmlwidgets
    rPackages.janitor
    rPackages.cowplot
  ];


  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    hello         # Run scripts directly
    R --version
  '';
  
}
