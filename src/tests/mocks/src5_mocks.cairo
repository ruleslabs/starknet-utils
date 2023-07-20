use rules_utils::introspection::src5::SRC5;

#[starknet::contract]
mod SnakeSRC5Mock {
  //locals
  use rules_utils::introspection::interface::ISRC5;

  #[storage]
  struct Storage {}

  #[external(v0)]
  fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
    let src5 = super::SRC5::unsafe_new_contract_state();

    src5.supports_interface(:interface_id)
  }
}

#[starknet::contract]
mod CamelSRC5Mock {
  //locals
  use rules_utils::introspection::interface::ISRC5Camel;

  #[storage]
  struct Storage {}

  #[external(v0)]
  fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
    let src5 = super::SRC5::unsafe_new_contract_state();

    src5.supportsInterface(:interfaceId)
  }
}

#[starknet::contract]
mod SnakeSRC5PanicMock {
  #[storage]
  struct Storage {}

  #[external(v0)]
  fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
    panic_with_felt252('Some error');
    false
  }
}

#[starknet::contract]
mod CamelSRC5PanicMock {
  #[storage]
  struct Storage {}

  #[external(v0)]
  fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
    panic_with_felt252('Some error');
    false
  }
}
