use array::ArrayTrait;

// https://github.com/keep-starknet-strange/alexandria/blob/33f524a6b1610673b3a05b70bd27a1f2904a0ef7/alexandria/data_structures/src/array_ext.cairo#L48

trait ArrayTraitExt<T> {
  fn append_all(ref self: Array<T>, ref arr: Array<T>);

  fn concat(self: @Array<T>, arr: @Array<T>) -> Array<T>;
}

impl ArrayImpl<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>> of ArrayTraitExt<T> {
  fn append_all(ref self: Array<T>, ref arr: Array<T>) {
    match arr.pop_front() {
      Option::Some(v) => {
        self.append(v);
        self.append_all(ref arr);
      },
      Option::None(()) => (),
    }
  }

  fn concat(self: @Array<T>, arr: @Array<T>) -> Array<T> {
    // Can't do self.span().concat(arr);
    let mut ret = array![];
    let mut i = 0;

    loop {
      if (i == self.len()) {
        break;
      }

      ret.append(*self[i]);
      i += 1;
    };

    i = 0;

    loop {
      if (i == arr.len()) {
        break;
      }

      ret.append(*arr[i]);
      i += 1;
    };

    ret
  }
}
