require File.dirname(__FILE__) + '/../test_helper'

class EventFindersTest < Test::Unit::TestCase
  class Community < ActiveRecord::Base
    has_many :parties
  end

  class Party < ActiveRecord::Base
    belongs_to :community
    event_finders
  end

  # Tests

  def setup
    @fun_community = create_community!('Rubyists')
    @fun_parties = (0..9).map {|i| create_party!(@fun_community, i)}

    @boring_community = create_community!('Librarians')
    @boring_parties = (0..4).map {|i| create_party!(@boring_community, i)}
  end

  # in_date_range

  def test_should_return_all_parties_in_date_range_when_not_scoped
    expected = @fun_parties.length + @boring_parties.length
    actual = Party.in_date_range(Time.now..10.days.from_now).length
    assert_equal expected, actual
  end

  def test_should_return_only_fun_parties_in_date_range_when_scoped_to_community
    actual = @fun_community.parties.in_date_range(Time.now..10.days.from_now)
    assert_equal @fun_parties, actual
  end
  
  # in_month_with_outliers

  def test_should_return_any_parties_in_month_with_outliers_when_not_scoped
    expected = Community.all.map(&:id)
    actual = Party.in_month_with_outliers.map(&:community_id).uniq
    assert_equal expected, actual
  end

  def test_should_return_only_fun_parties_in_month_with_outliers_when_scoped
    parties = @fun_community.parties.in_month_with_outliers
    assert_equal [@fun_community.id], parties.map(&:community_id).uniq
  end

  # on_date

  def test_should_return_any_parties_on_date_when_not_scoped
    expected = Community.all.map(&:id)
    actual = Party.on_date.map(&:community_id).uniq
    assert_equal expected, actual
  end

  def test_should_return_only_fun_parties_on_date_when_scoped
    parties = @fun_community.parties.on_date
    assert_equal [@fun_community.id], parties.map(&:community_id).uniq
  end

  # in_month

  def test_should_return_any_parties_in_month_when_not_scoped
    expected = Community.all.map(&:id)
    actual = Party.in_month.map(&:community_id).uniq
    assert_equal expected, actual
  end

  def test_should_return_only_fun_parties_in_month_when_scoped
    parties = @fun_community.parties.in_month
    assert_equal [@fun_community.id], parties.map(&:community_id).uniq
  end
  
  # in_rolling_month

  def test_should_return_any_parties_in_rolling_month_when_not_scoped
    expected = Community.all.map(&:id)
    actual = Party.in_rolling_month.map(&:community_id).uniq
    assert_equal expected, actual
  end

  def test_should_return_only_fun_parties_in_rolling_month_when_scoped
    parties = @fun_community.parties.in_rolling_month
    assert_equal [@fun_community.id], parties.map(&:community_id).uniq
  end

private

  def create_community!(name)
    Community.create!(:name => name)
  end

  def create_party!(community, day_offset)
    date = day_offset.days.from_now
    Party.create!(:begin_at => date, :end_at => date, :community => community)
  end
end
