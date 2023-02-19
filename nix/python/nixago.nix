{
  inputs,
  cell,
}:
builtins.mapAttrs (_: inputs.std.lib.dev.mkNixago) {
  prefectPoetry = {
    data = inputs.dataflow2nix.prefect.packages.prefect.passthru.pyproject;
    output = "./nix/python/packages/pyproject.toml";
    format = "toml";
    hook.mode = "copy";
  };
}
