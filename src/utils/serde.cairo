use serde::Serde;

#[generate_trait]
impl SerdeImpl<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of SerdeTraitExt<T> {
  fn append_serde(ref self: Array<felt252>, value: T) {
    value.serialize(ref self);
  }
}
