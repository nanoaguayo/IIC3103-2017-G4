class Order < ApplicationRecord
    scope :accepted, -> {where(state: "accepted")}
end
