require File.expand_path(File.dirname(__FILE__) + '/neo')

# Implement a DiceSet Class here:
#
class DiceSet

  def initialize
     @arr = []
     @nonscoring = 0
  end

  def roll(a_size, dummy=nil)

    if dummy != nil
      @arr = dummy
    else
      @arr = []
      i = 1
      while i <= a_size
        @arr.push(rand(1..6))
        i += 1
      end 
    end

    @arr
  end

  def nonscoring
    @nonscoring
  end

  def values
    @arr
  end 

  def score
    total = 0

    if @arr.count == 0
      return total
    end

    hash = Hash.new(0)
    @arr.each { |num| hash[num] += 1 }

    if (hash[1] >= 3)
      total += 1000
      total += ((hash[1]-3)*100)
    else
      total += (hash[1] * 100)
    end

    hash.delete(1)

    (2..6).each do |i|
      if (i == 5)
        if (hash[i] >= 3)
          total += 500
          total += ((hash[i]-3)*50)
        else
          total += (hash[i]*50)
        end
        hash.delete(5)
      else
        if (hash[i] == 3)
          total += i * 100
          hash.delete(i)
        end
      end
    end

    hash.values.each { |i| @nonscoring = @nonscoring + i }

    total
  end
end

class AboutDiceProject < Neo::Koan
  def test_can_create_a_dice_set
    dice = DiceSet.new
    assert_not_nil dice
  end

  def test_rolling_the_dice_returns_a_set_of_integers_between_1_and_6
    dice = DiceSet.new

    dice.roll(5)
    assert dice.values.is_a?(Array), "should be an array"
    assert_equal 5, dice.values.size
    dice.values.each do |value|
      assert value >= 1 && value <= 6, "value #{value} must be between 1 and 6"
    end
  end

  def test_dice_values_do_not_change_unless_explicitly_rolled
    dice = DiceSet.new
    dice.roll(5)
    first_time = dice.values
    second_time = dice.values
    assert_equal first_time, second_time
  end

  def test_dice_values_should_change_between_rolls
    dice = DiceSet.new

    dice.roll(5)
    first_time = dice.values

    dice.roll(5)
    second_time = dice.values

    assert_not_equal first_time, second_time,
      "Two rolls should not be equal"

    # THINK ABOUT IT:
    #
    # If the rolls are random, then it is possible (although not
    # likely) that two consecutive rolls are equal.  What would be a
    # better way to test this?
  end

  def test_you_can_roll_different_numbers_of_dice
    dice = DiceSet.new

    dice.roll(3)
    assert_equal 3, dice.values.size

    dice.roll(1)
    assert_equal 1, dice.values.size
  end

  def test_score_of_an_empty_list_is_zero
    dice = DiceSet.new
    dice.roll(0, [])

    assert_equal 0, dice.score()
  end

  def test_score_of_a_single_roll_of_5_is_50
    dice = DiceSet.new
    dice.roll(1, [5])
    assert_equal 50, dice.score()
  end

  def test_score_of_a_single_roll_of_1_is_100
    dice = DiceSet.new
    dice.roll(1, [1])
    assert_equal 100, dice.score()
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    dice = DiceSet.new
    dice.roll(4, [1,5,5,1])
    assert_equal 300, dice.score()
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    dice = DiceSet.new
    dice.roll(4, [2,3,4,6])
    assert_equal 0, dice.score()
  end

  def test_score_of_a_triple_1_is_1000
    dice = DiceSet.new
    dice.roll(3, [1,1,1])
    assert_equal 1000, dice.score()
  end

  def test_score_of_other_triples_is_100x
    dice = DiceSet.new
    dice.roll(3, [2,2,2])
    assert_equal 200, dice.score()

    dice = DiceSet.new
    dice.roll(3, [3,3,3])
    assert_equal 300, dice.score()

    dice = DiceSet.new
    dice.roll(3, [4,4,4])
    assert_equal 400, dice.score()

    dice = DiceSet.new
    dice.roll(3, [5,5,5])
    assert_equal 500, dice.score()

    dice = DiceSet.new
    dice.roll(3, [6,6,6])
    assert_equal 600, dice.score()
  end

  def test_score_of_mixed_is_sum
    dice = DiceSet.new
    dice.roll(5, [2,5,2,2,3])
    assert_equal 250, dice.score()

    dice = DiceSet.new
    dice.roll(4, [5,5,5,5])
    assert_equal 550, dice.score()

    dice = DiceSet.new
    dice.roll(4, [1,1,1,1])
    assert_equal 1100, dice.score()
    
    dice = DiceSet.new
    dice.roll(5, [1,1,1,1,1])
    assert_equal 1200, dice.score()

    dice = DiceSet.new
    dice.roll(5, [1,1,1,5,1])
    assert_equal 1150, dice.score()
  end

  def test_non_scoring_points
    dice = DiceSet.new
    dice.roll(5, [2,5,2,2,3])
    dice.score()
    assert_equal 1, dice.nonscoring()

    dice = DiceSet.new
    dice.roll(4, [5,5,5,5])
    dice.score()
    assert_equal 0, dice.nonscoring()

    dice = DiceSet.new
    dice.roll(4, [2,1,5,3,4])
    dice.score()
    assert_equal 3, dice.nonscoring()

    dice = DiceSet.new
    dice.roll(4, [6,6,5,5,2])
    dice.score()
    assert_equal 3, dice.nonscoring()

    dice = DiceSet.new
    dice.roll(4, [3,4,6,2,2])
    dice.score()
    assert_equal 5, dice.nonscoring()

    dice = DiceSet.new
    dice.roll(4, [1,1,1,1])
    dice.score()
    assert_equal 0, dice.nonscoring()
    
    dice = DiceSet.new
    dice.roll(5, [1,1,1,1,1])
    dice.score()
    assert_equal 0, dice.nonscoring()

    dice = DiceSet.new
    dice.roll(5, [1,1,1,5,1])
    dice.score()
    assert_equal 0, dice.nonscoring()
  end
end
