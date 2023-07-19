impl BoolIntoU8 of Into<bool, u8> {
  #[inline(always)]
  fn into(self: bool) -> u8 {
    if (self) {
      1_u8
    } else {
      0_u8
    }
  }
}

impl Felt252TryIntoBool of TryInto<felt252, bool> {
  fn try_into(self: felt252) -> Option<bool> {
    if self == 0 {
      Option::Some(false)
    } else if self == 1 {
      Option::Some(true)
    } else {
      Option::None(())
    }
  }
}
