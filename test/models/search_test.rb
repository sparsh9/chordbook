require "test_helper"

class SearchTest < ActiveSupport::TestCase
  setup do
    Searchkick.enable_callbacks
    @artist = create(:artist, name: "Ed Sheeran")
    @album = create(:album, title: "=", artist: @artist)
    @track = create(:track, title: "Shivers", album: @album)
    @songsheet = create(:songsheet, title: "Bad Habits", metadata: {artist: @artist.name},
      track: create(:track, title: "Bad Habits", album: @album, artist: @artist))
  end

  teardown do
    Searchkick.disable_callbacks
  end

  def search(query, **options)
    Search.reindex
    Search.new(query: query, **options).results
  end

  test "search track and artist" do
    assert_includes search("Bad Habits Ed Sheeran"), @songsheet
  end

  test "search artist includes songsheets, albums, and tracks" do
    results = search("Ed Sheeran")

    [@artist, @songsheet, @album, @track].each do |record|
      assert_includes results, record
    end
  end

  test "excludes tracks with songsheets" do
    Search.reindex
    results = search("Bad Habits")

    assert_includes results, @songsheet
    refute_includes results, @songsheet.track
  end
end
