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
          ${cell.packages.jupyenv.config.build}/bin/jupyter "$@"
          # nix run $PRJ_ROOT#${nixpkgs.system}.kernels.entrypoints.jupyenv "$@"
        '';
        help = "Run wrapped jupyenv";
      }
      {
        name = "jupyter";
        command = ''
          2>/dev/null ${inputs.cells.kernels.packages.jupyenv.config.build}/bin/jupyter "$@"
        '';
      }
      {
        name = "quarto";
        command = ''
          ${l.getExe cell.packages.jupyenv.config.quartoEnv} "$@"
          # nix run $PRJ_ROOT#${nixpkgs.system}.kernels.packages.jupyenv.config.quartoEnv "$@"
        '';
        help = "Run wrapped quarto";
      }
    ];
  };
}
