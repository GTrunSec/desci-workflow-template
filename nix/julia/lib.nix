{
  inputs,
  cell,
}: let
  inherit (inputs.xnlib.libs) pop;
in rec {
  _a = pop {
    name = "O";
    supers = [];
  };
  _b = pop {
    name = "O";
    supers = [_a];
  };
}
