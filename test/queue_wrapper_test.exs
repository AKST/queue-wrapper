defmodule QueueWrapperTest do
  use ExUnit.Case

  require QueueWrapper, as: Queue

  describe "equals" do
    test "similar layout" do
      a = Queue.in_rear(:a, Queue.new())
      b = Queue.in_rear(:a, Queue.new())
      assert Queue.equal(a, b)
    end

    test "different layout" do
      # {[], [:a]}
      a = Queue.in_rear(:a, Queue.new())
      # {[:a], []}
      b = Queue.in_front(:a, Queue.new())
      assert Queue.equal(a, b)
    end
  end
end
