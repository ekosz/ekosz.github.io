---
title: Tracking down slow code
date: 2012-07-20
---

Sometimes code runs slowly. A method call takes longer than you expect, and
your application starts becoming unresponsive. When this happens, having the
know-how and the proper tools becomes invaluable.

The first thing when solving any software problem, is to write a failing test.

    describe TheProblem do
      context "performace" do
        before { require 'benchmark' }

        it "will not be slow" do
          # Should not take more than 200 miliseconds
          Benchmark.realtime { subject.big_method }.should < 0.2
        end
      end
    end

After making sure the test if failing, its time to get started finding where
the delay is coming from. This is what my method looked like:

    def big_method
      80.times do |i|
        32.times do |j|
          @world.at(i, j).draw
        end
      end
    end

Now where is the delay coming from? The loops? The #at method? Or the #draw
method? Using irb I tested each one.

    > Benchmark.realtime { 80.times { |i| 32.times { |j| } } }
    => 0.0003819465637207031

    > Benchmark.realtime { Tile.new.draw }
    => 0.0006836104814734871

    > Benchmark.realtime { World.new.at(0, 0) }
    => 0.0324843261943507120

Bingo! The slowdown is in the #at method. Now wash rinse and repeat using the
code in the #at method.

It turned out, eventually my code called Array#transpose which is a very slow
piece of code. I changed `array.transpose[x][y]` to `array[y][x]` and my
failing test passed.
