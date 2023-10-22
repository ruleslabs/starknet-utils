use array::ArrayTrait;

mod storage;
mod zeroable;
mod traits;
mod array;
mod hash;
mod contract_address;
mod unwrap_and_cast;
mod serde;
mod base64;
mod math;
mod strings;

const ENTRYPOINT_NOT_FOUND: felt252 = 'ENTRYPOINT_NOT_FOUND';

fn try_selector_with_fallback(
  target: starknet::ContractAddress,
  snake_selector: felt252,
  camel_selector: felt252,
  args: Span<felt252>
) -> starknet::SyscallResult<Span<felt252>> {
  match starknet::call_contract_syscall(target, snake_selector, args) {
    Result::Ok(ret) => Result::Ok(ret),
    Result::Err(errors) => {
      if (*errors.at(0) == ENTRYPOINT_NOT_FOUND) {
        return starknet::call_contract_syscall(target, camel_selector, args);
      } else {
        Result::Err(errors)
      }
    }
  }
}
