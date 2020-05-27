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




    -{
      #<Exhibit:0xXXXXXX @name="Gems and Minerals", @cost=0>=>
        [#<Patron:0xXXXXXX @name="Bob", @spending_money=20, @interests=["Dead Sea Scrolls", "Gems and Minerals"]>],
      #<Exhibit:0xXXXXXX @name="Dead Sea Scrolls", @cost=10>=>
        [#<Patron:0xXXXXXX @name="Bob", @spending_money=20, @interests=["Dead Sea Scrolls", "Gems and Minerals"]>,
         #<Patron:0xXXXXXX @name="Johnny", @spending_money=5, @interests=["Dead Sea Scrolls"]>,
         #<Patron:0xXXXXXX @name="Johnny", @spending_money=5, @interests=["Dead Sea Scrolls"]>],
      #<Exhibit:0xXXXXXX @name="IMAX", @cost=15>=>[]}
    +{#<Exhibit:0xXXXXXX @name="Gems and Minerals", @cost=0>=>
        [#<Patron:0xXXXXXX @name="Bob", @spending_money=20, @interests=["Dead Sea Scrolls", "Gems and Minerals"]>],
      #<Exhibit:0xXXXXXX @name="Dead Sea Scrolls", @cost=10>=>
        [#<Patron:0xXXXXXX @name="Bob", @spending_money=20, @interests=["Dead Sea Scrolls", "Gems and Minerals"]>,
         #<Patron:0xXXXXXX @name="Johnny", @spending_money=5, @interests=["Dead Sea Scrolls"]>],
      #<Exhibit:0xXXXXXX @name="IMAX", @cost=15>=>[#<Patron:0xXXXXXX @name="Sally", @spending_money=20, @interests=["IMAX"]>]}


      ### incomplete attempt
    # exhibit_interests = {}
    #
    # @exhibits.each do |exhibit|
    #   exhibit_interests[exhibit] = []
    # end
    #
    # @exhibits.each do |exhibit|
    #   @patrons.each do |patron|
    #     patron.interests.each do |interest|
    #       if exhibit.name == interest
    #         exhibit_interests[exhibit] = [patron]
    #       end
    #     end
    #   end
    # end
    #
    # exhibit_interests
#######
    # exhibit_interests = {}
    #
    # @exhibits.each do |exhibit|
    #   exhibit_interests[exhibit] = []
    # end
    #
    # exhibit_interests.each do |exhibit, interested_patrons|
    #   @patrons.each do |patron|
    #     patron.interests.each do |interest|
    #       if exhibit.name == interest && exhibit_interests[exhibit].nil?
    #         exhibit_interests[exhibit] = [patron]
    #       elsif exhibit.name == interest
    #         exhibit_interests[exhibit] << patron
    #       end
    #     end
    #   end
    #
    #   exhibit_interests
    # end

########
    # exhibit_interests = {}
    #
    # @exhibits.each do |exhibit|
    #   @patrons.each do |patron|
    #     patron.interests.each do |interest|
    #       if exhibit_interests[exhibit].nil? && exhibit.name == interest
    #         exhibit_interests[exhibit] = [patron]
    #       elsif exhibit.name == intersts
    #         exhibit_interests[exhibit] << patron
    #       else
    #         exhibit_interests[exhibit] = []
    #       end
    #     end
    #   end
    # end
    # exhibit_interests


########
  #   @exhibits.reduce({}) do |exhibit_interests, exhibit|
  #     @patrons.each do |patron|
  #       if patron.intersests.include?(exhibit.name) && exhibit_interests[exhibit].nil?
  #         exhibit_interests[exhibit] = [patron]
  #       elsif patron.intersests.include?(exhibit.name) && !exhibit_interests[exhibit].nil?
  #         exhibit_interests[exhibit] << patron
  #       end
  #     end
  #     exhibit_interests
  #   end
  end
end
