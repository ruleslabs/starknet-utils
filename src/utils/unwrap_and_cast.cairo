use core::array::ArrayTrait;
use array::SpanTrait;
use option::OptionTrait;
use starknet::{ Felt252TryIntoContractAddress, SyscallResultTrait };
use traits::TryInto;

// locals
use super::traits::Felt252TryIntoBool;

trait UnwrapAndCast<T> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> T;
}

impl UnwrapAndCastBool of UnwrapAndCast<bool> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> bool {
    (*self.unwrap_syscall().at(0)).try_into().unwrap()
  }
}

impl UnwrapAndCastContractAddress of UnwrapAndCast<starknet::ContractAddress> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> starknet::ContractAddress {
    (*self.unwrap_syscall().at(0)).try_into().unwrap()
  }
}

impl UnwrapFelt of UnwrapAndCast<felt252> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> felt252 {
    *self.unwrap_syscall().at(0)
  }
}

impl UnwrapAndCastU8 of UnwrapAndCast<u8> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> u8 {
    (*self.unwrap_syscall().at(0)).try_into().unwrap()
  }
}

impl UnwrapAndCastU32 of UnwrapAndCast<u32> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> u32 {
    (*self.unwrap_syscall().at(0)).try_into().unwrap()
  }
}

impl UnwrapAndCastU256 of UnwrapAndCast<u256> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> u256 {
    let unwrapped = self.unwrap_syscall();
    u256 {
      low: (*unwrapped.at(0)).try_into().unwrap(),
      high: (*unwrapped.at(1)).try_into().unwrap(),
    }
  }
}

impl UnwrapAndCastSpanFelt252 of UnwrapAndCast<Span<felt252>> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> Span<felt252> {
    let mut unwrapped = self.unwrap_syscall();

    let mut ret = ArrayTrait::<felt252>::new();
    let mut i: usize = 0;

    // pop length
    unwrapped.pop_front();

    loop {
      match unwrapped.pop_front() {
        Option::Some(e) => {
          ret.append(*e);
        },
        Option::None(_) => {
          break;
        },
      };
    };

    ret.span()
  }
}

impl UnwrapAndCastSpanU256 of UnwrapAndCast<Span<u256>> {
  fn unwrap_and_cast(self: starknet::SyscallResult<Span<felt252>>) -> Span<u256> {
    let unwrapped = self.unwrap_syscall();

    let mut ret = ArrayTrait::<u256>::new();
    let mut i: usize = 1; // skip res length

    loop {
      if (i >= unwrapped.len()) {
        break;
      }

      ret.append(
        u256 {
          low: (*unwrapped.at(i)).try_into().unwrap(),
          high: (*unwrapped.at(i + 1)).try_into().unwrap(),
        }
      );

      i += 2;
    };

    ret.span()
  }
}
