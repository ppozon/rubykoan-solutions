require "/Users/patty/ruby_koans/neo"

class StinkyFeet < Neo::Koan

    def private_method
       [ :twinkle, :twinkle, :little, :star ]
    end 

    private :private_method 

    def test_call_1
       private_method
    end

    def test_call_2
       self.private_method
    end
end

1 + 2
