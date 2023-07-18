use array::ArrayTrait;
use result::ResultTrait;

const CONTRACT_NOT_DEPLOYED: felt252 = 'CONTRACT_NOT_DEPLOYED';

#[generate_trait]
impl ContractAddressImpl of ContractAddressTraitExt {
  fn is_deployed(self: @starknet::ContractAddress) -> bool {
    match starknet::call_contract_syscall(
      address: *self,
      entry_point_selector: 0x1,
      calldata: ArrayTrait::<felt252>::new().span()
    ) {
      Result::Ok(res) => {
        true // I'm quite sure it won't happen ^^
      },
      Result::Err(mut err) => {
        match err.pop_front() {
          Option::Some(err_message) => {
            err_message != CONTRACT_NOT_DEPLOYED
          },
          Option::None(()) => {
            false // This one neither
          },
        }
      }
    }
  }
}
