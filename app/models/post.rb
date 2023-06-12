class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy

    validates :title, presence: true
    validates :content, presence: true
    def self.ransackable_attributes(auth_object = nil)
        ["content", "created_at", "id", "title", "updated_at", "user_id"]
    end
end
