{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  l = inputs.nixpkgs.lib // builtins;
in {
  default = {...}: {
    commands = [
      {
        name = "jupyenv";
        command = ''
          nix run $PRJ_ROOT#${nixpkgs.system}.kernels.entrypoints.jupyenv "$@"
        '';
        help = "Run wrapped jupyenv";
      }
      {
        name = "quarto";
        command = ''
          nix run $PRJ_ROOT#${nixpkgs.system}.kernels.packages.jupyenv.config.quartoEnv "$@"
        '';
        help = "Run wrapped quarto";
      }
    ];
  };
}
