use traits::Into;
use hash::LegacyHash;

impl EthAddressLegacyHash of LegacyHash::<starknet::EthAddress> {
  fn hash(state: felt252, value: starknet::EthAddress) -> felt252 {
    LegacyHash::<felt252>::hash(state, value.into())
  }
}
