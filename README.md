# Read me

A simple elixir wrapper over the erlang queue data strucuture,
with additional methods such as reduce & equality. Unforuately
the equality operator isn't enough to check if two queues have
the same contents, due to how the erlang queue implementation
optimizes removing & addinging items to the start & ends of the
queue.
