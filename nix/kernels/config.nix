{
  inputs,
  cell,
}: let
  inherit (inputs) std self nixpkgs;

  l = nixpkgs.lib // builtins;
  jupyenvTOML = l.importTOML ((std.incl self ["jupyenv.toml"]) + "/jupyenv.toml");
in {
  resolveKeys = pkgs: config: let
    genPkgs = str: args: (l.getAttrFromPath (l.splitString ["."] str) args);
    mapArgPkgs = v: ps: l.flatten (map (x: genPkgs x ps) v);
    genNixpkgs = path: l.getAttrFromPath path pkgs;
    mapNixpkgs = v: p: l.flatten (map (x: genPkgs x (genNixpkgs p)) v);
    mapPythonKernels =
      l.mapAttrs (
        n: v:
          v
          // {
            poetryEnv =
              inputs.cells.python.lib.nixpkgs.poetry2nix.mkPoetryEnv
              (
                inputs.cells.python.config.poetryEnvArgs
                // {
                  groups =
                    if config.kernel.python.${n}.groups == ["dev"]
                    then ["jupyenv"]
                    else config.kernel.python.${n}.groups ++ ["jupyenv"];
                }
              );
          }
      )
      jupyenvTOML.kernel.python;
  in
    l.mapAttrsRecursive (
      p: v:
        if (l.last p) == "extraPackages"
        then (mapArgPkgs v)
        else if (l.last p) == "runtimePackages"
        then mapNixpkgs v []
        else if (l.last p) == "extraRPackages"
        then mapArgPkgs v
        else v
    )
    # jupyenvTOML;
    (l.recursiveUpdate jupyenvTOML {kernel.python = mapPythonKernels;});
}
