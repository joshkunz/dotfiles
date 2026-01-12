# General Coding Principles

- Be defensive when writing code. Do not assume that inputs are correctly
  formed, and do not accept malformed inputs as valid. Prefer to produce errors
  than accept or skip invalid input. Only relax this constraint when requested.

## When Writing Tests

- Follow the Arrange -> Act -> Assert pattern for tests when possible.
- Always try to make assertions about state rather than behavior. E.g. Avoid
  counting invocations. Have test doubles track state and then assert over that.
- Always use Fake, Stub, or Spy for test double names. Avoid using mocks Generally
  and don't name all test doubles "mock".

# Preferences for Go programs

## Generally

- Avoid EVER creating empty slice literals. Prefer `var name []T` syntax
  when declaring, and use `nil` values in structures / assignments.
- Keep names concise. Avoid repetition with the package name for exported
  symbols.

## For tests

- Prefer to use `cmp.Diff` when validating test outputs.
- Prefer using `want` instead of `expected` for desired outputs. Prefer using
  `got` instead of `actual` for the output under test.
- Prefer separating error and non-error test cases into separate table-driven
  tests rather than adding a special `if err != nil` condition to the assertions.
  Name the error-specific test function with an `_Error` suffix.
- When many tests share the same setup (Arrange) step, and the setup is more than
  10 lines or so, refactor that setup into a test helper: An additional function
  that takes `t *testing.T`, calls `t.Helper()`, and then performs the setup.
- Use `t.Context()` as the default context rather than `context.Background()`.
