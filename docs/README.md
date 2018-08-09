# Kimlic application
[![Build Status](https://travis-ci.com/Kimlic/kimlic-elixir.svg?token=gBEogjXajqrbo6djzwm2&branch=develop)](https://travis-ci.com/Kimlic/kimlic-elixir)

For Docker environment configuration read
[ENVIRONMENT.md](https://github.com/Kimlic/kimlic-elixir/blob/develop/docs/ENVIRONMENT.md)

## Travis CI

For CI and automatic semantic versioning repository requires proper commit message.

Use next prefix in commit message:
 - `[patch]` - increment PATCH version (0.1.0 -> 0.1.1)
 - `[minor]` - increment MINOR version (0.1.0 -> 0.2.0)
 - `[major]` - increment MAJOR version (0.1.0 -> 1.0.0)
 
In case of invalid branch name Travis CI fails

## Quorum

Local configuration:
- Clone smart contracts [repo](https://github.com/Kimlic/quorum.smart-contracts/)
- `cd quorum.smart-contracts`
- run truffle migration `truffle migrate --compile --reset --network KIM1` 
- found address for deployed KimlicContextStorage contract
- set KimlicContextStorage address to quorum config: `:quorum, context_storage_address: "%ADDRESS%"`
- open file `quorum.smart-contracts/PartiesConfig.json`
- found Kimlic AP (`"Kimlic":{"address":"0xfc1a3f6fd7876d37a677e02de695099d1de12c95","password":"Kimlicp@ssw0rd"}`) 
- set `:quorum, kimlic_ap_address: "%Kimlic.address%"`
- set `:quorum, kimlic_ap_password: "%Kimlic.password%"`
- profit

## Integration tests
- Create `test_integration.priv.exs` from `test_integration.example.exs` in `quorum/config`
- Set quorum credentials in `test_integration.priv.exs`
- Run `mix clean` in project root directory
- Run test `mix test --only integration`
