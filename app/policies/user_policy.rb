class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def update?
    record == user
  end

  def payment?
    record == user
  end
  
  def payout?
    record == user
  end

  def add_card?
    record == user
  end
end
