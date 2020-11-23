require "test_helper"

describe Category do
  let(:category) {
    Category.new(name: "test category")
  }
  describe "Validations" do
    it "is valid with all fields present" do
      expect(category.valid?).must_equal true
    end

    it "is invalid when there is no name" do
      category.name = nil
      expect(category.valid?).must_equal false
    end

    it "is invalid when if name of the category already exists" do
      original = category.save!
      copy = Category.new(name: "test category")
      expect(copy.valid?).must_equal false
    end
  end

  describe "Relationships" do
    it "can have many products" do
      fun = categories(:fun)
      expect(fun.products.count).must_equal 3

      fun.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end

    it "can set products" do
      romantic = categories(:romantic)
      disney = products(:disney)

      expect {
        romantic.products << disney
      }.must_differ "romantic.products.count", 1

      expect(romantic.products).must_include disney

    end

    it "can belong to many products" do
      japan = products(:japan)
      hawaii = products(:hawaii)
      adventure = categories(:adventure)

      japan.categories << adventure
      hawaii.categories << adventure

      expect(japan.categories).must_include adventure
      expect(hawaii.categories).must_include adventure

    end
  end


end
