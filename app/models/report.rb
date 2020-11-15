class Report < ApplicationRecord
  validates :key, presence: true,
                  uniqueness: { scope: :hostname }
  validates :date, presence: true
  validates :hostname, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :severity, presence: true

  enum category: %i(security ux links best_practice)
  enum severity: %i(info low normal high)
end
