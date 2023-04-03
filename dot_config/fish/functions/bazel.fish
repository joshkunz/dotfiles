# Defined in - @ line 1
function bazel --wraps=bazelisk --description 'alias bazel=bazelisk'
  bazelisk  $argv;
end
