class Order < ApplicationRecord
    scope :accepted, -> {where(state: "accepted")}
    scope :producing, -> {where(state: "producing")}
end
