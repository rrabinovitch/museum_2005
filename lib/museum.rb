class Museum
  attr_reader :name, :exhibits, :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
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
    # 
    # -{#<Exhibit:0xXXXXXX @name="Gems and Minerals", @cost=0>=>[#<Patron:0xXXXXXX @name="Bob", @spending_money=20, @interests=["Dead Sea Scrolls", "Gems and Minerals"]>], #<Exhibit:0xXXXXXX @name="Dead Sea Scrolls", @cost=10>=>[#<Patron:0xXXXXXX @name="Bob", @spending_money=20, @interests=["Dead Sea Scrolls", "Gems and Minerals"]>, #<Patron:0xXXXXXX @name="Johnny", @spending_money=5, @interests=["Dead Sea Scrolls"]>, #<Patron:0xXXXXXX @name="Sally", @spending_money=20, @interests=["IMAX"]>], #<Exhibit:0xXXXXXX @name="IMAX", @cost=15>=>[]}
    # +{#<Exhibit:0xXXXXXX @name="Gems and Minerals", @cost=0>=>[#<Patron:0xXXXXXX @name="Bob", @spending_money=20, @interests=["Dead Sea Scrolls", "Gems and Minerals"]>], #<Exhibit:0xXXXXXX @name="Dead Sea Scrolls", @cost=10>=>[#<Patron:0xXXXXXX @name="Bob", @spending_money=20, @interests=["Dead Sea Scrolls", "Gems and Minerals"]>, #<Patron:0xXXXXXX @name="Johnny", @spending_money=5, @interests=["Dead Sea Scrolls"]>], #<Exhibit:0xXXXXXX @name="IMAX", @cost=15>=>[#<Patron:0xXXXXXX @name="Sally", @spending_money=20, @interests=["IMAX"]>]}






  end
end
