use array::{ ArrayTrait, SpanTrait, SpanPartialEq };

// locals
use rules_utils::utils::contract_address::ContractAddressTraitExt;
use super::mocks::contract::Contract;
use super::mocks::contract::Contract::ContractTrait;
use super::utils;

fn ARR() -> Array<felt252> {
  array![111, 222, 333]
}

fn SPAN() -> Span<felt252> {
  ARR().span()
}

fn RANDO() -> starknet::ContractAddress {
  starknet::contract_address_const::<'rando'>()
}

//
// Setup
//

fn deploy_contract() -> starknet::ContractAddress {
  utils::deploy(Contract::TEST_CLASS_HASH, array![])
}

//
// Storage
//

#[test]
#[available_gas(20000000)]
fn test_felt252_span_storage() {
  let mut contract = Contract::contract_state_for_testing();

  assert(contract.get_arr().is_empty(), 'arr should be empty');

  let span = SPAN();
  contract.set_arr(span);

  assert(contract.get_arr() == span, 'arr should be SPAN()');
}

//
// Contract address
//

#[test]
#[available_gas(20000000)]
fn test_contract_address_is_deployed() {
  let random_address = RANDO();
  let contract_address = deploy_contract();

  assert(!random_address.is_deployed(), 'random is not deployed');
  assert(contract_address.is_deployed(), 'contract is deployed');
}
