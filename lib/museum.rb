class Museum
  attr_reader :name, :exhibits, :patrons, :revenue, :patrons_of_exhibits

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    @revenue = 0
    @patrons_of_exhibits = {}
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    recommendations = []
    @exhibits.find_all do |exhibit|
      patron.interests.include?(exhibit.name)
    end

    ### challenge review: refactor #1
    # recommendations = []
    # @exhibits.find_all do |exhibit|
    #   patron.interests.any? do |interest|
    #     exhibit.name == interest
    #   end
    # end

    ### having an if statement is a hint that we should use find_all
    # recommendations = []
    # @exhibits.each do |exhibit|
    #   patron.interests.each do |interest|
    #     if exhibit.name == interest
    #       recommendations << exhibit
    #     end
    #   end
    # end
    # recommendations
  end

  def admit(patron)
    @patrons << patron

    # # refactor by moving all code below into patron.attend method to be called on here
    # exhibit_interest_objects = []
    #
    # @exhibits.each do |exhibit|
    #   patron.interests.each do |interest|
    #     if exhibit.name == interest
    #       exhibit_interest_objects << exhibit
    #     end
    #   end
    # end
    #
    # ordered_by_cost = exhibit_interest_objects.sort_by(&:cost).reverse
    #
    # ordered_by_cost.each do |exhibit|
    #   if exhibit.cost < patron.spending_money
    #     patron.spending_money -= exhibit.cost
    #     @revenue += exhibit.cost
    #   end
    # end
  end

  def exhibits_by_cost #added during challenge review #test not yet written
    @exhibits.sort_by do |exhibit|
      -exhibit.cost
    end
  end

  def patrons_by_exhibit_interest
    # @exhibits.reduce({}) do |exhibit_interests, exhibit|
    #   exhibit_interests[exhibit] = []
    #   @patrons.each do |patron|
    #     patron.interests.each do |interest|
    #       if exhibit.name == interest
    #         exhibit_interests[exhibit] << patron
    #       end
    #     end
    #   end
    #   exhibit_interests
    # end


    @exhibits.reduce({}) do |acc, exhibit|
      interested_patrons = @patrons.find_all do |patron|
        patron.interests.include?(exhibit.name)
      end
      acc[exhibit] = interested_patrons
      acc
    end

    # ### challenge walkthrough
    # patrons_by_exhibit = {}
    # @exhibits.each do |exhibit|
    #   patrons_by_exhibit[exhibit] = []
    #   interested_patrons = @patrons.find_all do |patron|
    #     patron.interests.include?(exhibit.name)
    #   end
    #   patrons_by_exhibit[exhibit] = interested_patrons
    # end
    # patrons_by_exhibit

    # #reduce builds a new collection using values of another collection, as opposed to other enums which return some translated version of the passed collection
    # return value of the block becomes the starting point for the next iteration
  end

  def ticket_lottery_contestants(exhibit)
    # @patrons.find_all do |patron|
    #   patron.spending_money < exhibit.cost && patron.interests.include?(exhibit.name)
    # end

    patrons_by_exhibit_interest[exhibit].find_all do |patron|
      patron.spending_money < exhibit.cost
    end
  end

  def draw_lottery_winner(exhibit)
    winner = ticket_lottery_contestants(exhibit).sample
    return winner.name if winner
  end

  def announce_lottery_winner(exhibit)
    winner = draw_lottery_winner(exhibit)
    return "No winners for this lottery" if winner.nil?
    "#{winner} has won the #{exhibit.name} exhibit lottery"

    # if winner
    #   "#{winner} has won the #{exhibit.name} exhibit lottery"
    # else
    #   "No winners for this lottery"
    # end
  end
end
