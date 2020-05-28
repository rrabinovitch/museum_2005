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
    skip
    assert_instance_of Museum, @dmns
  end

  def test_it_has_a_name
    skip
    assert_equal "Denver Museum of Nature and Science", @dmns.name
  end

  def test_it_starts_with_no_exhibits_and_no_patrons
    skip
    assert_empty @dmns.exhibits
    assert_empty @dmns.patrons
  end

  def test_exhibits_can_be_added
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    exhibits_list = [@gems_and_minerals, @dead_sea_scrolls, @imax]

    assert_equal exhibits_list, @dmns.exhibits
  end

  def test_it_can_recommend_exhibits
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 20)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("IMAX")

    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@patron_1)
    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)
  end

  def test_it_can_admit_patrons
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons
  end

  def test_it_can_list_patrons_by_exhibit_interest
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    exhibit_interests = {@gems_and_minerals => [@patron_1],
                        @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
                        @imax => []}
    assert_equal exhibit_interests, @dmns.patrons_by_exhibit_interest
  end

  def test_it_can_select_lottery_contestants
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal [@patron_1, @patron_3], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)
  end

  def test_there_are_no_contestants_if_none_interested_in_exhibit
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_empty @dmns.ticket_lottery_contestants(@imax)
  end

  def test_it_can_draw_a_lottery_winner
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    lottery_contestants = [@patron_1.name, @patron_3.name]
    lottery_winner = @dmns.draw_lottery_winner(@dead_sea_scrolls)

    assert_equal true, lottery_contestants.include?(lottery_winner)
    assert_equal false, lottery_contestants.include?(@patron_2.name)
    assert_nil @dmns.draw_lottery_winner(@imax)
  end

  def test_it_can_announce_lottery_winner
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    @dmns.stubs(:draw_lottery_winner).returns("Bob")
    announcement = "Bob has won the IMAX edhibit lottery"
    assert_equal announcement, @dmns.announce_lottery_winner(@gems_and_minerals)
  end

  def test_it_doesnt_report_a_winner_if_no_contestants
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1 = Patron.new("Bob", 0)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    announcement = "No winners for this lottery"
    assert_equal announcement, @dmns.announce_lottery_winner(@imax)
  end

  def test_patron_without_enough_money_cant_attend_exhibit
    skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)

    @tj = Patron.new("TJ", 7)
    @tj.add_interest("IMAX")
    @tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(@tj)

    assert_equal 7, @tj.spending_money
  end

  def test_patrons_only_attend_exhibits_they_have_enough_money_for
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)

    @patron_1 = Patron.new("Bob", 10)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("IMAX")
    @dmns.admit(@patron_1)

    assert_equal 10, @patron_1.spending_money

    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("IMAX")
    @patron_2.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_2)

    assert_equal 5, @patron_2.spending_money

    @morgan = Patron.new("Morgan", 15)
    @morgan.add_interest("Gems and Minerals")
    @morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(@morgan)

    assert_equal 5, @morgan.spending_money
  end

  # * When a `Patron` is admitted to the `Museum`, they attend `Exhibits`.
  # => The `Exhibits` that a `Patron` attends follows these rules:

  # * A Patron will only attend `Exhibits` they are interested in

  # * A Patron will attend an `Exhibit` with a higher cost before an
  # => `Exhibit` with a lower cost.

  # * If a `Patron` does not have enough `spending_money` to cover
  # => the cost of the `Exhbit`, they will not attend the `Exhibit`.

  # * When the Patron attends an `Exhibit`, the cost of the `Exhibit`
  # =>  should be subtracted from their `spending_money` and added to
  # =>  the `Museum` revenue.

  # * A `Museum` should have a `patrons_of_exhibits` method that returns
  # =>  a Hash where the keys are the exhibits and the values are Arrays
  # =>  containing all the `Patrons` that attended that `Exhibit`.

  # * A `Museum` should have a method `revenue` that returns an Integer
  # =>  representing the revenue collected from `Patrons` attending `Exhibits`.

end
