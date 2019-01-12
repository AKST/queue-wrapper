defmodule QueueWrapper do
  @type t() :: :queue.queue()

  @moduledoc """
  Elixir bindings to the erlang queue library with
  a few additions, such as reduce & a means to do
  equality. See the [erlang docs][docs] for more info
  on the module.

  In some cases function names have been given more
  explict names, such as `in`, `out`, `drop`, & `len`.

  Personally I find the name names such as `in` & `in_r`
  unhelpful, when `in` is rear but `in_r` is the one with
  the `r` suffix. But for `out`, the operation on the rear
  has the suffix... There's likely a method to the madness
  of those methods names, but they're personally unhelpful
  for me.

  [docs]: http://erlang.org/doc/man/queue.html
  """

  defdelegate filter(fun, queue), to: :queue
  defdelegate from_list(list), to: :queue
  defdelegate is_empty(queue), to: :queue
  defdelegate is_queue(term), to: :queue
  defdelegate join(q1, q2), to: :queue
  defdelegate member(item, queue), to: :queue
  defdelegate new, to: :queue
  defdelegate reverse(queue), to: :queue
  defdelegate split(n, queue), to: :queue
  defdelegate to_list(queue), to: :queue

  defdelegate length(queue), to: :queue, as: :len
  defdelegate in_rear(item, queue), to: :queue, as: :in
  defdelegate in_front(item, queue), to: :queue, as: :in_r
  defdelegate out_rear(queue), to: :queue, as: :out_r
  defdelegate out_front(queue), to: :queue, as: :out
  defdelegate drop_rear(queue), to: :queue, as: :drop_r
  defdelegate drop_front(queue), to: :queue, as: :drop
  defdelegate get_rear(queue), to: :queue, as: :get_r
  defdelegate get_front(queue), to: :queue, as: :get
  defdelegate peek_rear(queue), to: :queue, as: :peek_r
  defdelegate peek_front(queue), to: :queue, as: :peek

  # Note the method `liat` is not included here due to
  # it being deprecated and being removed in a future
  # release. Apparently you're meant to use liat instead.
  defdelegate cons(item, queue), to: :queue
  defdelegate init(queue), to: :queue
  defdelegate last(queue), to: :queue
  defdelegate liat(queue), to: :queue
  defdelegate snoc(queue, item), to: :queue
  defdelegate tail(queue), to: :queue

  def replace_at(items, index, value) do
    {left, right} = :queue.split(index, items)
    right = :queue.drop(right)
    left = :queue.in(value, left)
    :queue.join(left, right)
  end

  def reduce_while(items, state, transform) do
    case :queue.len(items) do
      0 ->
        state

      _ ->
        {{:value, value}, items} = :queue.out(items)

        case transform.(value, state) do
          {:cont, state} -> reduce_while(items, state, transform)
          {:halt, state} -> state
        end
    end
  end

  def reduce(items, state, transform) do
    case :queue.len(items) do
      0 ->
        state

      _ ->
        {{:value, value}, items} = :queue.out(items)
        state = transform.(value, state)
        reduce(items, state, transform)
    end
  end

  def equal(left, right) do
    equal(left, right, fn a, b -> a == b end)
  end

  def equal(left, right, eq) do
    left_len = :queue.len(left)
    right_len = :queue.len(right)

    if left_len == right_len do
      value =
        reduce_while(left, right, fn left_value, right ->
          {{:value, right_value}, right} = :queue.out(right)

          if eq.(left_value, right_value) do
            {:cont, right}
          else
            {:halt, :error}
          end
        end)

      case value do
        :error -> false
        _ -> true
      end
    else
      false
    end
  end
end
