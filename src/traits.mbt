pub(open) trait IsString : Show {
  length(Self) -> Int 
  write_string(Self,&Logger) -> Unit
}

pub impl IsString for String with length(self) {
  self.length()
}

pub impl IsString for @string.View with length(self) {
  self.char_length()
}

pub impl IsString for String with write_string(self,logger) {
  logger.write_string(self)
}

pub impl IsString for @string.View with write_string(self,logger) {
  self.output(logger)
}