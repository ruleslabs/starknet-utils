use array::ArrayTrait;

// locals
use rules_utils::introspection::interface::ISRC5_ID;
use rules_utils::introspection::interface::ISRC5Dispatcher;
use rules_utils::introspection::interface::ISRC5DispatcherTrait;
use rules_utils::introspection::interface::ISRC5CamelDispatcher;
use rules_utils::introspection::interface::ISRC5CamelDispatcherTrait;
use rules_utils::introspection::dual_src5::DualCaseSRC5;
use rules_utils::introspection::dual_src5::DualCaseSRC5Trait;
use rules_utils::tests::mocks::src5_mocks::{ SnakeSRC5Mock, CamelSRC5Mock, SnakeSRC5PanicMock, CamelSRC5PanicMock };
use rules_utils::tests::mocks::non_implementing_mock::NonImplementingMock;
use rules_utils::tests::utils;

//
// Setup
//

fn setup_snake() -> DualCaseSRC5 {
  let address = utils::deploy(class_hash: SnakeSRC5Mock::TEST_CLASS_HASH, calldata: array![]);

  DualCaseSRC5 { contract_address: address }
}

fn setup_camel() -> DualCaseSRC5 {
  let address = utils::deploy(class_hash: CamelSRC5Mock::TEST_CLASS_HASH, calldata: array![]);

  DualCaseSRC5 { contract_address: address }
}

fn setup_non_src5() -> DualCaseSRC5 {
  let address = utils::deploy(class_hash: NonImplementingMock::TEST_CLASS_HASH, calldata: array![]);

  DualCaseSRC5 { contract_address: address }
}

fn setup_src5_panic() -> (DualCaseSRC5, DualCaseSRC5) {
  let snake_address = utils::deploy(class_hash: SnakeSRC5PanicMock::TEST_CLASS_HASH, calldata: array![]);
  let camel_address = utils::deploy(class_hash: CamelSRC5PanicMock::TEST_CLASS_HASH, calldata: array![]);

  (
    DualCaseSRC5 { contract_address: snake_address },
    DualCaseSRC5 { contract_address: camel_address }
  )
}

//
// snake_case target
//

#[test]
#[available_gas(20000000)]
fn test_dual_supports_interface() {
  let dispatcher = setup_snake();

  assert(dispatcher.supports_interface(ISRC5_ID), 'Should support base interface');
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('ENTRYPOINT_NOT_FOUND', ))]
fn test_dual_no_supports_interface() {
  let dispatcher = setup_non_src5();

  dispatcher.supports_interface(ISRC5_ID);
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('Some error', 'ENTRYPOINT_FAILED', ))]
fn test_dual_supports_interface_exists_and_panics() {
  let (dispatcher, _) = setup_src5_panic();

  dispatcher.supports_interface(ISRC5_ID);
}

//
// camelCase target
//

#[test]
#[available_gas(20000000)]
fn test_dual_supportsInterface() {
  let dispatcher = setup_camel();

  assert(dispatcher.supports_interface(ISRC5_ID), 'Should support base interface');
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('Some error', 'ENTRYPOINT_FAILED', ))]
fn test_dual_supportsInterface_exists_and_panics() {
  let (_, dispatcher) = setup_src5_panic();

  dispatcher.supports_interface(ISRC5_ID);
}
