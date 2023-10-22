use traits::{ Into, TryInto };
use zeroable::Zeroable;

// local
use rules_utils::utils::math::pow;

// 10^32
const ITOA_MAX: u256 = 100000000000000000000000000000000;

trait Strings {
  fn itoa(self: @felt252) -> felt252;
}

impl StringsImpl of Strings {
  fn itoa(self: @felt252) -> felt252 {
    let mut n: u256 = (*self).into();

    if (n >= ITOA_MAX) {
      panic_with_felt252('input too large');
    }

    let mut ret: u256 = 0;
    let mut i: u8 = 0;

    loop {
      if (n.is_zero()) {
        break ret.try_into().unwrap();
      }

      ret += ((n % 10) + '0') * pow(0x100, i.into());
      n /= 10;
      i += 1;
    }
  }
}
