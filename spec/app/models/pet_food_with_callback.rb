class PetFoodWithCallback

  include Dynameister::Document

  field :valid_until, :datetime
  field :created_at,  :time
  field :deliver_at,  :time

  before_save :ensure_the_food_is_still_valid

  private

  def ensure_the_food_is_still_valid
    self.valid_until ||= ::Time.now + 7.days
    return false if valid_until.past?
  end

end
