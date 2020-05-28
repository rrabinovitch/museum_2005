class Museum
  attr_reader :name, :exhibits, :patrons, :revenue

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    @revenue = 0
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    #refactor if time
    recommendations = []
    @exhibits.each do |exhibit|
      patron.interests.each do |interest|
        if exhibit.name == interest
          recommendations << exhibit
        end
      end
    end
    recommendations
  end

  def admit(patron)
    @patrons << patron

    # refactor by moving all code below into patron.attend method to be called on here
    exhibit_interest_objects = []

    @exhibits.each do |exhibit|
      patron.interests.each do |interest|
        if exhibit.name == interest
          exhibit_interest_objects << exhibit
        end
      end
    end

    ordered_by_cost = exhibit_interest_objects.sort_by(&:cost).reverse

    ordered_by_cost.each do |exhibit|
      if exhibit.cost < patron.spending_money
        patron.spending_money -= exhibit.cost
        @revenue += exhibit.cost
      end
    end
  end

  def patrons_by_exhibit_interest
    @exhibits.reduce({}) do |exhibit_interests, exhibit|
      exhibit_interests[exhibit] = []
      @patrons.each do |patron|
        patron.interests.each do |interest|
          if exhibit.name == interest
            exhibit_interests[exhibit] << patron
          end
        end
      end
      exhibit_interests
    end
  end

  def ticket_lottery_contestants(exhibit)
    @patrons.find_all do |patron|
      patron.spending_money < exhibit.cost && patron.interests.include?(exhibit.name)
    end
  end

  def draw_lottery_winner(exhibit)
    winner = ticket_lottery_contestants(exhibit).sample
    return winner.name if winner
  end

  def announce_lottery_winner(exhibit)
    winner = draw_lottery_winner(exhibit)
    if winner
      "#{winner} has won the IMAX edhibit lottery"
    else
      "No winners for this lottery"
    end
  end
end
