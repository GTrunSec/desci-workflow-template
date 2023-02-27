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
        '';
      }
      {
        name = "quarto";
        command = ''
          ${l.getExe cell.packages.jupyenv.config.quartoEnv} "$@"
        '';
      }
    ];
    packages = [
      inputs.cells.python.packages.default
    ];
  };
}
