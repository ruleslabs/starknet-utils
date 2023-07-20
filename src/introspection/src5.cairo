#[starknet::contract]
mod SRC5 {
  // locals
  use rules_utils::introspection::src5;
  use rules_utils::introspection::interface;

  //
  // Storage
  //

  #[storage]
  struct Storage {
    supported_interfaces: LegacyMap<felt252, bool>
  }

  //
  // SRC5 impl
  //

  #[external(v0)]
  impl SRC5Impl of interface::ISRC5<ContractState> {
    fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
      if interface_id == interface::ISRC5_ID {
        return true;
      }
      self.supported_interfaces.read(interface_id)
    }
  }

  //
  // SRC5 Camel impl
  //

  #[external(v0)]
  impl SRC5CamelImpl of interface::ISRC5Camel<ContractState> {
    fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
      SRC5Impl::supports_interface(self, interfaceId)
    }
  }

  //
  // Internal
  //

  #[generate_trait]
  impl InternalImpl of InternalTrait {
    fn _register_interface(ref self: ContractState, interface_id: felt252) {
      self.supported_interfaces.write(interface_id, true);
    }

    fn _deregister_interface(ref self: ContractState, interface_id: felt252) {
      assert(interface_id != interface::ISRC5_ID, 'SRC5: invalid id');
      self.supported_interfaces.write(interface_id, false);
    }
  }
}
