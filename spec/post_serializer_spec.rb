require "date"
require_relative "spec_helper"
require_relative "../app/post"
require_relative "../app/post_serializer"

RSpec.describe PostSerializer do
  subject { described_class.new(post) }

  let(:post) do
    Post.new(1, "2020 is the year of Ruby!", Date.new(2020, 1, 1))
  end

  it "serializes object" do
    expect(subject.serialize).to eq({
      id: 1,
      title: "2020 is the year of Ruby!",
      date: "01-01-2020",
    })
  end

  # nouveau test de Johann à rajouter dans post_serializer_spec.rb
  it 'does not leak object to other classes' do
    fake_post = Post.new(2, "2021 is the year of Ruby!", Date.new(2021, 1, 2))
    real_serializer = subject
    # If you used class variables, this next line will override the real serializer's object
    # with the fake post object.
    fake_serializer = described_class.new(fake_post)
    expect(real_serializer.serialize).to eq(
     {
        id: 1,
        title: "2020 is the year of Ruby!",
        date: "01-01-2020",
      }
   )
  end
end
