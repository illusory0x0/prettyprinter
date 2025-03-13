///|
fn singleton[A](x : A) -> Deque[A] {
  @immut_deque.empty().cons(x)
}

fn from_iter[A](iter : Iter[A]) -> Deque[A] {
  @immut_deque.from_list(@immut/list.from_iter(iter))
}