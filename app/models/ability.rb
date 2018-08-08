class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.present?
      can [:show, :update, :destroy], User, id: user.id
      can [:index, :show], Product
      can [:index, :show], Order, user_id: user.id
      can :create, Comment
      if user.admin?
        can :manage, :all
      end
    end
  end
end
