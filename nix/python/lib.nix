{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.inputs.xnlib.lib.attrsets) recursiveMerge;
  l = inputs.nixpkgs.lib // builtins;
in {
  nixpkgs = inputs.nixpkgs.appendOverlays [
    inputs.desci.inputs.jupyenv.inputs.poetry2nix.overlay
  ];

  mergePoetryEnv = list: {
    overrides = map (x:
      if (x ? overrides && x.overrides == false)
      then (_:_: {})
      else import "${x.path}/overrides.nix")
    list;
    pyproject =
      recursiveMerge
      (map (x:
        if (x ? pyproject && x.pyproject == false)
        then {}
        else l.importTOML "${x.path}/pyproject.toml")
      list);
  };
  a = l.makeOverridable ({...} @ attrs:
    {
      defaultApp = "d";
    }
    // attrs) {};
}
