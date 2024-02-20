# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      # User can read articles and products
      can :read, [Article, Product]

      # User can create, read, update, and destroy their own comments
      can [:create, :read, :update, :destroy], Comment, user_id: user.id

      # User can create comments on articles and products
      # can :create, Comment, commentable_type: ['Article', 'Product']
    end
  end
end
