require 'active_record'
require 'whitelist_scope'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :sortable_items, force: true do |t|
    t.string :name
    t.datetime "created_at",  null: false
  end
  create_table :combinable_scopes, force: true do |t|
    t.boolean :pending, null: false, default: false
    t.boolean :featured, null: false, default: false
  end
end

class SortableItem < ActiveRecord::Base
  extend WhitelistScope

  whitelist_scope :alphabetical, -> { order("name ASC") }
  whitelist_scope :recent, -> { order("created_at DESC") }
end

class ItemWithBadDefault < ActiveRecord::Base
  extend WhitelistScope

  whitelist_scope :something_here, -> { order(:created_at) }
end

class CombinableScopes < ActiveRecord::Base
  extend WhitelistScope

  whitelist_scope :pending, -> { where(pending: true) }
  whitelist_scope :featured, -> {where(featured: true) }
end

describe WhitelistScope do
  it "should return a list of whitelisted scopes" do
    expect(SortableItem.whitelist).to eq [:alphabetical, :recent]
  end

  it "should raise an error when the scope doesn't exist" do
    expect{ SortableItem.call_whitelisted_scope("fake_option") }.to raise_error "The scope you provided, 'fake_option', does not exist."
  end

  it "should raise an argument error when an invalid scope is specified" do
    expect{
      class BrokenSortOption < ActiveRecord::Base
        extend WhitelistScope

        whitelist_scope :destroy, -> { order("created_at ASC") }
      end
    }.to raise_error ArgumentError
  end

  context "sorting scopes" do
    before(:each) do
      @item1 = SortableItem.create(name: "First Item")
      @item2 = SortableItem.create(name: "Second Item")
      @item3 = SortableItem.create(name: "Last Item")
    end

    after(:each) do
      SortableItem.destroy_all
    end

    it "should correctly call a whitelisted scope" do
      @sorted = SortableItem.call_whitelisted_scope("recent")
      expect(@sorted.map(&:name)).to eq ["Last Item", "Second Item", "First Item"]
    end
  end

  context "combinable scopes" do
    before(:each) do
      @item1 = CombinableScopes.create(pending: true)
      @item2 = CombinableScopes.create(featured: true)
      @item3 = CombinableScopes.create(pending: true, featured: true)
    end

    after(:each) do
      CombinableScopes.destroy_all
    end

    it 'should allow calling multiple scopes' do
      @pending = CombinableScopes.call_whitelisted_scope("pending")
      @featured = CombinableScopes.call_whitelisted_scope("featured")
      @pending_and_featured = CombinableScopes.call_whitelisted_scope("pending", "featured")
      expect(@pending.count).to eq 2
      expect(@featured.count).to eq 2
      expect(@pending_and_featured.count).to eq 1
    end
  end
end
