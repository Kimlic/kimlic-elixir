mix test --exclude pending
mix coveralls --exclude pending
mix credo --strict
mix format --check-formatted
mix dialyzer --format short --halt-exit-status
