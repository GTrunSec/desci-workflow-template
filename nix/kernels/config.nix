{
  inputs,
  cell,
}: let
  inherit (inputs) std self nixpkgs;

  l = nixpkgs.lib // builtins;
  jupyenvTOML = l.importTOML ((std.incl self ["jupyenv.toml"]) + "/jupyenv.toml");
in {
  resolveKeys = pkgs: let
    genPkgs = str: args: (l.getAttrFromPath (l.splitString ["."] str) args);
    mapPoetry = v: ps: l.flatten (map (x: genPkgs x ps) v);
    mapNixpkgs = v: l.flatten (map (x: genPkgs x pkgs) v);
    mapPythonKernels = l.mapAttrs (_: v: v // inputs.cells.python.config.poetryEnvArgs) jupyenvTOML.kernel.python;
  in
    l.mapAttrsRecursive (
      p: v:
        if (l.last p) == "extraPackages"
        then (mapPoetry v)
        else if (l.last p) == "runtimePackages"
        then mapNixpkgs v
        else v
    )
    jupyenvTOML;
  # (l.recursiveUpdate jupyenvTOML {kernel.python = mapPythonKernels;});
}
