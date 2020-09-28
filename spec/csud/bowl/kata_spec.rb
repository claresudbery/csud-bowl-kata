require_relative '../../../lib/csud/bowl/kata/bowling'

RSpec.describe Csud::Bowl::Kata do
  it "has a version number" do
    expect(Csud::Bowl::Kata::VERSION).not_to be nil
  end

  it "returns zero score when all rolls are misses" do
      bowling = Bowling.new
      zero_scoring_rolls = "-- -- -- -- -- -- -- -- -- --"
      expected_score = 0

      expect(bowling.score(zero_scoring_rolls)).to eq(expected_score)
  end

  expected_scores_no_spares_no_strikes = {
      "44 44 44 44 44 44 44 44 44 44" => 80,
      "22 22 22 22 22 22 22 22 22 22" => 40,
      "12 34 54 63 72 -- 9- 6- 8- 1-" => 61
  }

  expected_scores_no_spares_no_strikes.each do |rolls, score|
      it "adds rolls in '#{rolls}' to score #{score}, because all rolls knock some (but not all) pins down" do
          bowling = Bowling.new            
          expect(bowling.score(rolls)).to eq(score)
      end
  end

  expected_scores_with_spares_no_strikes = {
      "5/ 44 44 44 44 44 44 44 44 44" => 10 + 4 + (9*8),
      "5/ 5/ 44 44 44 44 44 44 44 44" => (10*2) + (5+4) + (8*8),
      "44 44 5/ 5/ 44 44 44 44 44 44" => (10*2) + (5+4) + (8*8),
      "44 44 4/ 9/ 44 44 44 44 44 44" => (10*2) + (9+4) + (8*8),
      "42 62 3/ 14 5/ 9/ 33 2/ 11 11" => (1+9+3+1) + (6+8+10+5+10+10+6+10+2+2),
      "4/ -2 3/ 41 5/ 9/ 3- 2/ -- 11" => (0+4+9+3+0) + (10+2+10+5+10+10+3+10+0+2),
      "44 44 -/ 44 44 44 44 44 44 44" => (9*8) + (10+4)
  }

  expected_scores_with_spares_no_strikes.each do |rolls, score|
      it "adds ten to the score, plus pins from the next roll, when all pins felled in one frame: '#{rolls}'" do
          bowling = Bowling.new            
          expect(bowling.score(rolls)).to eq(score)
      end
  end

  expected_scores_with_strikes_no_spares = {
      "X 44 44 44 44 44 44 44 44 44" => 10 + 8 + (9*8),
      "X 44 X 44 44 44 44 44 44 44" => (10*2) + (8+8) + (8*8),
      "44 44 X 44 X 44 44 44 44 44" => (10*2) + (8+8) + (8*8),
      "42 62 X 14 X 11 X 33 X 11" => (5+2+6+2) + (6+8+10+5+10+2+10+6+10+2),
      "4- -2 X 14 X 11 X 33 X --" => (5+2+6+0) + (4+2+10+5+10+2+10+6+10+0),
      "X -2 X 41 X 81 3- X -- 11" => (2+5+9+0) + (10+2+10+5+10+9+3+10+0+2)
  }

  expected_scores_with_strikes_no_spares.each do |rolls, score|
      it "adds ten to the score, plus pins from the next two rolls, when there is a strike: '#{rolls}'" do
          bowling = Bowling.new            
          expect(bowling.score(rolls)).to eq(score)
      end
  end
  
  expected_scores_with_strikes_followed_by_strikes = {
      "X X 44 44 44 44 44 44 44 44" => (10*2) + (14+8) + (8*8),
      "X X -4 44 44 44 44 44 44 44" => (10*2) + (10+4) + (4+(7*8)),
      "X X 4- 44 44 44 44 44 44 44" => (10*2) + (14+4) + (4+(7*8)),
      "X X -- 44 44 44 44 44 44 44" => (10*2) + (10+0) + (7*8),
      "X X X 44 44 44 44 44 44 44" => (10*3) + (20+14+8) + (8*7),
      "X X X 44 X X 44 44 44 44" => (10*5) + (20+14+8+14+8) + (8*5)
  }

  expected_scores_with_strikes_followed_by_strikes.each do |rolls, score|
      it "adds ten to the score, plus pins from the next two rolls, when there are multiple strikes in a row: '#{rolls}'" do
      bowling = Bowling.new            
          expect(bowling.score(rolls)).to eq(score)
      end
end
  
  it "adds ten to the score, plus another ten, when a spare is followed by a strike" do
      bowling = Bowling.new
      spare_followed_by_strike = "3/ X 44 44 44 44 44 44 44 44"
      expected_score = (10+10) + (10+8) + (8*8)

      expect(bowling.score(spare_followed_by_strike)).to eq(expected_score)
  end

  expected_scores_with_strikes_and_spares = {
      "X 44 5/ 44 X 44 5/ 44 X 44" => (10*5) + (8+8+8) + (4+4) + (8*5),
      "X 5/ X 4/ X 8/ X 1/ X 44" => (9*10) + 8 + ((4*10)+8) + (4*10),
      "X X 5/ 4/ X X 8/ 1/ X 44" => (9*10) + 8 + (15+10+18+10+8) + (4+10+1+10)
  }

  expected_scores_with_strikes_and_spares.each do |rolls, score|
      it "adds pins only for the relevant scores when there is a mixture of strikes and spares: '#{rolls}'" do
          bowling = Bowling.new            
          expect(bowling.score(rolls)).to eq(score)
      end
  end

  expected_scores_with_a_spare_in_the_tenth_frame = {
      "44 44 44 44 44 44 44 44 44 4/ 3" => (9*8) + (10+3),
      "44 44 44 44 44 44 44 44 44 4/ X" => (9*8) + (10+10),
      "44 44 44 44 44 44 44 44 44 4/ -" => (9*8) + (10+0)
  }

  expected_scores_with_a_spare_in_the_tenth_frame.each do |rolls, score|
      it "adds the final roll to the score twice, when a spare is rolled in the final frame: '#{rolls}'" do
          bowling = Bowling.new            
          expect(bowling.score(rolls)).to eq(score)
      end
  end

  expected_scores_with_a_strike_in_the_tenth_frame = {
      "44 44 44 44 44 44 44 44 44 X 32" => (9*8) + (10+3+2),
      "44 44 44 44 44 44 44 44 44 X X-" => (9*8) + (10+10+0),
      "44 44 44 44 44 44 44 44 44 X -X" => (9*8) + (10+0+10),
      "44 44 44 44 44 44 44 44 44 X XX" => (9*8) + (10+10+10),
      "44 44 44 44 44 44 44 44 44 X 46" => (9*8) + (10+4+6),
      "44 44 44 44 44 44 44 44 44 X 6-" => (9*8) + (10+6+0),
      "44 44 44 44 44 44 44 44 44 X -3" => (9*8) + (10+0+3),
      "44 44 44 44 44 44 44 44 44 X --" => (9*8) + (10+0+0),
      "44 44 44 44 44 44 44 44 44 X 2-" => (9*8) + (10+2+0),
      "44 44 44 44 44 44 44 44 44 X -5" => (9*8) + (10+0+5)
  }

  expected_scores_with_a_strike_in_the_tenth_frame.each do |rolls, score|
      it "adds the final two rolls to the score twice, when a strike is rolled in the final frame: '#{rolls}'" do
          bowling = Bowling.new            
          expect(bowling.score(rolls)).to eq(score)
      end
  end
end
