{
  inputs,
  cell,
}: {
  jupyenv =
    inputs.desci.kernels.packages.mkJupyterlabEval
    ({
      pkgs,
      config,
      ...
    }: {
      nixpkgs = inputs.nixpkgs.appendOverlays [
        inputs.desci.inputs.julia2nix.overlays.default
      ];
      imports = [
        (cell.config.resolveKeys pkgs config)
        inputs.desci.kernels.jupyenvModules.quarto
      ];
      kernel.bash.data-science = {
        runtimePackages = [inputs.cells.python.packages.default];
      };
      kernel.julia.data-science = {
        julia = inputs.desci.julia.packages.julia-wrapped;
      };
    });
}
