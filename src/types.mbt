typealias Deque[A] = @immut_deque.T[A]
struct Line {
  inden : Int 
  texts : Deque[&IsString]
} 
// derive(Show)
type Doc Deque[Line] 