use rules_utils::introspection::src5::SRC5;
use rules_utils::introspection::src5::SRC5::InternalTrait;
use rules_utils::introspection::interface::{ ISRC5_ID, ISRC5 };

const OTHER_ID: felt252 = 0x12345678;

fn STATE() -> SRC5::ContractState {
  SRC5::contract_state_for_testing()
}

#[test]
#[available_gas(20000000)]
fn test_default_behavior() {
  let src5 = STATE();

  let supports_default_interface = src5.supports_interface(ISRC5_ID);
  assert(supports_default_interface, 'Should support base interface');
}

#[test]
#[available_gas(20000000)]
fn test_not_registered_interface() {
  let src5 = STATE();

  let supports_unregistered_interface = src5.supports_interface(OTHER_ID);
  assert(!supports_unregistered_interface, 'Should not support unregistered');
}

#[test]
#[available_gas(20000000)]
fn test_register_interface() {
  let mut src5 = STATE();

  src5._register_interface(OTHER_ID);
  let supports_new_interface = src5.supports_interface(OTHER_ID);
  assert(supports_new_interface, 'Should support new interface');
}

#[test]
#[available_gas(20000000)]
fn test_deregister_interface() {
  let mut src5 = STATE();

  src5._register_interface(OTHER_ID);
  src5._deregister_interface(OTHER_ID);
  let supports_old_interface = src5.supports_interface(OTHER_ID);
  assert(!supports_old_interface, 'Should not support interface');
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('SRC5: invalid id', ))]
fn test_deregister_default_interface() {
  let mut src5 = STATE();

  src5._deregister_interface(ISRC5_ID);
}
