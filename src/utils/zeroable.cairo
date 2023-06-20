use zeroable::Zeroable;

// Not available in cairo@1.1.0 but coming soon
impl U16Zeroable of Zeroable<u16> {
  fn zero() -> u16 {
    0
  }
  #[inline(always)]
  fn is_zero(self: u16) -> bool {
    self == U16Zeroable::zero()
  }
  #[inline(always)]
  fn is_non_zero(self: u16) -> bool {
    self != U16Zeroable::zero()
  }
}

// Not available in cairo@1.1.0 but coming soon
impl U64Zeroable of Zeroable<u64> {
  fn zero() -> u64 {
    0
  }
  #[inline(always)]
  fn is_zero(self: u64) -> bool {
    self == U64Zeroable::zero()
  }
  #[inline(always)]
  fn is_non_zero(self: u64) -> bool {
    self != U64Zeroable::zero()
  }
}

// Not available in cairo@1.1.0 but coming soon
impl U128Zeroable of Zeroable<u128> {
  fn zero() -> u128 {
    0
  }

  #[inline(always)]
  fn is_zero(self: u128) -> bool {
    self == U128Zeroable::zero()
  }

  #[inline(always)]
  fn is_non_zero(self: u128) -> bool {
    self != U128Zeroable::zero()
  }
}

// Not available in cairo@1.1.0 but coming soon
impl U256Zeroable of Zeroable<u256> {
  fn zero() -> u256 {
    0
  }

  #[inline(always)]
  fn is_zero(self: u256) -> bool {
    self == U256Zeroable::zero()
  }

  #[inline(always)]
  fn is_non_zero(self: u256) -> bool {
    self != U256Zeroable::zero()
  }
}
