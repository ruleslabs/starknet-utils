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
