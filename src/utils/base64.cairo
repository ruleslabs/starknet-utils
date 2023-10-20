use array::ArrayTrait;
use traits::{ TryInto, Into };
use debug::PrintTrait;

// locals
use rules_utils::utils::math::{ BitShift, pow };

trait Base64<T> {
  fn encode(self: @Array<T>) -> Array<T>;
}

impl Base64Impl of Base64<felt252> {
  fn encode(self: @Array<felt252>) -> Array<felt252> {
    let mut ret: Array<felt252> = array![];

    // return empty array if input is null
    if (self.len().is_zero()) {
      return array![];
    }

    let mut i: usize = 0;

    let mut word: u256 = (*self[i]).into();
    let mut word_len: u8 = get_word_len(word);

    let mut c1: u8 = 0;
    let mut c2: u8 = 0;
    let mut c3: u8 = 0;

    let mut bword: u256 = 0;
    let mut bword_len: u8 = 0;

    let mut padding: u8 = 3;

    let mut char_set = get_base64_char_set();

    loop {
      // get next word if needed
      if (word.is_zero()) {
        i += 1;

        // stop loop
        if (self.len() == i) {
          break;
        }

        word = (*self[i]).into();
        word_len = get_word_len(word);
      }

      if (padding == 3) {
        c1 = extract_last_byte_from_word(ref :word, ref :word_len);
        padding -= 1;
      } else if (padding == 2) {
        c2 = extract_last_byte_from_word(ref :word, ref :word_len);
        padding -= 1;
      } else if (padding == 1) {
        c3 = extract_last_byte_from_word(ref :word, ref :word_len);

        bword = BitShift::shl(bword, 32) + compute_base64_word(:c1, :c2, :c3, ref :char_set).into();
        bword_len += 4;

        // push to ret if another u32 bword could lead to a felt252 overflow
        if (bword_len + 4 > 31) {
          ret.append(bword.try_into().unwrap());

          bword = 0;
          bword_len = 0;
        }

        // reset
        c1 = 0;
        c2 = 0;
        c3 = 0;
        padding = 3;
      };
    };

    // handle padding
    if (padding < 3) {
      let bit_padding: u8 = padding * 8;
      bword =
        BitShift::shl(bword, 32 - bit_padding.into()) +
        BitShift::shr(compute_base64_word(:c1, :c2, :c3, ref :char_set).into(), bit_padding.into());

      loop {
        if (padding.is_zero()) {
          break;
        }

        bword = BitShift::shl(bword, 8) + '=';
        padding -= 1;
      }
    }

    // push last bwords
    if (bword.is_non_zero()) {
      ret.append(bword.try_into().unwrap());
    }

    ret
  }
}

// pass word len for optimization purpose
fn extract_last_byte_from_word(ref word: u256, ref word_len: u8) -> u8 {
  if (word.is_zero()) {
    return 0;
  }

  let ret: u8 = (BitShift::shr(word, (word_len - 1).into() * 8)).try_into().unwrap(); // can panic if word_len is not valid

  // update word
  word_len -= 1;
  word = word & (pow(2, word_len.into() * 8) - 1);

  ret
}

fn get_word_len(word: u256) -> u8 {
  if (word.is_zero()) {
    0
  } else {
    get_word_len(word / 0x100) + 1 // 1 byte shr
  }
}

fn compute_base64_word(c1: u8, c2: u8, c3: u8, ref char_set: Array<u8>) -> u32 {
  // 6 bit cutting
  let n1 = BitShift::shr(c1, 2);
  let n2 = BitShift::shl(c1 & 0b11, 4) + BitShift::shr(c2, 4);
  let n3 = BitShift::shl(c2 & 0b1111, 2) + BitShift::shr(c3, 6);
  let n4 = c3 & 0b111111;

  // base64 word construction
  let mut ret: u32 = BitShift::shl((*char_set[n1.into()]).into(), 24);
  ret += BitShift::shl((*char_set[n2.into()]).into(), 16);
  ret += BitShift::shl((*char_set[n3.into()]).into(), 8);
  ret += (*char_set[n4.into()]).into();

  ret
}

fn get_base64_char_set() -> Array<u8> {
  let mut result = array![
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '+',
    '/',
  ];
  result
}
