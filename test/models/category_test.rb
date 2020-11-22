require "test_helper"

describe Category do
  let(:category) {
    Category.new(name: "test category")
  }
  describe "Validations" do
    it "is valid with all fields present" do

    end

    it "is invalid when there is no name" do

    end

    it "is invalid when if name of the category already exists" do

    end
  end

  describe "Relationships" do
    it "can have many products" do

    end

    it "can belong to many products" do

    end
  end


end
