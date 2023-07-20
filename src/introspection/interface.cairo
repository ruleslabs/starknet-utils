
const ISRC5_ID: felt252 = 0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055;

#[starknet::interface]
trait ISRC5<TContractState> {
  fn supports_interface(self: @TContractState, interface_id: felt252) -> bool;
}

#[starknet::interface]
trait ISRC5Camel<TContractState> {
  fn supportsInterface(self: @TContractState, interfaceId: felt252) -> bool;
}
