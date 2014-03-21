
# This is a game called Greed, from the Ruby Koans tutorial framework.

class AboutGreed < Neo::Koan

  # A Game is begun. 
  # Players are announced.
  # Players begin to take turns. 
  # Players try to get in the game.
  # Player A takes his turn. At first all the dice score, and then only
  #   four score, and then he takes his turn with one die, and then that
  #   one does not score. So his turn ends.
  # Player B takes her turn, some dice score, then she rolls all the non-scoring
  #   dice, scores. Then she scores big with all the dice. Then she chooses to 
  #   end her turn.
  # Player C ...
  # And repeat until one player reaches 3000.
 
  class Player
    attr_reader :name
    attr_reader :style
    attr_reader :qualified
    attr_reader :points
    attr_reader :wins
    attr_reader :turns
    attr_reader :nonscoring
    attr_reader :thresh
    attr_reader :lastscore

    def initialize(name, playing_style = :cons)
      @name = name
      @style = playing_style
      @qualified = false
      @points = 0
      @wins = false
      @turns = 0 
      @nonscoring = 0
      
      if (@style == :cons)
        @thresh = 85
      else
        @thresh = 60
      end  
    end

    def take_a_turn(number_of_dice = 5)

      @nonscoring = 0

      dice = DiceSet.new
      dice.roll(number_of_dice)

      values = dice.values
      str = values.inspect
      score = dice.score()
      @lastscore = score

      puts "Player #{@name}, turn ##{@turns}, rolled #{str}"
      if ( @qualified == false )
        if ( score >= 300 ) 
          puts "Player #{@name} just qualified to enter game."
          @qualified = true
        else
          puts "Player #{@name} failed to qualify, the last roll scored only #{@lastscore} points."
        end
      end

      if @qualified
        @points = @points + score
        puts "Player #{@name} scored #{score} more points, for a total of #{@points}."
      end

      @turns = @turns + 1
      @nonscoring = dice.nonscoring()

