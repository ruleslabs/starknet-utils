#[generate_trait]
impl ArrayImpl<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>> of ArrayTraitExt<T> {
  // https://github.com/keep-starknet-strange/alexandria/blob/33f524a6b1610673b3a05b70bd27a1f2904a0ef7/alexandria/data_structures/src/array_ext.cairo#L49

  fn append_all(ref self: Array<T>, ref arr: Array<T>) {
    match arr.pop_front() {
      Option::Some(v) => {
        self.append(v);
        self.append_all(ref arr);
      },
      Option::None(()) => (),
    }
  }
}
