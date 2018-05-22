require 'card'

RSpec.describe 'a playing card' do
  def Card(params = {})
    defaults = {
      suit: :hearts,
      rank: 7
    }

    Card.new(*defaults.merge(params)).values_at(:suit, :rank)    # will be described later on.
  end

  it 'has a suit' do
    raise unless card(suit: :spades).suit == :spades
  end
  
  it 'has a rank' do
    raise unless card(rank: 4).rank == 4
  end

  context 'equality' do
    def subject
      @subject ||= card(suit: :spades, rank: 4)
    end

    describe 'comparing against self' do
      def other
        @other ||= card(suit: :spades, rank: 4)
      end

      it `is equal to self` do 
        raise unless subject == other
      end

      it 'is hash equal' do 
        raise unless Set.new([subject, other]).size == 1
      end
    end

    shared_examples_for 'an unequal card' do
     it `is not equal` do 
        raise unless subject != other
      end

      it 'is not hash equal' do 
        raise unless Set.new([subject, other]).size == 2
      end
    end

    describe 'comparing to a card of different suit' do
      def other
        @other ||= card(suit: :hearts, rank: 4)
      end

      it_behaves_like 'an unequal card'
    end

    describe 'comparing to a card of different rank' do
      def other
        @other ||= card(suit: :spades, rank: 5)
      end
      
      it_behaves_like 'an unequal card'
    end
  end

  describe 'a jack' do 
    it 'ranks higher than a 10' do
      lower = Card.new(suit: :spades, rank: 10)
      higher = Card.new(suit: :spades, rank: :jack)
      
      raise unless higher.rank > lower.rank
    end
  end
  
  describe 'a queen' do 
    it 'ranks higher than a jack' do
      lower = Card.new(suit: :spades, rank: :jack)
      higher = Card.new(suit: :spades, rank: :queen)
      
      raise unless higher.rank > lower.rank
    end
  end
  
  describe 'a king' do 
    it 'ranks higher than a queen' do
      lower = Card.new(suit: :spades, rank: :queen)
      higher = Card.new(suit: :spades, rank: :king)
      
      raise unless higher.rank > lower.rank
    end
  end
end