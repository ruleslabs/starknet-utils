use debug::PrintTrait;

// locals
use rules_utils::utils::base64::Base64;

#[test]
#[available_gas(20000000)]
fn test_base64_basic() {
  let arr = array!['Hello world!'];
  let res = arr.encode();

  assert(res == array!['SGVsbG8gd29ybGQh'], 'Invalid encoding');
}

#[test]
#[available_gas(20000000)]
fn test_base64_multiple_small_arrays() {
  let arr = array!['H', 'e', 'l', 'lo', ' ', 'wor', 'l', 'd', '!'];
  let res = arr.encode();

  assert(res == array!['SGVsbG8gd29ybGQh'], 'Invalid encoding');
}

#[test]
#[available_gas(200000000)]
fn test_base64_single_padding() {
  let arr = array!['Hello world!!!'];
  let res = arr.encode();

  assert(res == array!['SGVsbG8gd29ybGQhISE='], 'Invalid encoding');
}

#[test]
#[available_gas(200000000)]
fn test_base64_double_padding() {
  let arr = array!['Hello world!!'];
  let res = arr.encode();

  assert(res == array!['SGVsbG8gd29ybGQhIQ=='], 'Invalid encoding');
}

#[test]
#[available_gas(2000000000)]
fn test_base64_long_array() {
  let arr = array![
    'Lorem ipsum dolor sit amet, con',
    'sectetur adipiscing elit, sed d',
    'o eiusmod tempor incididunt ut ',
    'labore et dolore magna aliqua. ',
    'Ut enim ad minim veniam, quis n',
    'ostrud exercitation ullamco lab',
    'oris nisi ut aliquip ex ea comm',
    'odo consequat. Duis aute irure ',
    'dolor in reprehenderit in volup',
    'tate velit esse cillum dolore e',
    'u fugiat nulla pariatur. Except',
    'eur sint occaecat cupidatat non',
    ' proident, sunt in culpa qui of',
    'ficia deserunt mollit anim id e',
    'st laborum.',
  ];
  let res = arr.encode();

  let expected_res = array![
    'TG9yZW0gaXBzdW0gZG9sb3Igc2l0',
    'IGFtZXQsIGNvbnNlY3RldHVyIGFk',
    'aXBpc2NpbmcgZWxpdCwgc2VkIGRv',
    'IGVpdXNtb2QgdGVtcG9yIGluY2lk',
    'aWR1bnQgdXQgbGFib3JlIGV0IGRv',
    'bG9yZSBtYWduYSBhbGlxdWEuIFV0',
    'IGVuaW0gYWQgbWluaW0gdmVuaWFt',
    'LCBxdWlzIG5vc3RydWQgZXhlcmNp',
    'dGF0aW9uIHVsbGFtY28gbGFib3Jp',
    'cyBuaXNpIHV0IGFsaXF1aXAgZXgg',
    'ZWEgY29tbW9kbyBjb25zZXF1YXQu',
    'IER1aXMgYXV0ZSBpcnVyZSBkb2xv',
    'ciBpbiByZXByZWhlbmRlcml0IGlu',
    'IHZvbHVwdGF0ZSB2ZWxpdCBlc3Nl',
    'IGNpbGx1bSBkb2xvcmUgZXUgZnVn',
    'aWF0IG51bGxhIHBhcmlhdHVyLiBF',
    'eGNlcHRldXIgc2ludCBvY2NhZWNh',
    'dCBjdXBpZGF0YXQgbm9uIHByb2lk',
    'ZW50LCBzdW50IGluIGN1bHBhIHF1',
    'aSBvZmZpY2lhIGRlc2VydW50IG1v',
    'bGxpdCBhbmltIGlkIGVzdCBsYWJv',
    'cnVtLg==',
  ];

  assert(res == expected_res, 'Invalid encoding');
}
