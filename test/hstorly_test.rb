require 'test_helper'

describe Hstorly do
  describe "version" do
    it "has a version" do
     assert ::Hstorly::VERSION
    end
  end
  describe "database setup" do
    before(:each) do
      setup_db
    end

    after(:each) do
      teardown_db
    end

    it "has access to the database" do
      AbstractPost.create
      assert_equal 1, AbstractPost.count
    end
  end

  describe "hstore_translate" do
    before(:each) do
      setup_db
    end

    after(:each) do
      teardown_db
    end

    describe "#title" do
      it "returns a string" do
        assert_equal String, TestPost.new.title.class
      end

      it "returns the title for the given locale" do
        I18n.locale = :de
        post = TestPost.new(title: "hans")
        assert_equal "hans", post.title
        I18n.locale = :en
        post.title_en = "wurst"
        assert_equal "wurst", post.title
      end

      it "returns the title for the given locale" do
        I18n.locale = :en
        post = TestPost.new(title: "wurst")
        assert_equal "wurst", post.title
        I18n.locale = :de
        post.title_de = "wurst"
        assert_equal "wurst", post.title
      end
    end

    describe "#title_en" do
      it "sets the title for the language" do
        I18n.locale = :de
        post = TestPost.new(title_en: "wurst")
        assert_equal "wurst", post.title_before_type_cast["en"]
      end
      it "reads the title for the language" do
        I18n.locale = :de
        post = TestPost.new(title_en: "wurst")
        assert_equal "wurst", post.title_en
      end
    end

  end
end