# puts "     roll: #{str}"
# puts "     score: [#{score}] points: [#{points}] nonscoringdice: [#{nonscoring}] turns: [#{turns}] qualified: [#{qualified}] lastscore: [#{lastscore}]"

      score
    end

    def fullturn()
      puts
      puts
      puts "Start of #{@name}'s turn ..."
      endturn = false

      take_a_turn

      while ( (@lastscore > 0) and (endturn == false) )

        if @points > 3000
          @wins = true
          puts "Player #{@name} wins the game."
          return
        end

        if @nonscoring == 0
          number_of_dice = 5
        else
          number_of_dice = @nonscoring
        end

        if ( @qualified == false )
          take_a_turn(number_of_dice)
        else
          random = rand(100)
          if ( random > @thresh )
            take_a_turn(number_of_dice)
            if lastscore == 0
              @points = 0
              puts "Player #{@name} lost everything, back to 0 points."
            end
          else
            puts "Player #{@name} chooses to keep winnings and not roll again."
            endturn = true
          end
        end
      end
      puts "End of #{@name}'s turn"
    end

    def wins?()
      @wins
    end
  end

  def test_new_player_initialized_correctly
    p = Player.new("Rizal")
    assert_equal :cons, p.style
    assert_equal false, p.qualified
    assert_equal 0, p.points
    assert_equal false, p.wins
  end

  # ZZZ All tests below rely on this srand statement
  # ZZZ do not delete!

  # PPA 
  #
  # Clean up code for taking turns, in player
  # Take a look, are all those player attributes really necessary to
  #   be accessible?
  #
  # Winner and loser state variables need to be updated, and where does
  # that logic go?
  # - consider what to name all the constants
  # - what namespace the constants should be in
  # - where to put the logic for winning or qualifying?
  # - make constant for points to win game, configurable
  # - make constant to points to qualify, configurable
  #
  # - fix the srands, they should be in every test
  # - use strings from "inspect" to check the states after turns
  #   for conciseness
  # - use history for each turn, to check interesting events
  # - add useful comments so I can remember this later
  # - upload a copy somewhere; 

  def test_random_seed_for_testing
    srand 1
    assert_equal 1, ( srand 1 )
  end

  def test_player_member_variables_after_one_simple_roll
    p = Player.new("Luna")
    p.take_a_turn
    assert_equal 0, p.points
    assert_equal false, p.qualified
    assert_equal 1, p.turns
    assert_equal 3, p.nonscoring
    assert_equal 150, p.lastscore
  end

  def test_player_member_variables_step_by_step_as_player_qualifies
    p = Player.new("Bonifacio")
    p.take_a_turn

    assert_equal 200, p.lastscore
    assert_equal 0, p.points
    assert_equal 3, p.nonscoring
    assert_equal false, p.qualified
    assert_equal 1, p.turns

    p.take_a_turn
    assert_equal 100, p.lastscore
    assert_equal 0, p.points
    assert_equal 3, p.nonscoring
    assert_equal false, p.qualified
    assert_equal 2, p.turns

    p.take_a_turn
    assert_equal 100, p.lastscore
    assert_equal 0, p.points
    assert_equal 3, p.nonscoring
    assert_equal false, p.qualified
    assert_equal 3, p.turns

    p.take_a_turn
    assert_equal 100, p.lastscore
    assert_equal 0, p.points
    assert_equal 3, p.nonscoring
    assert_equal false, p.qualified
    assert_equal 4, p.turns

    p.take_a_turn
    assert_equal 150, p.lastscore
    assert_equal 0, p.points
    assert_equal 3, p.nonscoring
    assert_equal false, p.qualified
    assert_equal 5, p.turns

    p.take_a_turn
    assert_equal 0, p.lastscore
    assert_equal 0, p.points
    assert_equal 5, p.nonscoring
    assert_equal false, p.qualified
    assert_equal 6, p.turns

    p.take_a_turn
    assert_equal 1050, p.lastscore
    assert_equal 1050, p.points
    assert_equal 1, p.nonscoring
    assert_equal true, p.qualified
    assert_equal 7, p.turns
  end

  def test_player_accumulates_points_after_qualifying
    p = Player.new("Aguinaldo")
  
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    p.take_a_turn
    assert_equal false, p.qualified

    p.take_a_turn
    assert_equal true, p.qualified
    assert_equal 500, p.points
    assert_equal 14, p.turns

    p.take_a_turn
    assert_equal 200, p.lastscore
    assert_equal 700, p.points
    assert_equal 15, p.turns

    p.take_a_turn
    assert_equal 150, p.lastscore
    assert_equal 850, p.points
    assert_equal 16, p.turns

    p.take_a_turn
    assert_equal 200, p.lastscore
    assert_equal 1050, p.points
    assert_equal 17, p.turns

    p.take_a_turn
    assert_equal 200, p.lastscore
    assert_equal 1250, p.points
    assert_equal 18, p.turns

    p.take_a_turn
    assert_equal 100, p.lastscore
    assert_equal 1350, p.points
    assert_equal 19, p.turns

    p.take_a_turn
    assert_equal 200, p.lastscore
    assert_equal 1550, p.points
    assert_equal 20, p.turns

  end

  def test_player_takes_full_turn

    p = Player.new("Mabini")
    p.fullturn
    assert_equal 3, p.turns

  end

  def test_conservative_player_takes_full_turn_until_qualifying
    p = Player.new("Pozon")
    p.fullturn
    assert_equal 3, p.turns
    assert_equal false, p.qualified
    assert_equal 0, p.points

    p.fullturn
    assert_equal 4, p.turns
    assert_equal true, p.qualified
    assert_equal 300, p.points

    p.fullturn
    assert_equal 5, p.turns
    assert_equal 100, p.lastscore
    assert_equal 400, p.points
  end

  def test_aggressive_player_takes_full_turn_until_qualifying

    srand 5

    p = Player.new("Aquino", :aggr)

    p.fullturn
    p.fullturn
    p.fullturn
    assert_equal 13, p.turns
    assert_equal false, p.qualified
    assert_equal 0, p.points

    # fullturn, qualified, then lost everything, all in one turn
    p.fullturn
    assert_equal 18, p.turns
    assert_equal true, p.qualified
    assert_equal 0, p.points

    p.fullturn
    assert_equal 19, p.turns
    assert_equal true, p.qualified
    assert_equal 100, p.points
    
    p.fullturn
    assert_equal 21, p.turns
    assert_equal true, p.qualified
    assert_equal 1150, p.points

    p.fullturn
    assert_equal 22, p.turns
    assert_equal 1000, p.lastscore
    assert_equal 2150, p.points

    p.fullturn
    assert_equal 23, p.turns
    assert_equal 50, p.lastscore
    assert_equal 2200, p.points
  end

  def test_two_players_are_not_identical
    p1 = Player.new("Pilar")
    p2 = Player.new("Kudarat")
 
    assert_not_equal p1, p2
  end

  def test_track_two_conservative_players_scoring_points_gameplay

    srand 6

    p1 = Player.new("Pira")
    p2 = Player.new("Ponce")

    endgame = false
    winner = nil

    players = [ p1, p2 ]
    while ( endgame == false )
      players.each { | player |
        player.fullturn
        if ( player.wins? == true )
          endgame = true
          winner = player
          break
        end
      }
    end

    assert_equal true, p1.wins?
    assert_equal false, p2.wins?
    assert_equal "Pira", winner.name
    assert_equal p1, winner
    assert_not_equal p2, winner
  end

  def test_two_aggressive_players_turns_score_points

    srand 7

    p1 = Player.new("Guerrero", :aggr)
    p2 = Player.new("Agoncillo", :aggr)

    endgame = false
    winner = nil

    players = [ p1, p2 ]
    while ( endgame == false )
      players.each { | player |
        player.fullturn
        if ( player.wins? == true )
          endgame = true
          winner = player
          break
        end
      }
    end

    assert_equal false, p1.wins?
    assert_equal true, p2.wins?
    assert_equal "Agoncillo", winner.name
    assert_not_equal p1, winner
    assert_equal p2, winner
  end

  def test_two_aggressive_players_turns_score_points

    srand 9

    p1 = Player.new("Cayetano", :aggr)
    p2 = Player.new("Escudero", :cons)
    p3 = Player.new("Estrada", :aggr)

    endgame = false
    winner = nil

    players = [ p1, p2, p3 ]
    while ( endgame == false )
     
      players.each { | player |
        player.fullturn 
        if player.wins?
          endgame = true
          winner = player
          break
        end
      }

      losers = []
      players.each { | player |
        if player.wins?()
          winner = player
        else 
          losers.push(player) 
        end
      }
    end

    assert_equal 1150, p1.points 
    assert_equal 3100, p2.points 
    assert_equal 1000, p3.points
    assert_equal p2, winner
    assert_not_equal p1, winner
    assert_not_equal p3, winner

  end

  class Game
    attr_reader :winner 

    def initialize(players = [])
      @players = players
      @winner = nil
      @state = :forfeit
      i = 0
    end

    def play
  
      if ( @players.count < 2 )
        @winner = nil
        return
      end

      @state = :fair
  
      end_game = false
  
      while ( @state == :fair )
        @players.each { |p|
          p.fullturn
          if ( p.points > 3000 )
            @state = :over
            @winner = p
            break
          end 
        }
      end
    end

    def fair?()
      @state == :fair
    end
  
    def over?()
      @state != :fair
    end
  end

  def test_no_players_means_no_winner
    g = Game.new
    g.play
    assert_equal false, g.fair?()
    assert_equal true, g.over?()
    assert_equal nil, g.winner
  end

  def test_one_players_means_no_winner
    g = Game.new( [ Player.new("Silang", :aggr) ] )
    g.play
    assert_equal false, g.fair?
    assert_equal true, g.over?
    assert_equal nil, g.winner
  end

  def test_two_players_means_one_wins_another_loses

    srand 94

    p1 = Player.new("Romualdez", :cons)
    p2 = Player.new("San Marcelino", :aggr)
    g = Game.new( [ p1, p2 ])

    g.play
    assert_equal true, g.over?
    assert_equal "Romualdez", g.winner.name
    assert_equal 3100, g.winner.points
    assert_equal 1500, p2.points
    assert_equal p1, g.winner
    assert_not_equal p2, g.winner
  end

  def test_winners_scored_more_than_3000

    srand 35

    p1 = Player.new("Ayala", :aggr)
    p2 = Player.new("Correa", :cons)
    p3 = Player.new("Pasig", :aggr)
    p4 = Player.new("Solano", :cons)
    p5 = Player.new("Kalaw", :aggr)

    g = Game.new( [ p1, p2, p3, p4, p5 ] )

    g.play

    assert_equal "Pasig", g.winner.name
    assert_equal 3350, g.winner.points
    assert ( p1.points < 3000 )
    assert ( p2.points < 3000 )
    assert ( p4.points < 3000 )
    assert ( p5.points < 3000 )
  end
end
