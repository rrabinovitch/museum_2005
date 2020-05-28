require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/exhibit'
require './lib/patron'
require './lib/museum'

class MuseumTest < Minitest::Test
  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")

    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_a_name
    assert_equal "Denver Museum of Nature and Science", @dmns.name
  end

  def test_it_starts_with_no_exhibits_and_no_patrons
    assert_equal [], @dmns.exhibits
    assert_equal [], @dmns.patrons
    assert_equal ({}), @dmns.patrons_of_exhibits
  end

  def test_exhibits_can_be_added
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    exhibits_list = [@gems_and_minerals, @dead_sea_scrolls, @imax]

    assert_equal exhibits_list, @dmns.exhibits
  end

  def test_it_can_recommend_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    patron_1 = Patron.new("Bob", 20)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("Gems and Minerals")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")

    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(patron_1)
    assert_equal [@imax], @dmns.recommend_exhibits(patron_2)
  end

  def test_it_can_admit_patrons
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(patron_3)

    assert_equal [patron_1, patron_2, patron_3], @dmns.patrons
  end

  def test_it_can_list_patrons_by_exhibit_interest
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(patron_3)

    exhibit_interests = {@gems_and_minerals => [patron_1],
                        @dead_sea_scrolls => [patron_1, patron_2, patron_3],
                        @imax => []}
    assert_equal exhibit_interests, @dmns.patrons_by_exhibit_interest
  end

  def test_it_can_select_lottery_contestants
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(patron_3)

    assert_equal [patron_1, patron_3], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)
  end

  def test_there_are_no_contestants_if_none_interested_in_exhibit
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(@patron_3)

    assert_empty @dmns.ticket_lottery_contestants(@imax)
  end

  def test_it_can_draw_a_lottery_winner
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(patron_3)

    lottery_contestants = [patron_1.name, patron_3.name]
    lottery_winner = @dmns.draw_lottery_winner(@dead_sea_scrolls)

    assert_equal true, lottery_contestants.include?(lottery_winner)
    assert_equal false, lottery_contestants.include?(patron_2.name)
    assert_nil @dmns.draw_lottery_winner(@imax)
  end

  def test_it_can_announce_lottery_winner
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(patron_3)

    @dmns.stubs(:draw_lottery_winner).returns(patron_1.name)
    announcement = "Bob has won the Gems and Minerals exhibit lottery"
    assert_equal announcement, @dmns.announce_lottery_winner(@gems_and_minerals)
  end

  def test_it_doesnt_report_a_winner_if_no_contestants
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(@patron_3)

    announcement = "No winners for this lottery"
    assert_equal announcement, @dmns.announce_lottery_winner(@imax)
  end

  def test_patrons_attend_exhibits_they_can_afford_and_increase_revenue
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)

    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(tj)

    assert_equal 7, tj.spending_money
    # assert_equal 0, @dmns.revenue

    patron_1 = Patron.new("Bob", 10)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("IMAX")
    @dmns.admit(patron_1)

    assert_equal 10, patron_1.spending_money
    # assert_equal 10, @dmns.revenue

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")
    patron_2.add_interest("Dead Sea Scrolls")
    @dmns.admit(patron_2)

    assert_equal 5, patron_2.spending_money
    # assert_equal 25, @dmns.revenue

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(morgan)

    assert_equal 5, morgan.spending_money
    # assert_equal 35, @dmns.revenue
  end

  def test_it_can_list_patrons_by_exhibit
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)

    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(tj)

    patron_1 = Patron.new("Bob", 10)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("IMAX")
    @dmns.admit(patron_1)

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")
    patron_2.add_interest("Dead Sea Scrolls")
    @dmns.admit(patron_2)

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(morgan)

    expected = {
      @gems_and_minerals => [morgan],
      @dead_sea_scrolls => [patron_1, morgan],
      @imax => [patron_2]
    }

    assert_equal expected, @dmns.patrons_of_exhibits
  end

  def test_admitting_patrons_increases_revenue
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)

    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(tj)

    assert_equal 0, @dmns.revenue

    patron_1 = Patron.new("Bob", 10)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("IMAX")
    @dmns.admit(patron_1)

    assert_equal 10, @dmns.revenue

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")
    patron_2.add_interest("Dead Sea Scrolls")
    @dmns.admit(patron_2)

    # assert_equal 25, @dmns.revenue

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(morgan)

    # assert_equal 35, @dmns.revenue
  end


# patron_1 => dead sea scrolls => 10
# patron_2 => imax => 15
# patron_3 => gems&mins + dead sea scrolls => 10

  # * When the Patron attends an `Exhibit`, the cost of the `Exhibit`
  # =>  should be subtracted from their `spending_money` and added to
  # =>  the `Museum` revenue.

  # * A `Museum` should have a `patrons_of_exhibits` method that returns
  # =>  a Hash where the keys are the exhibits and the values are Arrays
  # =>  containing all the `Patrons` that attended that `Exhibit`.

  # * A `Museum` should have a method `revenue` that returns an Integer
  # =>  representing the revenue collected from `Patrons` attending `Exhibits`.

end
