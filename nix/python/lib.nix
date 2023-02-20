{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.inputs.xnlib.lib.attrsets) recursiveMerge;
  l = inputs.nixpkgs.lib // builtins;
in {
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
  # if x ? pyproject && (l.isAttrs x.pyproject)
  #      then (l.importTOML "${x.path}/pyproject.toml") // x.pyproject
  #      else
}
