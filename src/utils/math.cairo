use integer::{ u8_wide_mul, u32_wide_mul, u256_overflow_mul, BoundedInt };

// https://github.com/keep-starknet-strange/alexandria/blob/ae1d5149ff601a7ac5b39edc867d33ebd83d7f4f/src/math/src/lib.cairo

fn pow<
  T,
  impl TSub: Sub<T>,
  impl TMul: Mul<T>,
  impl TDiv: Div<T>,
  impl TRem: Rem<T>,
  impl TPartialEq: PartialEq<T>,
  impl TInto: Into<u8, T>,
  impl TDrop: Drop<T>,
  impl TCopy: Copy<T>
>(
  base: T, exp: T
) -> T {
    if (exp == 0_u8.into()) {
        1_u8.into()
    } else if (exp == 1_u8.into()) {
        base
    } else if (exp % 2_u8.into() == 0_u8.into()) {
        pow(base * base, exp / 2_u8.into())
    } else {
        base * pow(base * base, exp / 2_u8.into())
    }
}

trait BitShift<T> {
  fn shl(x: T, n: T) -> T;

  fn shr(x: T, n: T) -> T;
}

impl U8BitShift of BitShift<u8> {
  fn shl(x: u8, n: u8) -> u8 {
    (u8_wide_mul(x, pow(2, n)) & BoundedInt::<u8>::max().into()).try_into().unwrap()
  }

  fn shr(x: u8, n: u8) -> u8 {
    x / pow(2, n)
  }
}

impl U32BitShift of BitShift<u32> {
  fn shl(x: u32, n: u32) -> u32 {
    (u32_wide_mul(x, pow(2, n)) & BoundedInt::<u32>::max().into()).try_into().unwrap()
  }

  fn shr(x: u32, n: u32) -> u32 {
    x / pow(2, n)
  }
}

impl U256BitShift of BitShift<u256> {
  fn shl(x: u256, n: u256) -> u256 {
    let (r, _) = u256_overflow_mul(x, pow(2, n));
    r
  }

  fn shr(x: u256, n: u256) -> u256 {
    x / pow(2, n)
  }
}
