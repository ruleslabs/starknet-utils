#[starknet::contract]
mod Contract {
  use array::{ ArrayTrait, SpanTrait };

  // locals
  use rules_utils::utils::storage::StoreSpanFelt252;

  //
  // Storage
  //

  #[storage]
  struct Storage {
    _arr: Span<felt252>
  }

  //
  // Constructor
  //

  #[constructor]
  fn constructor(ref self: ContractState) {}

  //
  // Contract impl
  //

  #[generate_trait]
  #[external(v0)]
  impl ContractImpl of ContractTrait {
    fn get_arr(self: @ContractState) -> Span<felt252> {
      self._arr.read()
    }

    fn set_arr(ref self: ContractState, arr_: Span<felt252>) {
      self._arr.write(arr_);
    }
  }
}
