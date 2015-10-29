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
      it "allows setting the value again after it was set already" do
        I18n.locale = :en
        post = TestPost.new(title_en: "wurst")
        post.title = "hans"
        assert_equal "hans", post.title
      end
    end

    describe "#setting a hash" do
      it "allows setting a hash" do
        post = TestPost.new
        translations_hash = {"en" => "foobar", "de" => "foobarde"}
        post.title = translations_hash
        assert_equal "foobar", post.title_en
        assert_equal "foobarde", post.title_de
        assert_equal translations_hash, post.title_before_type_cast
      end
    end

    describe "#save" do
      it "saved the data properly and is still there after reload" do
        I18n.locale = :en
        post = TestPost.new(title: "wurst")
        post.save!
        assert_equal "wurst", post.reload.title_en
      end
    end

  end
end
