---
title: Logic-less views
date: 2012-08-13
---

Views are meant to be dumb displays of simple data. Because of that, views
should have no unit testing on top of them. If you feel that you should be unit
testing your views, your application has not extracted enough functionality
away from the view layer.

For example, my Tic Tac Toe board display like this:

    1 | 2 | 3
    4 | x | 6
    o | 8 | 9

When I first wrote the presentation logic it looked like:

```ruby
@board.grid.each_with_index do |row, i|
   row.each_with_index do |cell, j|
     print cell || (i*3)+(j+1)
   end
   puts
end
```

Very simple. Display a letter, if there is one, or display the number of the
cell. The only problem was that my view layer was no longer dumb. It know how
to count cells. Even the most simple logic should be extracted out of the view
layer. So I created a presenter instead.

```ruby
class BoardPresenter
  def initialize(board)
    @board = board
  end

  def grid
    @board.grid.each_with_index.map do |row, i|
       row.each_with_index.map do |cell, j|
         cell || (i*3)+(j+1)
       end
    end
  end
end
```

Now my view layer is that more concise:

```ruby
BoardPresenter.new(@board).grid.each do |row|
  row.each do |cell|
    print cell
  end
  puts
end
```
