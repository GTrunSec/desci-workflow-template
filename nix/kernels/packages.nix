{
  inputs,
  cell,
}: {
  jupyenv =
    inputs.desci.kernels.packages.mkJupyterlabEval
    ({pkgs, ...}: {
      nixpkgs = inputs.nixpkgs.appendOverlays [
        inputs.desci.inputs.julia2nix.overlays.default
      ];
      imports = [
        (cell.config.resolveKeys pkgs)
        inputs.desci.kernels.jupyenvModules.quarto
      ];
      # kernel.python.data-science = inputs.cells.python.config.poetryEnvArgs;
    });
}
