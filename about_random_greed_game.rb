class AboutGreed < Neo::Koan
  def test_random_play

    srand
    p1 = Player.new("Mabini", :aggr)
    p2 = Player.new("Reyes", :cons)
    p3 = Player.new("Loyola", :aggr)
    p4 = Player.new("Calero", :cons)
    p5 = Player.new("Santos", :aggr)

    @players = [ p1, p2, p3, p4, p5 ]
    g = Game.new( @players )

    g.play

    puts
    puts

    @players.each { | player |
      name = player.name
      turns = player.turns
      puts "#{player.name} scored #{player.points}"
    }
    puts "#{g.winner.name} wins!!!"
  end
end
