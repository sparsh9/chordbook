require "test_helper"

class GeneratedSetlistsTest < ActiveJob::TestCase
  test "updates setlists" do
    songsheets = 101.times.map { |i| create :songsheet, rank: i + 1 }

    GeneratedSetlists.perform_now

    trending = User.app.setlists.find_by!(title: "Trending")
    assert_equal 100, trending.songsheets.count

    # Update order
    old_1 = songsheets.first
    new_1 = songsheets.last

    old_1.update! rank: 101
    new_1.update! rank: 1

    GeneratedSetlists.new.perform

    assert_equal 100, trending.reload.songsheets.count
    assert_equal new_1, trending.songsheets.first
    refute_includes trending.songsheets, old_1
  end

  test "'Trending' includes top 100 songs by rank" do
    songsheets = 101.times.map { |i| create :songsheet, rank: i + 1 }

    GeneratedSetlists.new.perform

    setlist = User.app.setlists.find_by!(title: "Trending")
    assert_equal 100, setlist.songsheets.count
    refute_includes setlist.songsheets, songsheets.last
  end

  test "`What's New` includes recently created songsheets" do
    newer = create :songsheet
    older = create :songsheet, created_at: 3.months.ago

    GeneratedSetlists.new.perform

    setlist = User.app.setlists.find_by!(title: "What's New")

    assert_includes setlist.songsheets, newer
    refute_includes setlist.songsheets, older
  end
end
