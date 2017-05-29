class SkuGroup < ApplicationRecord
	scope :others, -> {where.not(group: 4)}
	scope :ours, -> {where(group: 4)} 
end
