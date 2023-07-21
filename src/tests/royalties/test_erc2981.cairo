// locals
use rules_utils::royalties::erc2981::ERC2981;
use rules_utils::royalties::erc2981::ERC2981::InternalTrait as ERC2981InternalImpl;
use rules_utils::royalties::interface::IERC2981;

fn OTHER() -> starknet::ContractAddress {
  starknet::contract_address_const::<20>()
}

fn ROYALTIES_RECEIVER() -> starknet::ContractAddress {
  starknet::contract_address_const::<'royalties receiver'>()
}

fn ROYALTIES_PERCENTAGE() -> u16 {
  500 // 5%
}

//
// Setup
//

fn setup() -> ERC2981::ContractState {
  let mut erc2981_self = ERC2981::unsafe_new_contract_state();

  let royalties_receiver = ROYALTIES_RECEIVER();
  let royalties_percentage = ROYALTIES_PERCENTAGE();

  erc2981_self._set_royalty_percentage(new_percentage: royalties_percentage);
  erc2981_self._set_royalty_receiver(new_receiver: royalties_receiver);

  erc2981_self
}

//
// Tests
//

#[test]
#[available_gas(20000000)]
fn test_royalty_info_amount_without_reminder() {
  let mut erc2981 = setup();

  let (_, royalty_amount) = erc2981.royalty_info(token_id: 0, sale_price: 100);
  assert(royalty_amount == 5, 'Invalid royalty amount');

  let (_, royalty_amount) = erc2981.royalty_info(token_id: 0, sale_price: 20);
  assert(royalty_amount == 1, 'Invalid royalty amount');

  let (_, royalty_amount) = erc2981.royalty_info(token_id: 0, sale_price: 0xfffffff0);
  assert(royalty_amount == 0xccccccc, 'Invalid royalty amount');

  let (_, royalty_amount) = erc2981.royalty_info(token_id: 0, sale_price: 0);
  assert(royalty_amount == 0, 'Invalid royalty amount');
}

#[test]
#[available_gas(20000000)]
fn test_royalty_info_amount_with_reminder() {
  let mut erc2981 = setup();

  let  royalties_receiver = ROYALTIES_RECEIVER();

  let (_, royalty_amount) = erc2981.royalty_info(token_id: 0, sale_price: 101);
  assert(royalty_amount == 6, 'Invalid royalty amount');

  let (_, royalty_amount) = erc2981.royalty_info(token_id: 0, sale_price: 119);
  assert(royalty_amount == 6, 'Invalid royalty amount');

  let (_, royalty_amount) = erc2981.royalty_info(token_id: 0, sale_price: 19);
  assert(royalty_amount == 1, 'Invalid royalty amount');

  let (_, royalty_amount) = erc2981.royalty_info(token_id: 0, sale_price: 1);
  assert(royalty_amount == 1, 'Invalid royalty amount');
}

#[test]
#[available_gas(20000000)]
fn test_royalty_info_receiver() {
  let mut erc2981 = setup();

  let  royalties_receiver = ROYALTIES_RECEIVER();

  let (receiver, _) = erc2981.royalty_info(token_id: 100, sale_price: 100);
  assert(receiver == royalties_receiver, 'Invalid royalty receiver');

  let (receiver, _) = erc2981.royalty_info(token_id: 20, sale_price: 20);
  assert(receiver == royalties_receiver, 'Invalid royalty receiver');

  let (receiver, _) = erc2981.royalty_info(token_id: 0x42, sale_price: 0x42);
  assert(receiver == royalties_receiver, 'Invalid royalty receiver');
}

#[test]
#[available_gas(20000000)]
fn test_set_royalty_receiver() {
  let mut erc2981 = setup();

  let new_royalties_receiver = OTHER();

  erc2981._set_royalty_receiver(new_receiver: new_royalties_receiver);

  let (receiver, _) = erc2981.royalty_info(token_id: 0x42, sale_price: 0x42);
  assert(receiver == new_royalties_receiver, 'Invalid royalty receiver');
}

#[test]
#[available_gas(20000000)]
fn test_set_royalty_percentage_50() {
  let mut erc2981 = setup();

  erc2981._set_royalty_percentage(new_percentage: 5000); // 50%

  let (_, royalties_amount) = erc2981.royalty_info(token_id: 0x42, sale_price: 0x42);
  assert(royalties_amount == 0x21, 'Invalid royalty amount');
}

#[test]
#[available_gas(20000000)]
fn test_set_royalty_percentage_100() {
  let mut erc2981 = setup();

  erc2981._set_royalty_percentage(new_percentage: 10000); // 100%

  let (_, royalties_amount) = erc2981.royalty_info(token_id: 0x42, sale_price: 0x42);
  assert(royalties_amount == 0x42, 'Invalid royalty amount');
}

#[test]
#[available_gas(20000000)]
fn test_set_royalty_percentage_zero() {
  let mut erc2981 = setup();

  erc2981._set_royalty_percentage(new_percentage: 0); // 0%

  let (_, royalties_amount) = erc2981.royalty_info(token_id: 0x42, sale_price: 0x42);
  assert(royalties_amount == 0, 'Invalid royalty amount');
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('Invalid percentage',))]
fn test_set_royalty_percentage_above_100() {
  let mut erc2981 = setup();

  erc2981._set_royalty_percentage(new_percentage: 10001); // 100.01%
}
