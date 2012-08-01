---
layout: post
title: minimax tic tac toe
---
I already implemented TicTacToe using heuristics, today I was given the task to
reimplement my TicTacToe AI using the MiniMax algorithm.

If you don't already know, MiniMax is an algorithm that can be used in two
player games such as Chess, Checkers, or TicTacToe.  Using a game tree the
algorithm tries to maximize rewards during your turn, and minimize rewards
during the opponents turn.  Hence its name "Minimax".

There are two parts to the MiniMax algorithm: the evaluator and the game tree
logic.  

### Evaluator

The evaluator is custom to the each implantation of Minimax.  Its job
is to take a game state, and rank it.  For TicTacToe its job is simple.

    You Won:   1
    You Lost: -1
    Cats:      0

The numbers aren't important, as long as they are in ascending order of what
you want to happen. Each game will have their own evaluator. The more complex
the game, the more complex the evaluator will have to be.

### The Game Tree

The other part of the Minimax algorithm is the game tree logic, which is the
same for all of its implementations.

The basic pattern looks like:
  
    class GameTree
      def initialze(game_state, player, whos_turn=nil)
        @game_state, @player = game_state, player
        @whos_turn = whos_turn || player
      end

      def best_move
        children.max(&:score).move
      end

      def score
        return  1 if game_state.over? && game_state.winner == player
        return -1 if game_state.over? && game_state.winner == @opponent
        return  0 if game_state.over?

        if whos_turn == player
          children.map { |child| child.score }.max
        else
          children.map { |child| child.score }.min
        end
      end

      def children
        potential_moves.map { |move| GameTree.new(move, player, next_turn) } 
      end

      # ...
    end
