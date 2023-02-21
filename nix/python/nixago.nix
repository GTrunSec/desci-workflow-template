{
  inputs,
  cell,
}:
builtins.mapAttrs (_: inputs.std.lib.dev.mkNixago) {
  pyproject = {
    data = cell.config.poetry.pyproject;
    output = "./pyproject.toml";
    format = "toml";
    hook.mode = "copy";
  };
}
