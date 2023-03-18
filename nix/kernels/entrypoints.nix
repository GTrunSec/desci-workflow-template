{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.std-ext.writers.lib) writeShellApplication;

  l = inputs.nixpkgs.lib // builtins;
in {
  jupyenv = writeShellApplication {
    name = "mkQuarto";
    runtimeInputs = [cell.packages.jupyenv.config.build];
    text = ''
      jupyter "$@"
    '';
  };
}
