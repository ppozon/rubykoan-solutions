class AboutGreed < Neo::Koan
  def test_random_play

    srand
    p7 = Player.new("Napoles", :aggr)
    p6 = Player.new("Estrada", :aggr)
    p5 = Player.new("Santos", :aggr)
    p4 = Player.new("Calero", :cons)
    p2 = Player.new("Reyes", :cons)
    p1 = Player.new("Mabini", :aggr)
    p3 = Player.new("Loyola", :aggr)

    @players = [ p1, p2, p3, p4, p5, p6, p7 ]
    g = Game.new( @players )

    g.play

    puts
    puts
    puts "This changes the output when run from the commandline."

    @players.each { | player |
      name = player.name
      turns = player.turns
      puts "#{player.name} scored #{player.points}"
    }
    puts "#{g.winner.name} wins!!!"
  end
end
