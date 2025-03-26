///|
pub fn Doc::from_line(line : Line) -> Doc {
  @immut_deque.singleton(line)
}

///|
pub fn Doc::from_string(str : &IsString) -> Doc {
  Line::from_string(str) |> Doc::from_line
}

///|
pub fn Doc::new(deque : Deque[Line]) -> Doc {
  deque
}

///|
pub fn Doc::from_iter(iter : Iter[Line]) -> Doc {
  Deque::from_iter(iter)
}

///|
pub fn Doc::empty() -> Doc {
  @immut_deque.empty()
}

///|
pub fn Doc::envelop(self : Doc, left~ : &IsString, right~ : &IsString) -> Doc {
  match self._.uncons() {
    None => @immut_deque.empty()
    Some((top, t)) =>
      match t.unsnoc() {
        Some((bot, mid)) => mid.cons(top.cons(left)).snoc(bot.snoc(right))
        None => @immut_deque.singleton(top.cons(left).snoc(right))
      }
  }
}

///|
pub fn Doc::joinline(
  self : Doc,
  separator~ : &IsString? = None,
  bot : Doc
) -> Doc {
  let top = self
  match top._.unsnoc() {
    None => bot
    Some((top_last, top_init)) =>
      match bot._.uncons() {
        None => top
        Some((bot_head, bot_tail)) => {
          let bot_head = match separator {
            None => bot_head
            Some(sep) => bot_head.cons(sep)
          }
          let mid = top_last.append(bot_head)
          top_init.snoc(mid).append(bot_tail)
        }
      }
  }
}

///|
pub fn Doc::height(self : Doc) -> Int {
  self._.foldl(0, fn(acc, _) { acc + 1 })
}

///|
pub fn Doc::lastline_width(self : Doc) -> Int {
  match self._.unsnoc() {
    None => 0
    Some((last, _)) => last.width()
  }
}

///|
pub fn maximum[T : Compare](iter : Iter[T]) -> T? {
  let mut res = None
  for x in iter {
    match res {
      None => res = Some(x)
      Some(max) => if x > max { res = Some(x) }
    }
  }
  res
}

///|
pub fn Doc::width(self : Doc) -> Int {
  (self._.iter().map(Line::width) |> maximum).unwrap()
}

///|
pub fn Doc::join(self : Doc, separator~ : &IsString) -> Line {
  match self._.uncons() {
    None => Line::empty()
    Some((x, xs)) =>
      xs.foldl(x, fn(acc, line) { acc.append(line.cons(separator)) })
  }
}

///|
pub fn Doc::indent(self : Doc, n : Int) -> Doc {
  self._.map(fn(line) { line.indent(n) })
}

///|
pub fn Doc::indent_rest(self : Doc, n : Int) -> Doc {
  match self._.uncons() {
    None => @immut_deque.empty()
    Some((x, xs)) => xs.map(fn(line) { line.indent(n) }).cons(x)
  }
}

///|
pub impl Show for Doc with output(self, logger) {
  for line in self._ {
    for text in line {
      text.write_string(logger)
    }
    logger.write_char('\n')
  }
}

///|
pub impl Show for Doc with to_string(self) {
  let size_hint = self._.foldl(0, fn(acc, line) {
    line.texts.foldl(acc, fn(acc, text) { acc + text.length() })
  })
  let builder = StringBuilder::new(size_hint~)
  self.output(builder)
  builder.to_string()
}

///|
pub fn Doc::vertical_concat(self : Doc, other : Doc) -> Doc {
  self._.append(other._)
}
