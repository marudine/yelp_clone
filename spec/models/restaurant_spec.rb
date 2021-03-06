describe "restaurant" do
  it "is invalid for a restaurant name of less than three letters" do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it "is not valid unless it has a unique name" do
    Restaurant.create(name: "Moe's Tavern")
    restaurant = Restaurant.new(name: "Moe's Tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

  it "has many reviews" do
    restaurant = Restaurant.new(name: 'Burger King')
    expect(restaurant).to have_many(:reviews)
  end


end
