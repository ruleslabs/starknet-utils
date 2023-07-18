use array::{ ArrayTrait, SpanTrait };

// locals
use rules_utils::utils::partial_eq::SpanPartialEq;
use rules_utils::utils::contract_address::ContractAddressTraitExt;
use super::mocks::contract::Contract;
use super::mocks::contract::Contract::ContractTrait;
use super::utils;

fn ARR() -> Array<felt252> {
  let mut uri = ArrayTrait::new();

  uri.append(111);
  uri.append(222);
  uri.append(333);

  uri
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
  utils::deploy(Contract::TEST_CLASS_HASH, ArrayTrait::new())
}

//
// Partial EQ
//

#[test]
#[available_gas(20000000)]
fn test_span_partial_eq_equal() {
  let arr1 = SPAN();
  let arr2 = SPAN();

  assert(arr1 == arr2, 'arr should be equal');
}

#[test]
#[available_gas(20000000)]
fn test_span_partial_eq_not_equal() {
  let mut arr1 = ARR();
  let mut arr2 = ARR();

  arr1.append(1);
  arr2.append(2);

  assert(arr1.span() != arr2.span(), 'arr should not be equal');
}

#[test]
#[available_gas(20000000)]
fn test_span_partial_eq_empty() {
  let arr1 = ArrayTrait::<felt252>::new().span();
  let arr2 = ArrayTrait::<felt252>::new().span();

  assert(arr1 == arr2, 'arr should be equal');
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
